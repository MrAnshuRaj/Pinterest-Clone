import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/clerk_config.dart';
import '../../application/auth_providers.dart';
import '../../data/services/clerk_auth_service.dart';
import '../../../inbox/application/inbox_providers.dart';
import '../../../profile/application/profile_providers.dart';
import '../../../profile/application/settings_providers.dart';
import '../signup/signup_state.dart';

final loginLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  String? _error;

  bool get _isIos => Theme.of(context).platform == TargetPlatform.iOS;
  bool get _canLogin =>
      SignupState.looksLikeEmail(_emailController.text.trim()) &&
      _passwordController.text.length >= 6;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onChanged);
    _passwordController.addListener(_onChanged);
  }

  void _onChanged() {
    setState(() {
      _error = null;
    });
  }

  Future<void> _handleGoogle() async {
    FocusScope.of(context).unfocus();
    debugPrint('[auth][google] button tapped');

    if (!isClerkConfigured) {
      setState(() {
        _error =
            'Clerk is not configured. Run with --dart-define=CLERK_PUBLISHABLE_KEY=your_key_here.';
      });
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final authState = ClerkAuth.of(context, listen: false);
      final service = ref.read(clerkAuthServiceProvider(authState));
      await service.signInWithGoogle(context);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = friendlyClerkError(error, flow: AuthErrorFlow.google);
      });
    } finally {
      if (mounted) {
        ref.read(loginLoadingProvider.notifier).state = false;
      }
    }
  }

  Future<void> _handleEmailLogin() async {
    if (!_canLogin) return;
    await _runAuth(
      (service) => service.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  Future<void> _runAuth(
    Future<void> Function(ClerkAuthService service) action,
  ) async {
    FocusScope.of(context).unfocus();

    if (!isClerkConfigured) {
      setState(() {
        _error =
            'Clerk is not configured. Run with --dart-define=CLERK_PUBLISHABLE_KEY=your_key_here.';
      });
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final authState = ClerkAuth.of(context, listen: false);
      final service = ref.read(clerkAuthServiceProvider(authState));
      await action(service);
      await _syncSignedInUser(authState);
      if (!mounted) return;
      context.go('/main');
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = friendlyClerkError(error, flow: AuthErrorFlow.emailLogin);
      });
    } finally {
      if (mounted) {
        ref.read(loginLoadingProvider.notifier).state = false;
      }
    }
  }

  void _handleApple() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple sign-in is not configured yet.')),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _syncSignedInUser(ClerkAuthState authState) async {
    final user = authState.user;
    if (user == null) {
      return;
    }

    final preferredEmail = user.email?.trim();
    final preferredName = user.name.trim();
    final preferredUsername =
        preferredEmail != null &&
            preferredEmail.isNotEmpty &&
            preferredEmail.contains('@')
        ? preferredEmail.split('@').first.trim()
        : null;

    await ref
        .read(userProfileRepositoryProvider)
        .getOrCreateProfileFromClerk(
          user: user,
          preferredName: preferredName.isEmpty ? null : preferredName,
          preferredEmail: preferredEmail,
          preferredUsername: preferredUsername,
        );
    await ref
        .read(appSettingsRepositoryProvider)
        .ensureDefaultSettings(user.id);
    await ref.read(inboxRepositoryProvider).seedDefaultUpdatesIfEmpty(user.id);
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loginLoadingProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(22, 16, 22, 28 + bottomInset),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            context.canPop() ? context.pop() : context.go('/'),
                        icon: const Icon(Icons.close_rounded, size: 34),
                      ),
                      const Spacer(),
                      const Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 42),
                  _SocialButton(
                    label: 'Continue with Google',
                    icon: const Text(
                      'G',
                      style: TextStyle(
                        color: Color(0xFF4285F4),
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onTap: loading ? null : _handleGoogle,
                  ),
                  if (_isIos) ...[
                    const SizedBox(height: 14),
                    _SocialButton(
                      label: 'Continue with Apple',
                      icon: const Icon(
                        Icons.apple_rounded,
                        color: Colors.white,
                        size: 31,
                      ),
                      onTap: loading ? null : _handleApple,
                    ),
                  ],
                  const SizedBox(height: 30),
                  const Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _LoginTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),
                  _LoginTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    obscureText: !_showPassword,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    onSubmitted: (_) => _handleEmailLogin(),
                  ),
                  const SizedBox(height: 38),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: loading || !_canLogin
                          ? null
                          : _handleEmailLogin,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE60023),
                        disabledBackgroundColor: const Color(0xFF4B4C47),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFFF8A8A),
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 44),
                  Text.rich(
                    TextSpan(
                      text: 'Facebook login is no longer available. ',
                      children: const [
                        TextSpan(
                          text: 'Recover your account.',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Forgot your password?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_isIos) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Use iCloud Keychain',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD7D7D7), width: 1.2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(left: 22, child: icon),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD7D7D7), width: 1.1),
      ),
      padding: const EdgeInsets.fromLTRB(20, 9, 10, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              textInputAction: onSubmitted == null
                  ? TextInputAction.next
                  : TextInputAction.go,
              onSubmitted: onSubmitted,
              cursorColor: const Color(0xFFE60023),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hint,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffixIcon: suffix,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
