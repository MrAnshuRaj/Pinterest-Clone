import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/user_profile_model.dart';

final profileProvider =
    StateNotifierProvider<ProfileController, UserProfileModel>(
      (ref) => ProfileController(),
    );

final profileControllerProvider =
    StateNotifierProvider<ProfileController, UserProfileModel>(
      (ref) => ProfileController(),
    );

class ProfileController extends StateNotifier<UserProfileModel> {
  ProfileController()
    : super(
        UserProfileModel(
          name: 'Anshu Raj',
          username: 'anshu5265',
          email: 'anshurajwork@gmail.com',
          avatarInitial: 'A',
          bio: '',
          website: '',
          pronouns: '',
          birthday: DateTime(2004, 3, 7),
          gender: 'Male',
          country: 'India',
          language: 'English (India)',
          showAllPins: true,
          isBusinessAccount: false,
          appSounds: true,
        ),
      );

  void update(UserProfileModel profile) {
    state = profile;
  }

  void setBirthday(DateTime value) => state = state.copyWith(birthday: value);
  void setGender(String value) => state = state.copyWith(gender: value);
  void setCountry(String value) => state = state.copyWith(country: value);
  void setLanguage(String value) => state = state.copyWith(language: value);
  void setAppSounds(bool value) => state = state.copyWith(appSounds: value);
  void convertToBusiness() => state = state.copyWith(isBusinessAccount: true);
}
