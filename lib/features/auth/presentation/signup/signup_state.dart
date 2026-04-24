enum SignupStep {
  email,
  password,
  profile,
  gender,
  location,
  interests,
  tuning,
}

enum PasswordStrength { empty, weak, medium, okay }

class SignupState {
  const SignupState({
    required this.currentStep,
    required this.email,
    required this.password,
    required this.fullName,
    required this.birthday,
    required this.gender,
    required this.country,
    required this.selectedInterests,
    required this.startsFromPassword,
  });

  factory SignupState.initial({String? initialEmail}) {
    final normalizedEmail = initialEmail?.trim() ?? '';
    final startsFromPassword = looksLikeEmail(normalizedEmail);

    return SignupState(
      currentStep: startsFromPassword ? SignupStep.password : SignupStep.email,
      email: startsFromPassword ? normalizedEmail : '',
      password: '',
      fullName: '',
      birthday: DateTime(2004, 3, 7),
      gender: '',
      country: 'India',
      selectedInterests: const {},
      startsFromPassword: startsFromPassword,
    );
  }

  final SignupStep currentStep;
  final String email;
  final String password;
  final String fullName;
  final DateTime birthday;
  final String gender;
  final String country;
  final Set<String> selectedInterests;
  final bool startsFromPassword;

  SignupStep get firstStep =>
      startsFromPassword ? SignupStep.password : SignupStep.email;

  int get visibleStepCount => startsFromPassword ? 5 : 6;

  int get progressIndex {
    if (startsFromPassword) {
      switch (currentStep) {
        case SignupStep.password:
          return 0;
        case SignupStep.profile:
          return 1;
        case SignupStep.gender:
          return 2;
        case SignupStep.location:
          return 3;
        case SignupStep.interests:
        case SignupStep.tuning:
          return 4;
        case SignupStep.email:
          return 0;
      }
    }

    switch (currentStep) {
      case SignupStep.email:
        return 0;
      case SignupStep.password:
        return 1;
      case SignupStep.profile:
        return 2;
      case SignupStep.gender:
        return 3;
      case SignupStep.location:
        return 4;
      case SignupStep.interests:
      case SignupStep.tuning:
        return 5;
    }
  }

  bool get hasValidEmail => looksLikeEmail(email);
  bool get hasValidPassword => password.length >= 8;
  bool get hasName => fullName.trim().isNotEmpty;
  bool get hasGender => gender.isNotEmpty;
  bool get hasEnoughInterests => selectedInterests.length >= 3;

  PasswordStrength get passwordStrength {
    if (password.isEmpty) {
      return PasswordStrength.empty;
    }

    if (password.length < 8) {
      return PasswordStrength.weak;
    }

    final hasLetters = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumbers = RegExp(r'\d').hasMatch(password);
    final hasSymbols = RegExp(r'[^A-Za-z0-9]').hasMatch(password);

    if (hasLetters && (hasNumbers || hasSymbols)) {
      return PasswordStrength.okay;
    }

    return PasswordStrength.medium;
  }

  SignupState copyWith({
    SignupStep? currentStep,
    String? email,
    String? password,
    String? fullName,
    DateTime? birthday,
    String? gender,
    String? country,
    Set<String>? selectedInterests,
  }) {
    return SignupState(
      currentStep: currentStep ?? this.currentStep,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      startsFromPassword: startsFromPassword,
    );
  }

  static bool looksLikeEmail(String value) {
    final normalized = value.trim();
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(normalized);
  }
}
