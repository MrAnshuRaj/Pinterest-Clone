import '../../../../core/firebase/firestore_utils.dart';

class AppSettingsModel {
  const AppSettingsModel({
    required this.privateProfile,
    required this.searchPrivacy,
    required this.appSounds,
    required this.allowComments,
    required this.filterCommentsOnMyPins,
    required this.filterCommentsOnOthersPins,
    required this.showSimilarProducts,
    required this.autoplayVideosOnCellular,
    required this.twoFactorEnabled,
    required this.googleLoginEnabled,
    required this.appleLoginEnabled,
    required this.adsPersonalization,
    required this.aiContentToggles,
    required this.notificationSettings,
    required this.boardRecommendationToggles,
    required this.selectedInterests,
    required this.hiddenPinIds,
    required this.updatedAt,
  });

  final bool privateProfile;
  final bool searchPrivacy;
  final bool appSounds;
  final bool allowComments;
  final bool filterCommentsOnMyPins;
  final bool filterCommentsOnOthersPins;
  final bool showSimilarProducts;
  final bool autoplayVideosOnCellular;
  final bool twoFactorEnabled;
  final bool googleLoginEnabled;
  final bool appleLoginEnabled;
  final Map<String, bool> adsPersonalization;
  final Map<String, bool> aiContentToggles;
  final Map<String, Map<String, bool>> notificationSettings;
  final Map<String, bool> boardRecommendationToggles;
  final List<String> selectedInterests;
  final List<String> hiddenPinIds;
  final DateTime updatedAt;

  bool get useInfoFromSites => adsPersonalization['useInfoFromSites'] ?? true;
  bool get usePartnerInfo => adsPersonalization['usePartnerInfo'] ?? true;
  bool get adsAboutPinterest => adsPersonalization['adsAboutPinterest'] ?? true;
  bool get activityForAdsReporting =>
      adsPersonalization['activityForAdsReporting'] ?? true;
  bool get sharingInfoWithPartners =>
      adsPersonalization['sharingInfoWithPartners'] ?? true;
  bool get adsOffPinterest => adsPersonalization['adsOffPinterest'] ?? true;
  bool get useDataToTrainCanvas =>
      adsPersonalization['useDataToTrainCanvas'] ?? true;

  Map<String, bool> notificationChannels(String id) {
    return notificationSettings[id] ?? const {};
  }

  bool notificationChannelValue(String id, String channel) {
    return notificationChannels(id)[channel] ?? false;
  }

