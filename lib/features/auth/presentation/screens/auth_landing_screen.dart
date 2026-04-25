import 'dart:math' as math;

import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/clerk_config.dart';
import '../../application/auth_providers.dart';
import '../../data/services/clerk_auth_service.dart';
import '../signup/signup_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_image_collage.dart';

class AuthLandingScreen extends ConsumerStatefulWidget {
  const AuthLandingScreen({super.key});

  @override
  ConsumerState<AuthLandingScreen> createState() => _AuthLandingScreenState();
}

class _AuthLandingScreenState extends ConsumerState<AuthLandingScreen> {
  final _emailController = TextEditingController();
  bool _googleLoading = false;

  bool get _isIos => Theme.of(context).platform == TargetPlatform.iOS;
  bool get _hasValidEmail =>
      SignupState.looksLikeEmail(_emailController.text.trim());

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_handleEmailChanged);
  }

  void _handleEmailChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void onContinueWithEmail() {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    context.push('/signup', extra: _hasValidEmail ? email : null);
  }

  Future<void> onGoogleSignIn() async {
    if (_googleLoading) return;

    FocusScope.of(context).unfocus();

    if (!isClerkConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Clerk is not configured. Run with --dart-define=CLERK_PUBLISHABLE_KEY=your_key_here.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _googleLoading = true;
    });

    try {
      final authState = ClerkAuth.of(context, listen: false);
      final service = ref.read(clerkAuthServiceProvider(authState));
      await service.signInWithGoogle(context);
      if (mounted) context.go('/main');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyClerkError(error))));
    } finally {
      if (mounted) {
        setState(() {
          _googleLoading = false;
        });
      }
    }
  }

  void onSignUp() {
    context.push('/signup');
  }

  void onLogin() {
    context.push('/login');
  }

  @override
  void dispose() {
    _emailController.removeListener(_handleEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isCompact = width < 380;
              final contentWidth = math.min(width - 32, 520.0);
              final collageHeight = (constraints.maxHeight * 0.42).clamp(
                280.0,
                390.0,
              );

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isCompact ? 16 : 24,
                  6,
                  isCompact ? 16 : 24,
                  24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: Column(
                      children: [
                        AuthImageCollage(height: collageHeight),
                        const SizedBox(height: 16),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE60023),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'P',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 29,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: _isIos ? 22 : 18),
                        Text(
                          'Create a life\nyou love',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: _isIos ? 34 : 30,
                            height: 1.14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.0,
                          ),
                        ),
                        SizedBox(height: _isIos ? 30 : 28),
                        if (_isIos) ...[
                          AuthButton(
                            label: 'Sign up',
                            onPressed: onSignUp,
                            backgroundColor: const Color(0xFFE60023),
                          ),
                          const SizedBox(height: 12),
                          AuthButton(
                            label: 'Log in',
                            onPressed: onLogin,
                            backgroundColor: const Color(0xFF4A4A46),
                          ),
                          const SizedBox(height: 22),
                          const _LegalCopy(),
                        ] else ...[
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            cursorColor: const Color(0xFFE60023),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            autofillHints: const [AutofillHints.email],
                            onSubmitted: (_) => onContinueWithEmail(),
                            decoration: const InputDecoration(
                              hintText: 'Email address',
                            ),
                          ),
                          const SizedBox(height: 14),
                          AuthButton(
                            label: 'Continue',
                            onPressed: onContinueWithEmail,
                            backgroundColor: _hasValidEmail
                                ? const Color(0xFFE60023)
                                : const Color(0xFF4B4A43),
                          ),
                          const SizedBox(height: 14),
                          AuthButton(
                            label: _googleLoading
                                ? 'Please wait...'
                                : 'Continue with Google',
                            onPressed: _googleLoading ? () {} : onGoogleSignIn,
                            borderColor: const Color(0xFF454545),
                            leading: const _GoogleBadge(),
                          ),
                          const SizedBox(height: 18),
                          const _RecoveryCopy(),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: onLogin,
                            child: const Text(
                              'Already have an account? Log in',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          const _LegalCopy(),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GoogleBadge extends StatelessWidget {
  const _GoogleBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        shape: BoxShape.circle,
      ),
      child: const Text(
        'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontSize: 26,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _RecoveryCopy extends StatelessWidget {
  const _RecoveryCopy();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          color: Color(0xFFE8E8E8),
          fontSize: 15,
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
        children: [
          const TextSpan(text: 'Facebook login is no longer available. '),
          TextSpan(
            text: 'Recover your account',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _LegalCopy extends StatelessWidget {
  const _LegalCopy();

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 14,
      height: 1.45,
      fontWeight: FontWeight.w400,
    );
    const linkStyle = TextStyle(
      color: Colors.white,
      decoration: TextDecoration.underline,
      decorationColor: Colors.white,
      decorationThickness: 1.2,
    );

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: const [
          TextSpan(text: 'By continuing, you agree to Pinterest\'s '),
          TextSpan(text: 'Terms of Service', style: linkStyle),
          TextSpan(text: ' and acknowledge that you\'ve read our '),
          TextSpan(text: 'Privacy Policy', style: linkStyle),
          TextSpan(text: '. '),
          TextSpan(text: 'Notice at collection.', style: linkStyle),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
