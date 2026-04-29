import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/firebase/firestore_refs.dart';
import '../../../auth/application/clerk_user_profile_seed.dart';
import '../models/user_profile_model.dart';

class UserProfileRepository {
  UserProfileRepository({FirebaseFirestore? firestore})
    : _refs = FirestoreRefs(firestore ?? FirebaseFirestore.instance);

  final FirestoreRefs _refs;

  Stream<UserProfileModel?> watchProfile(String userId) {
    return _refs.userDoc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      final profile = UserProfileModel.fromMap(snapshot.data() ?? const {});
      debugPrint(
        '[profile] loaded userId=$userId name="${profile.name}" username="${profile.username}" email="${profile.email}"',
      );
      return profile;
    });
  }

  Future<UserProfileModel> getOrCreateProfileFromClerk({
    required clerk.User user,
    String? preferredName,
    String? preferredEmail,
    String? preferredUsername,
    DateTime? birthday,
    String? gender,
    String? country,
    String? language,
    Iterable<String>? selectedInterests,
  }) async {
    final doc = _refs.userDoc(user.id);
    final snapshot = await doc.get();
    final now = DateTime.now();
    final seed = deriveClerkUserProfileSeed(
      user,
      preferredName: preferredName,
      preferredEmail: preferredEmail,
      preferredUsername: preferredUsername,
    );

    debugPrint(
      '[profile] sync start userId=${seed.userId} email=${seed.email} name="${seed.name}" username="${seed.username}"',
    );
    debugPrint('[profile] firestore doc exists=${snapshot.exists}');

    if (snapshot.exists && snapshot.data() != null) {
      final current = UserProfileModel.fromMap(snapshot.data()!);
      final repaired = _repairProfile(
        current,
        fallbackName: seed.name,
        fallbackUsername: seed.username,
        fallbackEmail: seed.email,
        fallbackAvatarInitial: seed.avatarInitial,
      );

      if (_needsRepair(current, repaired)) {
        await doc.set({
          'name': repaired.name,
          'username': repaired.username,
          'email': repaired.email,
          'avatarInitial': repaired.avatarInitial,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint(
          '[profile] repaired missing fields for userId=${seed.userId}',
        );
      }

      return repaired;
    }

    final profile = UserProfileModel(
      name: seed.name,
      username: seed.username,
      email: seed.email,
      avatarInitial: seed.avatarInitial,
      bio: '',
      website: '',
      pronouns: '',
      birthday: birthday ?? DateTime.fromMillisecondsSinceEpoch(0),
      gender: gender ?? '',
      country: country ?? '',
      language: language ?? 'English (India)',
      showAllPins: true,
      isBusinessAccount: false,
      selectedInterests: selectedInterests?.toList(growable: false) ?? const [],
      createdAt: now,
      updatedAt: now,
    );

    await doc.set({
      'name': profile.name,
      'username': profile.username,
      'email': profile.email,
      'avatarInitial': profile.avatarInitial,
      'bio': profile.bio,
      'website': profile.website,
      'pronouns': profile.pronouns,
      'birthday': birthday == null ? null : Timestamp.fromDate(birthday),
      'gender': profile.gender,
      'country': profile.country,
      'language': profile.language,
      'showAllPins': profile.showAllPins,
      'isBusinessAccount': profile.isBusinessAccount,
      'selectedInterests': profile.selectedInterests,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    debugPrint('[profile] created firestore profile for userId=${seed.userId}');
    return profile;
  }

  UserProfileModel _repairProfile(
    UserProfileModel profile, {
    required String fallbackName,
    required String fallbackUsername,
    required String fallbackEmail,
    required String fallbackAvatarInitial,
  }) {
    final nextName = _isMissingText(profile.name) ? fallbackName : profile.name;
    final nextUsername = _isMissingText(profile.username)
        ? fallbackUsername
        : normalizeUsername(profile.username);
    final nextEmail = _isMissingText(profile.email)
        ? fallbackEmail
        : profile.email;
    final nextAvatarInitial = _isMissingText(profile.avatarInitial)
        ? fallbackAvatarInitial
        : profile.avatarInitial;

    return profile.copyWith(
      name: nextName,
      username: nextUsername,
      email: nextEmail,
      avatarInitial: nextAvatarInitial,
    );
  }

  bool _needsRepair(UserProfileModel current, UserProfileModel repaired) {
    return current.name != repaired.name ||
        current.username != repaired.username ||
        current.email != repaired.email ||
        current.avatarInitial != repaired.avatarInitial;
  }

  bool _isMissingText(String value) {
    final cleaned = value.trim().toLowerCase();
    return cleaned.isEmpty || cleaned == 'null' || cleaned == 'undefined';
  }

  Future<void> updateProfile(String userId, UserProfileModel profile) {
    return _refs
        .userDoc(userId)
        .set(
          profile.copyWith(updatedAt: DateTime.now()).toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> updateField(String userId, Map<String, dynamic> data) {
    return _refs.userDoc(userId).set({
      ...data,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));
  }
}