  factory AppSettingsModel.defaults() {
    return AppSettingsModel(
      privateProfile: false,
      searchPrivacy: false,
      appSounds: true,
      allowComments: true,
      filterCommentsOnMyPins: false,
      filterCommentsOnOthersPins: false,
      showSimilarProducts: true,
      autoplayVideosOnCellular: true,
      twoFactorEnabled: false,
      googleLoginEnabled: true,
      appleLoginEnabled: false,
      adsPersonalization: const {
        'useInfoFromSites': true,
        'usePartnerInfo': true,
        'adsAboutPinterest': true,
        'activityForAdsReporting': true,
        'sharingInfoWithPartners': true,
        'adsOffPinterest': true,
        'useDataToTrainCanvas': true,
      },
      aiContentToggles: const {
        'Architecture': true,
        'Art': true,
        'Beauty': true,
        'Children\'s fashion': true,
        'Entertainment': true,
        'Food and drinks': true,
        'Health': true,
        'Home decor': true,
        'Men\'s fashion': true,
        'Sport': true,
        'Women\'s fashion': true,
      },
      notificationSettings: const {
        'mentions': {'push': true, 'email': false, 'inApp': true},
        'reminders': {'push': true, 'email': false, 'inApp': true},
        'comments_with_photos': {'push': true, 'email': false, 'inApp': true},
        'group_board_updates': {'push': true, 'email': true, 'inApp': true},
        'group_board_invites': {'push': true, 'email': false, 'inApp': false},
        'messages': {'push': true, 'email': true, 'inApp': true},
        'followers': {'push': true, 'email': false, 'inApp': false},
        'inspired_home': {'push': true, 'email': true, 'inApp': true},
        'based_interests': {'push': true, 'email': true, 'inApp': true},
        'based_activity': {'push': true, 'email': true, 'inApp': true},
        'boards_like': {'push': true, 'email': true, 'inApp': true},
        'searches_like': {'push': true, 'email': true, 'inApp': true},
        'pins_follow': {'push': true, 'email': false, 'inApp': true},
        'pins_might_like': {'push': true, 'email': false, 'inApp': true},
        'shopping_pins': {'push': true, 'email': true, 'inApp': true},
        'announcements': {'push': false, 'email': true, 'inApp': false},
        'surveys': {'push': false, 'email': true, 'inApp': false},
        'reports_updates': {'push': false, 'email': true, 'inApp': false},
        'shuffles': {'push': false, 'email': true, 'inApp': false},
        'all_notifications': {'push': true, 'email': true, 'inApp': true},
        'created_comments': {'push': true, 'email': false, 'inApp': true},
        'created_reactions': {'push': true, 'email': false, 'inApp': true},
        'created_saves': {'push': true, 'email': false, 'inApp': false},
        'created_views': {'push': true, 'email': false, 'inApp': true},
        'created_collages': {'push': true, 'email': false, 'inApp': false},
        'saved_comments': {'push': true, 'email': false, 'inApp': true},
        'saved_mentions': {'push': true, 'email': false, 'inApp': true},
        'saved_reminders': {'push': true, 'email': false, 'inApp': true},
        'saved_comments_photos': {'push': true, 'email': false, 'inApp': true},
      },
      boardRecommendationToggles: const {},
      selectedInterests: const ['Food and Drinks', 'Home Decor', 'Quotes'],
      hiddenPinIds: const [],
      updatedAt: DateTime.now(),
    );
  }

  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    final defaults = AppSettingsModel.defaults();
    return AppSettingsModel(
      privateProfile: map['privateProfile'] as bool? ?? defaults.privateProfile,
      searchPrivacy: map['searchPrivacy'] as bool? ?? defaults.searchPrivacy,
      appSounds: map['appSounds'] as bool? ?? defaults.appSounds,
      allowComments: map['allowComments'] as bool? ?? defaults.allowComments,
      filterCommentsOnMyPins:
          map['filterCommentsOnMyPins'] as bool? ??
          defaults.filterCommentsOnMyPins,
      filterCommentsOnOthersPins:
          map['filterCommentsOnOthersPins'] as bool? ??
          defaults.filterCommentsOnOthersPins,
      showSimilarProducts:
          map['showSimilarProducts'] as bool? ?? defaults.showSimilarProducts,
      autoplayVideosOnCellular:
          map['autoplayVideosOnCellular'] as bool? ??
          defaults.autoplayVideosOnCellular,
      twoFactorEnabled:
          map['twoFactorEnabled'] as bool? ?? defaults.twoFactorEnabled,
      googleLoginEnabled:
          map['googleLoginEnabled'] as bool? ?? defaults.googleLoginEnabled,
      appleLoginEnabled:
          map['appleLoginEnabled'] as bool? ?? defaults.appleLoginEnabled,
      adsPersonalization: {
        ...defaults.adsPersonalization,
        ...boolMapFrom(map['adsPersonalization']),
      },
      aiContentToggles: {
        ...defaults.aiContentToggles,
        ...boolMapFrom(map['aiContentToggles']),
      },
      notificationSettings: {
        ...defaults.notificationSettings,
        ...nestedBoolMapFrom(map['notificationSettings']),
      },
      boardRecommendationToggles: boolMapFrom(
        map['boardRecommendationToggles'],
      ),
      selectedInterests: stringListFrom(map['selectedInterests']).isEmpty
          ? defaults.selectedInterests
          : stringListFrom(map['selectedInterests']),
      hiddenPinIds: stringListFrom(map['hiddenPinIds']),
      updatedAt: parseFirestoreDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'privateProfile': privateProfile,
      'searchPrivacy': searchPrivacy,
      'appSounds': appSounds,
      'allowComments': allowComments,
      'filterCommentsOnMyPins': filterCommentsOnMyPins,
      'filterCommentsOnOthersPins': filterCommentsOnOthersPins,
      'showSimilarProducts': showSimilarProducts,
      'autoplayVideosOnCellular': autoplayVideosOnCellular,
      'twoFactorEnabled': twoFactorEnabled,
      'googleLoginEnabled': googleLoginEnabled,
      'appleLoginEnabled': appleLoginEnabled,
      'adsPersonalization': adsPersonalization,
      'aiContentToggles': aiContentToggles,
      'notificationSettings': notificationSettings,
      'boardRecommendationToggles': boardRecommendationToggles,
      'selectedInterests': selectedInterests,
      'hiddenPinIds': hiddenPinIds,
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  AppSettingsModel copyWith({
    bool? privateProfile,
    bool? searchPrivacy,
    bool? appSounds,
    bool? allowComments,
    bool? filterCommentsOnMyPins,
    bool? filterCommentsOnOthersPins,
    bool? showSimilarProducts,
    bool? autoplayVideosOnCellular,
    bool? twoFactorEnabled,
    bool? googleLoginEnabled,
    bool? appleLoginEnabled,
    Map<String, bool>? adsPersonalization,
    Map<String, bool>? aiContentToggles,
    Map<String, Map<String, bool>>? notificationSettings,
    Map<String, bool>? boardRecommendationToggles,
    List<String>? selectedInterests,
    List<String>? hiddenPinIds,
    DateTime? updatedAt,
  }) {
    return AppSettingsModel(
      privateProfile: privateProfile ?? this.privateProfile,
      searchPrivacy: searchPrivacy ?? this.searchPrivacy,
      appSounds: appSounds ?? this.appSounds,
      allowComments: allowComments ?? this.allowComments,
      filterCommentsOnMyPins:
          filterCommentsOnMyPins ?? this.filterCommentsOnMyPins,
      filterCommentsOnOthersPins:
          filterCommentsOnOthersPins ?? this.filterCommentsOnOthersPins,
      showSimilarProducts: showSimilarProducts ?? this.showSimilarProducts,
      autoplayVideosOnCellular:
          autoplayVideosOnCellular ?? this.autoplayVideosOnCellular,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      googleLoginEnabled: googleLoginEnabled ?? this.googleLoginEnabled,
      appleLoginEnabled: appleLoginEnabled ?? this.appleLoginEnabled,
      adsPersonalization: adsPersonalization ?? this.adsPersonalization,
      aiContentToggles: aiContentToggles ?? this.aiContentToggles,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      boardRecommendationToggles:
          boardRecommendationToggles ?? this.boardRecommendationToggles,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      hiddenPinIds: hiddenPinIds ?? this.hiddenPinIds,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
