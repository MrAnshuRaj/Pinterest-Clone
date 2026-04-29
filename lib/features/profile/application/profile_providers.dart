import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../../inbox/application/inbox_providers.dart';
import 'settings_providers.dart';
import '../data/models/user_profile_model.dart';
import '../data/repositories/user_profile_repository.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

final profileBootstrapProvider = FutureProvider<void>(
  (ref) async {
    final user = ref.watch(currentClerkUserProvider);
    if (user == null) return;
    final authState = ref.watch(clerkAuthStateProvider);

    final seed = ref.watch(currentUserProfileSeedProvider);
    if (seed != null) {
      debugPrint(
        '[profile] bootstrap userId=${seed.userId} email=${seed.email} name="${seed.name}" username="${seed.username}"',
      );
    }
    debugPrint('User: ${user.id}');
    debugPrint('Session: ${authState?.session}');

    await ref
        .read(userProfileRepositoryProvider)
        .getOrCreateProfileFromClerk(user: user);
    await ref
        .read(appSettingsRepositoryProvider)
        .ensureDefaultSettings(user.id);
    await ref.read(inboxRepositoryProvider).seedDefaultUpdatesIfEmpty(user.id);
  },
  dependencies: [
    currentClerkUserProvider,
    clerkAuthStateProvider,
    currentUserProfileSeedProvider,
  ],
);

final userProfileProvider = StreamProvider<UserProfileModel?>((ref) async* {
  final user = ref.watch(currentClerkUserProvider);
  if (user == null) {
    yield null;
    return;
  }

  final repository = ref.watch(userProfileRepositoryProvider);
  final initialProfile = await repository.getOrCreateProfileFromClerk(
    user: user,
  );

  yield initialProfile;
  yield* repository
      .watchProfile(user.id)
      .map((profile) => profile ?? initialProfile);
}, dependencies: [clerkAuthStateProvider, currentClerkUserProvider]);

final resolvedUserProfileProvider = Provider<UserProfileModel>((ref) {
  final profile = ref.watch(userProfileProvider).valueOrNull;
  final seed = ref.watch(currentUserProfileSeedProvider);
  if (seed == null) return UserProfileModel.empty();

  final resolved = (profile ?? UserProfileModel.empty()).copyWith(
    name: profile?.name.trim().isNotEmpty == true
        ? profile!.name.trim()
        : seed.name,
    username: profile?.username.trim().isNotEmpty == true
        ? profile!.normalizedUsername
        : seed.username,
    email: profile?.email.trim().isNotEmpty == true
        ? profile!.email.trim()
        : seed.email,
    avatarInitial: profile?.avatarInitial.trim().isNotEmpty == true
        ? profile!.avatarInitial.trim().substring(0, 1).toUpperCase()
        : seed.avatarInitial,
  );

  debugPrint(
    '[profile] resolved userId=${seed.userId} name="${resolved.name}" username="${resolved.username}" email="${resolved.email}"',
  );
  return resolved;
}, dependencies: [userProfileProvider, currentUserProfileSeedProvider]);

final profileProvider = resolvedUserProfileProvider;

final profileControllerProvider = Provider<ProfileController>((ref) {
  return ProfileController(ref);
});

String friendlyProfileLoadError(Object error) {
  if (error is FirebaseException && error.code == 'permission-denied') {
    return 'Unable to load your profile. Check Firestore permissions.';
  }

  final message = error.toString().toLowerCase();
  if (message.contains('permission denied') ||
      message.contains('permission-denied')) {
    return 'Unable to load your profile. Check Firestore permissions.';
  }

  return 'Unable to load your profile right now.';
}

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
