import 'package:flutter_riverpod/flutter_riverpod.dart';

final pinterestSettingsProvider =
    StateNotifierProvider<PinterestSettingsController, PinterestSettingsState>(
  (ref) => PinterestSettingsController(),
);

class PinterestSettingsState {
  const PinterestSettingsState({
    required this.privateProfile,
    required this.searchPrivacy,
    required this.allowComments,
    required this.filterCommentsOnMyPins,
    required this.filterCommentsOnOthersPins,
    required this.showSimilarProducts,
    required this.useInfoFromSites,
    required this.usePartnerInfo,
    required this.adsAboutPinterest,
    required this.activityForAdsReporting,
    required this.sharingInfoWithPartners,
    required this.adsOffPinterest,
    required this.useDataToTrainCanvas,
    required this.autoplayVideosOnCellular,
    required this.twoFactorEnabled,
    required this.googleLoginEnabled,
    required this.appleLoginEnabled,
    required this.aiToggles,
    required this.boardRecommendationToggles,
    required this.selectedInterests,
    required this.hiddenPinIds,
    required this.notifications,
    required this.expandedNotificationId,
  });

  final bool privateProfile;
  final bool searchPrivacy;
  final bool allowComments;
  final bool filterCommentsOnMyPins;
  final bool filterCommentsOnOthersPins;
  final bool showSimilarProducts;
  final bool useInfoFromSites;
  final bool usePartnerInfo;
  final bool adsAboutPinterest;
  final bool activityForAdsReporting;
  final bool sharingInfoWithPartners;
  final bool adsOffPinterest;
  final bool useDataToTrainCanvas;
  final bool autoplayVideosOnCellular;
  final bool twoFactorEnabled;
  final bool googleLoginEnabled;
  final bool appleLoginEnabled;
  final Map<String, bool> aiToggles;
  final Map<String, bool> boardRecommendationToggles;
  final Set<String> selectedInterests;
  final Set<String> hiddenPinIds;
  final Map<String, NotificationPreference> notifications;
  final String? expandedNotificationId;

  PinterestSettingsState copyWith({
    bool? privateProfile,
    bool? searchPrivacy,
    bool? allowComments,
    bool? filterCommentsOnMyPins,
    bool? filterCommentsOnOthersPins,
    bool? showSimilarProducts,
    bool? useInfoFromSites,
    bool? usePartnerInfo,
    bool? adsAboutPinterest,
    bool? activityForAdsReporting,
    bool? sharingInfoWithPartners,
    bool? adsOffPinterest,
    bool? useDataToTrainCanvas,
    bool? autoplayVideosOnCellular,
    bool? twoFactorEnabled,
    bool? googleLoginEnabled,
    bool? appleLoginEnabled,
    Map<String, bool>? aiToggles,
    Map<String, bool>? boardRecommendationToggles,
    Set<String>? selectedInterests,
    Set<String>? hiddenPinIds,
    Map<String, NotificationPreference>? notifications,
    Object? expandedNotificationId = _sentinel,
  }) {
    return PinterestSettingsState(
      privateProfile: privateProfile ?? this.privateProfile,
      searchPrivacy: searchPrivacy ?? this.searchPrivacy,
      allowComments: allowComments ?? this.allowComments,
      filterCommentsOnMyPins:
          filterCommentsOnMyPins ?? this.filterCommentsOnMyPins,
      filterCommentsOnOthersPins:
          filterCommentsOnOthersPins ?? this.filterCommentsOnOthersPins,
      showSimilarProducts: showSimilarProducts ?? this.showSimilarProducts,
      useInfoFromSites: useInfoFromSites ?? this.useInfoFromSites,
      usePartnerInfo: usePartnerInfo ?? this.usePartnerInfo,
      adsAboutPinterest: adsAboutPinterest ?? this.adsAboutPinterest,
      activityForAdsReporting:
          activityForAdsReporting ?? this.activityForAdsReporting,
      sharingInfoWithPartners:
          sharingInfoWithPartners ?? this.sharingInfoWithPartners,
      adsOffPinterest: adsOffPinterest ?? this.adsOffPinterest,
      useDataToTrainCanvas:
          useDataToTrainCanvas ?? this.useDataToTrainCanvas,
      autoplayVideosOnCellular:
          autoplayVideosOnCellular ?? this.autoplayVideosOnCellular,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      googleLoginEnabled: googleLoginEnabled ?? this.googleLoginEnabled,
      appleLoginEnabled: appleLoginEnabled ?? this.appleLoginEnabled,
      aiToggles: aiToggles ?? this.aiToggles,
      boardRecommendationToggles:
          boardRecommendationToggles ?? this.boardRecommendationToggles,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      hiddenPinIds: hiddenPinIds ?? this.hiddenPinIds,
      notifications: notifications ?? this.notifications,
      expandedNotificationId: identical(expandedNotificationId, _sentinel)
          ? this.expandedNotificationId
          : expandedNotificationId as String?,
    );
  }
}

const _sentinel = Object();

