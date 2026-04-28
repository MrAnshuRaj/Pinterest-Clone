import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/models/user_profile_model.dart';
import '../data/repositories/user_profile_repository.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

final userProfileProvider = StreamProvider<UserProfileModel?>(
  (ref) {
    final user = ref.watch(currentClerkUserProvider);
    if (user == null) {
      return Stream.value(null);
    }

    final repository = ref.watch(userProfileRepositoryProvider);
    unawaited(repository.getOrCreateProfileFromClerk(user: user));
    return repository.watchProfile(user.id);
  },
  dependencies: [clerkAuthStateProvider, currentClerkUserProvider],
);

final resolvedUserProfileProvider = Provider<UserProfileModel>(
  (ref) {
    return ref.watch(userProfileProvider).valueOrNull ?? UserProfileModel.empty();
  },
  dependencies: [userProfileProvider],
);

final profileProvider = resolvedUserProfileProvider;

final profileControllerProvider = Provider<ProfileController>((ref) {
  return ProfileController(ref);
});

class ProfileController {
  ProfileController(this._ref);

  final Ref _ref;

  String? get _userId => _ref.read(currentUserIdProvider);

  UserProfileModel get _current => _ref.read(resolvedUserProfileProvider);

  Future<void> update(UserProfileModel profile) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref
        .read(userProfileRepositoryProvider)
        .updateProfile(userId, profile);
  }

  Future<void> updateFields(Map<String, dynamic> data) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref.read(userProfileRepositoryProvider).updateField(userId, data);
  }

  Future<void> setBirthday(DateTime value) {
    return update(_current.copyWith(birthday: value));
  }

  Future<void> setGender(String value) {
    return update(_current.copyWith(gender: value));
  }

  Future<void> setCountry(String value) {
    return update(_current.copyWith(country: value));
  }

  Future<void> setLanguage(String value) {
    return update(_current.copyWith(language: value));
  }

  Future<void> setShowAllPins(bool value) {
    return update(_current.copyWith(showAllPins: value));
  }

  Future<void> convertToBusiness() {
    return update(_current.copyWith(isBusinessAccount: true));
  }
}
