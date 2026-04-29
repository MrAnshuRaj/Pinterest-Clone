import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/clerk_auth_service.dart';
import 'signup_state.dart';

final signupControllerProvider = StateNotifierProvider.autoDispose
    .family<SignupController, SignupState, String?>(
      (ref, initialEmail) => SignupController(initialEmail: initialEmail),
    );

class SignupController extends StateNotifier<SignupState> {
  SignupController({String? initialEmail})
    : super(SignupState.initial(initialEmail: initialEmail));

  void updateEmail(String value) {
    state = state.copyWith(email: value.trim());
  }

  void continueFromEmail() {
    if (!state.hasValidEmail) return;
    state = state.copyWith(currentStep: SignupStep.profile);
  }

  void updateFullName(String value) {
    state = state.copyWith(fullName: value.trimLeft());
  }

  void updateBirthday(DateTime value) {
    state = state.copyWith(birthday: value);
  }

  void continueFromProfile() {
    if (!state.hasName) return;
    state = state.copyWith(currentStep: SignupStep.gender);
  }

  void updateGender(String value) {
    state = state.copyWith(gender: value);
  }

  void continueFromGender() {
    if (!state.hasGender) return;
    state = state.copyWith(currentStep: SignupStep.location);
  }

  void updateCountry(String value) {
    state = state.copyWith(country: value);
  }

  void continueFromLocation() {
    state = state.copyWith(currentStep: SignupStep.interests);
  }

  void toggleInterest(String value) {
    final interests = {...state.selectedInterests};
    if (interests.contains(value)) {
      interests.remove(value);
    } else {
      interests.add(value);
    }

    state = state.copyWith(selectedInterests: interests);
  }

  void goToTuning() {
    state = state.copyWith(currentStep: SignupStep.tuning);
  }

  Future<void> createClerkAccount(ClerkAuthService authService) {
    return authService.startEmailCodeSignUp(
      email: state.email,
      fullName: state.fullName,
    );
  }

  Future<void> syncOnboardingProfileToClerk(ClerkAuthService authService) {
    return authService.syncOnboardingProfileToClerk(
      fullName: state.fullName,
      birthday: state.birthday,
      gender: state.gender,
      country: state.country,
      selectedInterests: state.selectedInterests,
    );
  }

  void goBack() {
    switch (state.currentStep) {
      case SignupStep.email:
        return;
      case SignupStep.profile:
        if (state.startsFromProfile) return;
        state = state.copyWith(currentStep: SignupStep.email);
        return;
      case SignupStep.gender:
        state = state.copyWith(currentStep: SignupStep.profile);
        return;
      case SignupStep.location:
        state = state.copyWith(currentStep: SignupStep.gender);
        return;
      case SignupStep.interests:
        state = state.copyWith(currentStep: SignupStep.location);
        return;
      case SignupStep.tuning:
        state = state.copyWith(currentStep: SignupStep.interests);
        return;
    }
  }
}