class NotificationPreference {
  const NotificationPreference({
    required this.id,
    required this.title,
    required this.description,
    required this.push,
    required this.email,
    required this.inApp,
    this.hasPush = true,
    this.hasEmail = true,
    this.hasInApp = true,
  });

  final String id;
  final String title;
  final String description;
  final bool push;
  final bool email;
  final bool inApp;
  final bool hasPush;
  final bool hasEmail;
  final bool hasInApp;

  NotificationPreference copyWith({
    bool? push,
    bool? email,
    bool? inApp,
  }) {
    return NotificationPreference(
      id: id,
      title: title,
      description: description,
      push: push ?? this.push,
      email: email ?? this.email,
      inApp: inApp ?? this.inApp,
      hasPush: hasPush,
      hasEmail: hasEmail,
      hasInApp: hasInApp,
    );
  }

  String get summary {
    final parts = <String>[];
    if (hasPush && push) parts.add('Push on');
    if (hasEmail && email) parts.add('email on');
    if (hasInApp && inApp) parts.add('in-app on');
    return parts.isEmpty ? 'Off' : parts.join(', ');
  }
}

class PinterestSettingsController extends StateNotifier<PinterestSettingsState> {
  PinterestSettingsController()
      : super(
          PinterestSettingsState(
            privateProfile: false,
            searchPrivacy: false,
            allowComments: true,
            filterCommentsOnMyPins: false,
            filterCommentsOnOthersPins: false,
            showSimilarProducts: true,
            useInfoFromSites: true,
            usePartnerInfo: true,
            adsAboutPinterest: true,
            activityForAdsReporting: true,
            sharingInfoWithPartners: true,
            adsOffPinterest: true,
            useDataToTrainCanvas: true,
            autoplayVideosOnCellular: true,
            twoFactorEnabled: false,
            googleLoginEnabled: true,
            appleLoginEnabled: false,
            aiToggles: {
              for (final item in aiCategories) item: true,
            },
            boardRecommendationToggles: {'travel': true},
            selectedInterests: {'Food and Drinks', 'Home Decor', 'Quotes'},
            hiddenPinIds: const {},
            notifications: _initialNotifications,
            expandedNotificationId: null,
          ),
        );

  void setPrivateProfile(bool value) =>
      state = state.copyWith(privateProfile: value);

  void setSearchPrivacy(bool value) =>
      state = state.copyWith(searchPrivacy: value);

  void setAllowComments(bool value) =>
      state = state.copyWith(allowComments: value);

  void setFilterCommentsOnMyPins(bool value) =>
      state = state.copyWith(filterCommentsOnMyPins: value);

  void setFilterCommentsOnOthersPins(bool value) =>
      state = state.copyWith(filterCommentsOnOthersPins: value);

  void setShowSimilarProducts(bool value) =>
      state = state.copyWith(showSimilarProducts: value);

  void setPrivacyToggle(String key, bool value) {
    switch (key) {
      case 'useInfoFromSites':
        state = state.copyWith(useInfoFromSites: value);
      case 'usePartnerInfo':
        state = state.copyWith(usePartnerInfo: value);
      case 'adsAboutPinterest':
        state = state.copyWith(adsAboutPinterest: value);
      case 'activityForAdsReporting':
        state = state.copyWith(activityForAdsReporting: value);
      case 'sharingInfoWithPartners':
        state = state.copyWith(sharingInfoWithPartners: value);
      case 'adsOffPinterest':
        state = state.copyWith(adsOffPinterest: value);
      case 'useDataToTrainCanvas':
        state = state.copyWith(useDataToTrainCanvas: value);
      case 'autoplayVideosOnCellular':
        state = state.copyWith(autoplayVideosOnCellular: value);
    }
  }

  void setTwoFactorEnabled(bool value) =>
      state = state.copyWith(twoFactorEnabled: value);

  void setGoogleLoginEnabled(bool value) =>
      state = state.copyWith(googleLoginEnabled: value);

  void setAppleLoginEnabled(bool value) =>
      state = state.copyWith(appleLoginEnabled: value);

  void toggleAi(String title, bool value) {
    state = state.copyWith(aiToggles: {...state.aiToggles, title: value});
  }

  void toggleInterest(String title) {
    final next = {...state.selectedInterests};
    next.contains(title) ? next.remove(title) : next.add(title);
    state = state.copyWith(selectedInterests: next);
  }

  void toggleHiddenPin(String id) {
    final next = {...state.hiddenPinIds};
    next.contains(id) ? next.remove(id) : next.add(id);
    state = state.copyWith(hiddenPinIds: next);
  }

  void toggleBoardRecommendation(String id, bool value) {
    state = state.copyWith(
      boardRecommendationToggles: {
        ...state.boardRecommendationToggles,
        id: value,
      },
    );
  }

  void setExpandedNotification(String id) {
    state = state.copyWith(
      expandedNotificationId: state.expandedNotificationId == id ? null : id,
    );
  }

