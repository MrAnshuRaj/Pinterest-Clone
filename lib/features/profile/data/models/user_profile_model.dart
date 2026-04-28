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
    required this.appSounds,
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
  final bool appSounds;

  String get handle => '@$username';

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
    bool? appSounds,
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
      appSounds: appSounds ?? this.appSounds,
    );
  }
}
