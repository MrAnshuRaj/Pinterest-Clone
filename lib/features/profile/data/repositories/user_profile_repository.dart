import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firebase/firestore_refs.dart';
import '../models/user_profile_model.dart';

class UserProfileRepository {
  UserProfileRepository({FirebaseFirestore? firestore})
    : _refs = FirestoreRefs(firestore ?? FirebaseFirestore.instance);

  final FirestoreRefs _refs;

  Stream<UserProfileModel?> watchProfile(String userId) {
    return _refs.userDoc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserProfileModel.fromMap(snapshot.data() ?? const {});
    });
  }

  Future<UserProfileModel> getOrCreateProfileFromClerk({
    required clerk.User user,
    DateTime? birthday,
    String? gender,
    String? country,
    String? language,
    Iterable<String>? selectedInterests,
  }) async {
    final doc = _refs.userDoc(user.id);
    final snapshot = await doc.get();
    if (snapshot.exists && snapshot.data() != null) {
      return UserProfileModel.fromMap(snapshot.data()!);
    }

    final now = DateTime.now();
    final email = (user.email ?? '').trim();
    final name = _deriveName(user);
    final profile = UserProfileModel(
      name: name,
      username: _buildUsername(
        user.username ?? email.split('@').firstOrNull ?? name,
      ),
      email: email,
      avatarInitial: _avatarInitialFor(name, email),
      bio: '',
      website: '',
      pronouns: '',
      birthday: birthday ?? DateTime.fromMillisecondsSinceEpoch(0),
      gender: gender ?? '',
      country: country ?? 'India',
      language: language ?? 'English (India)',
      showAllPins: true,
      isBusinessAccount: false,
      selectedInterests: selectedInterests?.toList(growable: false) ?? const [],
      createdAt: now,
      updatedAt: now,
    );

    await doc.set(profile.toMap());
    return profile;
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

  String _deriveName(clerk.User user) {
    final fromClerk = user.name.trim();
    if (fromClerk.isNotEmpty) return fromClerk;
    final email = (user.email ?? '').trim();
    if (email.isEmpty) return 'Pinterest User';

    final prefix = email.split('@').first;
    return prefix
        .split(RegExp(r'[._-]+'))
        .where((part) => part.trim().isNotEmpty)
        .map(_capitalize)
        .join(' ');
  }

  String _buildUsername(String raw) {
    final base = raw
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '')
        .replaceAll('@', '');
    final normalized = base.isEmpty ? 'pinterestuser' : base;
    return normalized.length > 20 ? normalized.substring(0, 20) : normalized;
  }

  String _avatarInitialFor(String name, String email) {
    final seed = name.trim().isNotEmpty ? name.trim() : email.trim();
    if (seed.isEmpty) return 'P';
    return seed.substring(0, 1).toUpperCase();
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}

extension on List<String> {
  String? get firstOrNull => isEmpty ? null : first;
}
