import '../../../../core/firebase/firestore_utils.dart';
import '../../../auth/application/clerk_user_profile_seed.dart';

class UserProfileModel {
  const UserProfileModel({
    required this.name,
    required this.username,
    required this.email,
    required this.avatarInitial,
    required this.bio,
    required this.website,
    required this.pronouns,
    required this.birthday,
    required this.gender,
    required this.country,
    required this.language,
    required this.showAllPins,
    required this.isBusinessAccount,
    required this.selectedInterests,
    required this.createdAt,
    required this.updatedAt,
  });

  final String name;
  final String username;
  final String email;
  final String avatarInitial;
  final String bio;
  final String website;
  final String pronouns;
  final DateTime birthday;
  final String gender;
  final String country;
  final String language;
  final bool showAllPins;
  final bool isBusinessAccount;
  final List<String> selectedInterests;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get normalizedUsername => normalizeUsername(username);

  String get handle =>
      '@${normalizedUsername.isEmpty ? 'user' : normalizedUsername}';

  factory UserProfileModel.empty() {
    final now = DateTime.now();
    return UserProfileModel(
      name: '',
      username: '',
      email: '',
      avatarInitial: 'P',
      bio: '',
      website: '',
      pronouns: '',
      birthday: DateTime.fromMillisecondsSinceEpoch(0),
      gender: '',
      country: '',
      language: 'English',
      showAllPins: true,
      isBusinessAccount: false,
      selectedInterests: const [],
      createdAt: now,
      updatedAt: now,
    );
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    final empty = UserProfileModel.empty();
    final name = _cleanStoredText(map['name'] as String? ?? empty.name);
    final username = _sanitizeStoredUsername(
      _cleanStoredText(map['username'] as String? ?? empty.username),
    );
    final email = _cleanStoredText(map['email'] as String? ?? empty.email);
    final avatarInitialRaw = (map['avatarInitial'] as String? ?? '').trim();
    return UserProfileModel(
      name: name,
      username: username,
      email: email,
      avatarInitial: avatarInitialRaw.isNotEmpty
          ? avatarInitialRaw.substring(0, 1).toUpperCase()
          : deriveAvatarInitial(name: name, email: email),
      bio: (map['bio'] as String? ?? empty.bio).trim(),
      website: (map['website'] as String? ?? empty.website).trim(),
      pronouns: (map['pronouns'] as String? ?? empty.pronouns).trim(),
      birthday: parseFirestoreDate(map['birthday']),
      gender: (map['gender'] as String? ?? empty.gender).trim(),
      country: (map['country'] as String? ?? empty.country).trim(),
      language: (map['language'] as String? ?? empty.language).trim(),
      showAllPins: map['showAllPins'] as bool? ?? empty.showAllPins,
      isBusinessAccount:
          map['isBusinessAccount'] as bool? ?? empty.isBusinessAccount,
      selectedInterests: stringListFrom(map['selectedInterests']),
      createdAt: parseFirestoreDate(
        map['createdAt'],
        fallback: empty.createdAt,
      ),
      updatedAt: parseFirestoreDate(
        map['updatedAt'],
        fallback: empty.updatedAt,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'avatarInitial': avatarInitial,
      'bio': bio,
      'website': website,
      'pronouns': pronouns,
      'birthday': timestampFromDate(birthday),
      'gender': gender,
      'country': country,
      'language': language,
      'showAllPins': showAllPins,
      'isBusinessAccount': isBusinessAccount,
      'selectedInterests': selectedInterests,
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  UserProfileModel copyWith({
    String? name,
    String? username,
    String? email,
    String? avatarInitial,
    String? bio,
    String? website,
    String? pronouns,
    DateTime? birthday,
    String? gender,
    String? country,
    String? language,
    bool? showAllPins,
    bool? isBusinessAccount,
    List<String>? selectedInterests,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarInitial: avatarInitial ?? this.avatarInitial,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      pronouns: pronouns ?? this.pronouns,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      language: language ?? this.language,
      showAllPins: showAllPins ?? this.showAllPins,
      isBusinessAccount: isBusinessAccount ?? this.isBusinessAccount,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

String _sanitizeStoredUsername(String raw) {
  return _cleanStoredText(raw)
      .trim()
      .toLowerCase()
      .replaceAll('@', '')
      .replaceAll(RegExp(r'[^a-z0-9._-]+'), '')
      .replaceAll(RegExp(r'[._-]{2,}'), '_')
      .replaceAll(RegExp(r'^[._-]+|[._-]+$'), '');
}

String _cleanStoredText(String raw) {
  final cleaned = raw.trim();
  if (cleaned.isEmpty) return '';

  final normalized = cleaned.toLowerCase();
  if (normalized == 'null' || normalized == 'undefined') {
    return '';
  }

  return cleaned;
}
