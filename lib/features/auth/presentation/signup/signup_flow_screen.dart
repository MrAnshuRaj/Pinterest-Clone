import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'signup_controller.dart';
import 'signup_state.dart';
import 'widgets/birthday_picker.dart';
import 'widgets/gender_option_button.dart';
import 'widgets/interest_grid.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/pinterest_next_button.dart';
import 'widgets/pinterest_text_field.dart';
import 'widgets/tuning_feed_loader.dart';

class SignupFlowScreen extends ConsumerStatefulWidget {
  const SignupFlowScreen({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  ConsumerState<SignupFlowScreen> createState() => _SignupFlowScreenState();
}

class _SignupFlowScreenState extends ConsumerState<SignupFlowScreen> {
  late final AutoDisposeStateNotifierProvider<SignupController, SignupState>
  _provider;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _searchController;

  bool _showPassword = false;
  bool _isEditingName = true;
  bool _isCompleting = false;

  static const _countries = [
    'India',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
  ];

  static const _interests = [
    InterestItem(
      title: 'Phone wallpapers',
      imageUrl:
          'https://images.unsplash.com/photo-1519608487953-e999c86e7455?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFFB95E53),
    ),
    InterestItem(
      title: 'Photography',
      imageUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF74645A),
    ),
    InterestItem(
      title: 'Drawing',
      imageUrl:
          'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFFB18960),
    ),
    InterestItem(
      title: 'Cars',
      imageUrl:
          'https://images.unsplash.com/photo-1494905998402-395d579af36f?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF9E6155),
    ),
    InterestItem(
      title: 'Workouts',
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF8B8A61),
    ),
    InterestItem(
      title: 'Home renovation',
      imageUrl:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF8C6A5A),
    ),
    InterestItem(
      title: 'Video game customization',
      imageUrl:
          'https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF74A0C7),
    ),
    InterestItem(
      title: 'Home decor',
      imageUrl:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF8AA1D1),
    ),
    InterestItem(
      title: 'Weddings',
      imageUrl:
          'https://images.unsplash.com/photo-1519225421980-715cb0215aed?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF8C7A68),
    ),
    InterestItem(
      title: 'Plants',
      imageUrl:
          'https://images.unsplash.com/photo-1463154545680-d59320fd685d?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF6CA1D9),
    ),
    InterestItem(
      title: 'Cute greetings',
      imageUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF8AA0B1),
    ),
    InterestItem(
      title: 'Cooking',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF7BA8D1),
    ),
    InterestItem(
      title: 'Pop culture',
      imageUrl:
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF7AADE0),
    ),
    InterestItem(
      title: 'Anime and comics',
      imageUrl:
          'https://images.unsplash.com/photo-1578632292335-df3abbb0d586?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF6E97D4),
    ),
    InterestItem(
      title: 'DIY projects',
      imageUrl:
          'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFFB17C65),
    ),
    InterestItem(
      title: 'Relaxation',
      imageUrl:
          'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF9E6F59),
    ),
    InterestItem(
      title: 'Small spaces',
      imageUrl:
          'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFFA58167),
    ),
    InterestItem(
      title: 'Aesthetics',
      imageUrl:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF93B0DE),
    ),
    InterestItem(
      title: 'Party ideas',
      imageUrl:
          'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF6EBAE2),
    ),
    InterestItem(
      title: 'Nail trends',
      imageUrl:
          'https://images.unsplash.com/photo-1604654894610-df63bc536371?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF75C6E7),
    ),
    InterestItem(
      title: 'Tattoos',
      imageUrl:
          'https://images.unsplash.com/photo-1542727365-19732a80dcfd?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF6DA3C6),
    ),
    InterestItem(
      title: 'Quotes',
      imageUrl:
          'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFFA88AE8),
    ),
    InterestItem(
      title: 'Travel',
      imageUrl:
          'https://images.unsplash.com/photo-1491555103944-7c647fd857e6?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF75B7F0),
    ),
    InterestItem(
      title: 'Classroom ideas',
      imageUrl:
          'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF7AB9DC),
    ),
    InterestItem(
      title: 'Outfit ideas',
      imageUrl:
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF79A4D5),
    ),
    InterestItem(
      title: 'Hair inspiration',
      imageUrl:
          'https://images.unsplash.com/photo-1527799820374-dcf8d9d4a388?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF7AB9E8),
    ),
    InterestItem(
      title: 'Baking',
      imageUrl:
          'https://images.unsplash.com/photo-1486427944299-d1955d23e34d?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF94B7E1),
    ),
    InterestItem(
      title: 'Sneakers',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF8AA7D1),
    ),
    InterestItem(
      title: 'Cute animals',
      imageUrl:
          'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=900&q=80',
      accentColor: Color(0xFF8AAAD1),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _provider = signupControllerProvider(widget.initialEmail);
    final initialState = ref.read(_provider);
    _emailController = TextEditingController(text: initialState.email);
    _passwordController = TextEditingController(text: initialState.password);
    _nameController = TextEditingController(text: initialState.fullName);
    _searchController = TextEditingController();
    _isEditingName = initialState.fullName.trim().isEmpty;

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _nameController.addListener(_onNameChanged);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    ref.read(_provider.notifier).updateEmail(_emailController.text);
  }

  void _onPasswordChanged() {
    ref.read(_provider.notifier).updatePassword(_passwordController.text);
  }

  void _onNameChanged() {
    ref.read(_provider.notifier).updateFullName(_nameController.text);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  void _handleBack(SignupState state) {
    FocusScope.of(context).unfocus();
    if (state.currentStep == state.firstStep) {
      context.pop();
      return;
    }

    ref.read(_provider.notifier).goBack();
  }

  void _saveNameAndCollapse() {
    final value = _nameController.text.trim();
    ref.read(_provider.notifier).updateFullName(value);
    if (value.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isEditingName = false;
    });
  }

  Future<void> _pickCountry(SignupState state) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B5B5B),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 22),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose your country',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                for (final country in _countries)
                  ListTile(
                    onTap: () => Navigator.of(context).pop(country),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      country,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: state.country == country
                        ? const Icon(Icons.check_rounded, color: Colors.white)
                        : null,
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null && mounted) {
      ref.read(_provider.notifier).updateCountry(selected);
    }
  }

  Future<void> _finishSignup() async {
    if (_isCompleting) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isCompleting = true;
    });
    ref.read(_provider.notifier).goToTuning();
    await Future<void>.delayed(const Duration(milliseconds: 2400));
    if (!mounted) return;

    completeSignup(ref.read(_provider));
  }

  void completeSignup(SignupState state) {
    debugPrint(
      'Signup completed: '
      'email=${state.email}, '
      'password=${state.password}, '
      'fullName=${state.fullName}, '
      'birthday=${state.birthday.toIso8601String()}, '
      'gender=${state.gender}, '
      'country=${state.country}, '
      'interests=${state.selectedInterests.join(', ')}',
    );
    context.go('/home');
  }

  List<InterestItem> get _filteredInterests {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _interests;

    return _interests.where((item) {
      return item.title.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final controller = ref.read(_provider.notifier);

    if (state.currentStep == SignupStep.tuning) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(child: TuningFeedLoader()),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingHeader(
                onBack: () => _handleBack(state),
                activeIndex: state.progressIndex,
                totalDots: state.visibleStepCount,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final slide = Tween<Offset>(
                      begin: const Offset(0.035, 0),
                      end: Offset.zero,
                    ).animate(animation);

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(state.currentStep),
                    child: switch (state.currentStep) {
                      SignupStep.email => _buildEmailStep(state, controller),
                      SignupStep.password => _buildPasswordStep(
                        state,
                        controller,
                      ),
                      SignupStep.profile => _buildProfileStep(
                        state,
                        controller,
                      ),
                      SignupStep.gender => _buildGenderStep(state, controller),
                      SignupStep.location => _buildLocationStep(
                        state,
                        controller,
                      ),
                      SignupStep.interests => _buildInterestsStep(state),
                      SignupStep.tuning => const SizedBox.shrink(),
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailStep(SignupState state, SignupController controller) {
    return _StepScaffold(
      button: PinterestNextButton(
        label: 'Next',
        enabled: state.hasValidEmail,
        onPressed: controller.continueFromEmail,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('What\'s your email?', style: _headingStyle),
          const SizedBox(height: 22),
          PinterestTextField(
            controller: _emailController,
            hintText: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.go,
            autofocus: true,
            autofillHints: const [AutofillHints.email],
            onSubmitted: (_) => controller.continueFromEmail(),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStep(SignupState state, SignupController controller) {
    final strength = state.passwordStrength;
    final strengthColor = switch (strength) {
      PasswordStrength.empty => const Color(0xFF5A5A5A),
      PasswordStrength.weak => const Color(0xFFF57C00),
      PasswordStrength.medium => const Color(0xFFE53935),
      PasswordStrength.okay => const Color(0xFF2EAD55),
    };
    final strengthFill = switch (strength) {
      PasswordStrength.empty => 0.0,
      PasswordStrength.weak => 0.38,
      PasswordStrength.medium => 0.7,
      PasswordStrength.okay => 1.0,
    };
    final strengthLabel = switch (strength) {
      PasswordStrength.empty => '',
      PasswordStrength.weak => 'Weak',
      PasswordStrength.medium => 'Medium',
      PasswordStrength.okay => 'Okay',
    };

    return _StepScaffold(
      button: PinterestNextButton(
        label: 'Next',
        enabled: state.hasValidPassword,
        onPressed: controller.continueFromPassword,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('Create a password', style: _headingStyle),
          const SizedBox(height: 22),
          PinterestTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Create a strong password',
            obscureText: !_showPassword,
            textInputAction: TextInputAction.go,
            autofocus: true,
            onSubmitted: (_) => controller.continueFromPassword(),
            suffix: IconButton(
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              splashRadius: 22,
              icon: Icon(
                _showPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 10,
              color: const Color(0xFF5A5A5A),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 220),
                tween: Tween<double>(begin: 0, end: strengthFill),
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    widthFactor: value,
                    alignment: Alignment.centerLeft,
                    child: child,
                  );
                },
                child: ColoredBox(color: strengthColor),
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (strengthLabel.isNotEmpty)
            Text(
              strengthLabel,
              style: TextStyle(
                color: strengthColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (strengthLabel.isEmpty) const SizedBox(height: 6),
          const SizedBox(height: 6),
          const Text(
            'Use 8 or more letters, numbers and symbols',
            style: TextStyle(
              color: Color(0xFF9D9D9D),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 34),
          const Row(
            children: [
              Text(
                'Password tips',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.info_outline_rounded, size: 21, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStep(SignupState state, SignupController controller) {
    return _StepScaffold(
      button: PinterestNextButton(
        label: 'Next',
        enabled: state.hasName,
        onPressed: () {
          _saveNameAndCollapse();
          controller.continueFromProfile();
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          if (_isEditingName || !state.hasName) ...[
            Row(
              children: [
                Expanded(
                  child: PinterestTextField(
                    controller: _nameController,
                    hintText: 'Enter your full name',
                    textInputAction: TextInputAction.done,
                    autofocus: !state.hasName,
                    onSubmitted: (_) => _saveNameAndCollapse(),
                  ),
                ),
                const SizedBox(width: 12),
                _MiniActionButton(
                  label: 'Update',
                  enabled: state.hasName,
                  onTap: _saveNameAndCollapse,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Hey ${state.fullName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.7,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditingName = true;
                    });
                  },
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          const Text('Enter your birthdate', style: _headingStyle),
          const SizedBox(height: 12),
          BirthdayPicker(
            initialDate: state.birthday,
            onDateChanged: controller.updateBirthday,
          ),
          const SizedBox(height: 22),
          const Text(
            'Knowing your age helps keep Pinterest safe for everyone. It won\'t be visible to others.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Use your own birthdate, even if this is a business account.',
            style: TextStyle(
              color: Color(0xFF9A9A9A),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderStep(SignupState state, SignupController controller) {
    return _StepScaffold(
      button: PinterestNextButton(
        label: 'Next',
        enabled: state.hasGender,
        onPressed: controller.continueFromGender,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('What\'s your gender?', style: _headingStyle),
          const SizedBox(height: 18),
          const Text(
            'This will influence the content you see. It won\'t be visible to others.',
            style: TextStyle(
              color: Color(0xFFD7D7D7),
              fontSize: 18,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 28),
          for (final option in const ['Female', 'Male', 'Specify another']) ...[
            GenderOptionButton(
              label: option,
              selected: state.gender == option,
              onTap: () => controller.updateGender(option),
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationStep(SignupState state, SignupController controller) {
    return _StepScaffold(
      button: PinterestNextButton(
        label: 'Next',
        enabled: true,
        onPressed: controller.continueFromLocation,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('Where do you live?', style: _headingStyle),
          const SizedBox(height: 18),
          const Text(
            'This helps us find you more relevant content. We won\'t show it on your profile.',
            style: TextStyle(
              color: Color(0xFFD7D7D7),
              fontSize: 18,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 38),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _pickCountry(state),
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Text(
                      state.country,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsStep(SignupState state) {
    final filteredInterests = _filteredInterests;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 168),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What are you in the mood to do?',
                style: _headingStyle,
              ),
              const SizedBox(height: 14),
              const Text(
                'Pick 3 or more to curate your experience',
                style: TextStyle(
                  color: Color(0xFFD7D7D7),
                  fontSize: 18,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),
              InterestGrid(
                items: filteredInterests,
                selectedTitles: state.selectedInterests,
                onToggle: (item) {
                  ref.read(_provider.notifier).toggleInterest(item.title);
                },
              ),
              const SizedBox(height: 28),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Looking for something else?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white, width: 1.4),
                ),
                child: TextField(
                  controller: _searchController,
                  cursorColor: const Color(0xFFE60023),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    suffixIcon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 19,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 16,
          child: PinterestNextButton(
            label: 'Next',
            enabled: state.hasEnoughInterests,
            onPressed: _finishSignup,
          ),
        ),
      ],
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.child, required this.button});

  final Widget child;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(24, 0, 24, 20 + bottomInset),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child,
                  const Spacer(),
                  const SizedBox(height: 24),
                  button,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MiniActionButton extends StatelessWidget {
  const _MiniActionButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? const Color(0xFF4B4A43) : const Color(0xFF3A3936),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 112,
          height: 74,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: enabled ? Colors.white : const Color(0xFF9E9D99),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _headingStyle = TextStyle(
  color: Colors.white,
  fontSize: 34,
  fontWeight: FontWeight.w700,
  height: 1.05,
  letterSpacing: -1.2,
);