  void setNotificationChannel(
    String id,
    String channel,
    bool value,
  ) {
    final item = state.notifications[id];
    if (item == null) return;
    final next = switch (channel) {
      'push' => item.copyWith(push: value),
      'email' => item.copyWith(email: value),
      'inApp' => item.copyWith(inApp: value),
      _ => item,
    };
    state = state.copyWith(notifications: {...state.notifications, id: next});
  }
}

const aiCategories = [
  'Architecture',
  'Art',
  'Beauty',
  'Children’s fashion',
  'Entertainment',
  'Food and drinks',
  'Health',
  'Home decor',
  'Men’s fashion',
  'Sport',
  'Women’s fashion',
];

final _initialNotifications = {
  for (final item in _notificationSeeds) item.id: item,
};

const _notificationSeeds = [
  NotificationPreference(
    id: 'mentions',
    title: 'Mentions',
    description: 'Get notified when someone mentions you.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'reminders',
    title: 'Reminders',
    description: 'Get reminders about Pins and boards.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'comments_with_photos',
    title: 'Comments with photos',
    description: 'Get notified about comments with photos.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'group_board_updates',
    title: 'Group board updates',
    description: 'Get notified about updates to group boards.',
    push: true,
    email: true,
    inApp: true,
  ),
  NotificationPreference(
    id: 'group_board_invites',
    title: 'Group board invites',
    description: 'Get notified when someone invites you to a group board.',
    push: true,
    email: false,
    inApp: false,
    hasEmail: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'messages',
    title: 'Messages',
    description: 'Get notified about new messages.',
    push: true,
    email: true,
    inApp: true,
  ),
  NotificationPreference(
    id: 'followers',
    title: 'Followers',
    description: 'Get notified when someone follows you.',
    push: true,
    email: false,
    inApp: false,
    hasEmail: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'inspired_home',
    title: 'Inspired by your home feed',
    description: 'Get recommendations inspired by your home feed.',
    push: true,
    email: true,
    inApp: true,
  ),
  NotificationPreference(
    id: 'based_interests',
    title: 'Based on your interests',
    description: 'Get recommendations based on your interests.',
    push: true,
    email: true,
    inApp: true,
  ),
  NotificationPreference(
    id: 'based_activity',
    title: 'Based on your activity',
    description: 'Get recommendations based on your activity.',
    push: true,
    email: true,
    inApp: true,
  ),
  NotificationPreference(
    id: 'boards_like',
    title: 'Boards you might like',
    description: 'Get board recommendations.',
    push: true,
    email: true,
    inApp: true,
  ),
  NotificationPreference(
    id: 'searches_like',
    title: 'Searches you might like',
    description: 'Get search recommendations.',
    push: true,
    email: true,
    inApp: true,
  ),
  NotificationPreference(
    id: 'pins_follow',
    title: 'Pins from people you follow',
    description: 'Get Pins from people you follow.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'pins_might_like',
    title: 'Pins from people you might like',
    description: 'Get Pins from people you might like.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'shopping_pins',
    title: 'Shopping Pins',
    description: 'Get shopping recommendations.',
    push: true,
    email: true,
    inApp: true,
  ),
  NotificationPreference(
    id: 'announcements',
    title: 'Pinterest announcements',
    description: 'Get Pinterest announcements by email.',
    push: false,
    email: true,
    inApp: false,
    hasPush: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'surveys',
    title: 'Surveys and quizzes',
    description: 'Get surveys and quizzes by email.',
    push: false,
    email: true,
    inApp: false,
    hasPush: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'reports_updates',
    title: 'Reports and violations center updates',
    description: 'Get updates about reports and violations.',
    push: false,
    email: true,
    inApp: false,
    hasPush: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'shuffles',
    title: 'Activity on Shuffles',
    description: 'Get activity updates from Shuffles.',
    push: false,
    email: true,
    inApp: false,
    hasPush: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'all_notifications',
    title: 'How you get notifications',
    description: 'Turn on or turn off all notifications.',
    push: true,
    email: true,
    inApp: true,
  ),
  NotificationPreference(
    id: 'created_comments',
    title: 'Comments',
    description: 'Get notified when someone comments on a Pin you created.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'created_reactions',
    title: 'Reactions',
    description: 'Get notified when someone reacts to a Pin you created.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'created_saves',
    title: 'Saves',
    description: 'Get notified when someone saves your Pin.',
    push: true,
    email: false,
    inApp: false,
    hasEmail: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'created_views',
    title: 'Views and impressions',
    description: 'Get notified about views and impressions.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'created_collages',
    title: 'Collages',
    description: 'Get notified about collages.',
    push: true,
    email: false,
    inApp: false,
    hasEmail: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'saved_comments',
    title: 'Comments',
    description: 'Get notified about comments on Pins you saved.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'saved_mentions',
    title: 'Mentions',
    description: 'Get notified about mentions on Pins you saved.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'saved_reminders',
    title: 'Reminders',
    description: 'Get reminders for Pins you saved.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
  NotificationPreference(
    id: 'saved_comments_photos',
    title: 'Comments with photos',
    description: 'Get comments with photos on Pins you saved.',
    push: true,
    email: false,
    inApp: true,
    hasEmail: false,
  ),
];
