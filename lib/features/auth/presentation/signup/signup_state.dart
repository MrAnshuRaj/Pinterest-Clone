enum SignupStep {
  email,
  profile,
  gender,
  location,
  interests,
  tuning,
}

class SignupState {
  const SignupState({
    required this.currentStep,
    required this.email,
    required this.fullName,
    required this.birthday,
    required this.gender,
    required this.country,
    required this.selectedInterests,
    required this.startsFromProfile,
  });

  factory SignupState.initial({String? initialEmail}) {
    final normalizedEmail = initialEmail?.trim() ?? '';
    final startsFromProfile = looksLikeEmail(normalizedEmail);

    return SignupState(
      currentStep: startsFromProfile ? SignupStep.profile : SignupStep.email,
      email: startsFromProfile ? normalizedEmail : '',
      fullName: '',
      birthday: DateTime(2004, 3, 7),
      gender: '',
      country: 'India',
      selectedInterests: const {},
      startsFromProfile: startsFromProfile,
    );
  }

  final SignupStep currentStep;
  final String email;
  final String fullName;
  final DateTime birthday;
  final String gender;
  final String country;
  final Set<String> selectedInterests;
  final bool startsFromProfile;

  SignupStep get firstStep =>
      startsFromProfile ? SignupStep.profile : SignupStep.email;

  int get visibleStepCount => startsFromProfile ? 4 : 5;

  int get progressIndex {
    if (startsFromProfile) {
      switch (currentStep) {
        case SignupStep.profile:
          return 0;
        case SignupStep.gender:
          return 1;
        case SignupStep.location:
          return 2;
        case SignupStep.interests:
        case SignupStep.tuning:
          return 3;
        case SignupStep.email:
          return 0;
      }
    }

    switch (currentStep) {
      case SignupStep.email:
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
    }
  }

  bool get hasValidEmail => looksLikeEmail(email);
  bool get hasName => fullName.trim().isNotEmpty;
  bool get hasGender => gender.isNotEmpty;
  bool get hasEnoughInterests => selectedInterests.length >= 3;

  SignupState copyWith({
    SignupStep? currentStep,
    String? email,
    String? fullName,
    DateTime? birthday,
    String? gender,
    String? country,
    Set<String>? selectedInterests,
  }) {
    return SignupState(
      currentStep: currentStep ?? this.currentStep,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      startsFromProfile: startsFromProfile,
    );
  }

  static bool looksLikeEmail(String value) {
    final normalized = value.trim();
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(normalized);
  }
}
