import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/models/app_settings_model.dart';
import '../data/repositories/settings_repository.dart';

final appSettingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final appSettingsProvider = StreamProvider<AppSettingsModel>(
  (ref) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) {
      return Stream.value(AppSettingsModel.defaults());
    }

    final repository = ref.watch(appSettingsRepositoryProvider);
    unawaited(repository.ensureDefaultSettings(userId));
    return repository.watchSettings(userId);
  },
  dependencies: [currentUserIdProvider],
);

final resolvedAppSettingsProvider = Provider<AppSettingsModel>(
  (ref) {
    return ref.watch(appSettingsProvider).valueOrNull ??
        AppSettingsModel.defaults();
  },
  dependencies: [appSettingsProvider],
);

final pinterestSettingsProvider = resolvedAppSettingsProvider;

final expandedNotificationIdProvider = StateProvider<String?>((ref) => null);

final settingsControllerProvider = Provider<SettingsController>((ref) {
  return SettingsController(ref);
});

class NotificationPreference {
  const NotificationPreference({
    required this.id,
    required this.title,
    required this.description,
    required this.hasPush,
    required this.hasEmail,
    required this.hasInApp,
  });

  final String id;
  final String title;
  final String description;
  final bool hasPush;
  final bool hasEmail;
  final bool hasInApp;
}

const aiCategories = [
  'Architecture',
  'Art',
  'Beauty',
  'Children\'s fashion',
  'Entertainment',
  'Food and drinks',
  'Health',
  'Home decor',
  'Men\'s fashion',
  'Sport',
  'Women\'s fashion',
];

const notificationPreferences = [
  NotificationPreference(
    id: 'mentions',
    title: 'Mentions',
    description: 'Get notified when someone mentions you.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'reminders',
    title: 'Reminders',
    description: 'Get reminders about Pins and boards.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'comments_with_photos',
    title: 'Comments with photos',
    description: 'Get notified about comments with photos.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'group_board_updates',
    title: 'Group board updates',
    description: 'Get notified about updates to group boards.',
    hasPush: true,
    hasEmail: true,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'group_board_invites',
    title: 'Group board invites',
    description: 'Get notified when someone invites you to a group board.',
    hasPush: true,
    hasEmail: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'messages',
    title: 'Messages',
    description: 'Get notified about new messages.',
    hasPush: true,
    hasEmail: true,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'followers',
    title: 'Followers',
    description: 'Get notified when someone follows you.',
    hasPush: true,
    hasEmail: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'inspired_home',
    title: 'Inspired by your home feed',
    description: 'Get recommendations inspired by your home feed.',
    hasPush: true,
    hasEmail: true,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'based_interests',
    title: 'Based on your interests',
    description: 'Get recommendations based on your interests.',
    hasPush: true,
    hasEmail: true,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'based_activity',
    title: 'Based on your activity',
    description: 'Get recommendations based on your activity.',
    hasPush: true,
    hasEmail: true,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'boards_like',
    title: 'Boards you might like',
    description: 'Get board recommendations.',
    hasPush: true,
    hasEmail: true,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'searches_like',
    title: 'Searches you might like',
    description: 'Get search recommendations.',
    hasPush: true,
    hasEmail: true,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'pins_follow',
    title: 'Pins from people you follow',
    description: 'Get Pins from people you follow.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'pins_might_like',
    title: 'Pins from people you might like',
    description: 'Get Pins from people you might like.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'shopping_pins',
    title: 'Shopping Pins',
    description: 'Get shopping recommendations.',
    hasPush: true,
    hasEmail: true,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'announcements',
    title: 'Pinterest announcements',
    description: 'Get Pinterest announcements by email.',
    hasPush: false,
    hasEmail: true,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'surveys',
    title: 'Surveys and quizzes',
    description: 'Get surveys and quizzes by email.',
    hasPush: false,
    hasEmail: true,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'reports_updates',
    title: 'Reports and violations center updates',
    description: 'Get updates about reports and violations.',
    hasPush: false,
    hasEmail: true,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'shuffles',
    title: 'Activity on Shuffles',
    description: 'Get activity updates from Shuffles.',
    hasPush: false,
    hasEmail: true,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'all_notifications',
    title: 'How you get notifications',
    description: 'Turn on or turn off all notifications.',
    hasPush: true,
    hasEmail: true,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'created_comments',
    title: 'Comments',
    description: 'Get notified when someone comments on a Pin you created.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'created_reactions',
    title: 'Reactions',
    description: 'Get notified when someone reacts to a Pin you created.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'created_saves',
    title: 'Saves',
    description: 'Get notified when someone saves your Pin.',
    hasPush: true,
    hasEmail: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'created_views',
    title: 'Views and impressions',
    description: 'Get notified about views and impressions.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'created_collages',
    title: 'Collages',
    description: 'Get notified about collages.',
    hasPush: true,
    hasEmail: false,
    hasInApp: false,
  ),
  NotificationPreference(
    id: 'saved_comments',
    title: 'Comments',
    description: 'Get notified about comments on Pins you saved.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'saved_mentions',
    title: 'Mentions',
    description: 'Get notified about mentions on Pins you saved.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'saved_reminders',
    title: 'Reminders',
    description: 'Get reminders for Pins you saved.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
  NotificationPreference(
    id: 'saved_comments_photos',
    title: 'Comments with photos',
    description: 'Get comments with photos on Pins you saved.',
    hasPush: true,
    hasEmail: false,
    hasInApp: true,
  ),
];

class SettingsController {
  SettingsController(this._ref);

  final Ref _ref;

  String? get _userId => _ref.read(currentUserIdProvider);
  AppSettingsModel get _settings => _ref.read(resolvedAppSettingsProvider);

  Future<void> _update(Map<String, dynamic> data) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref.read(appSettingsRepositoryProvider).updateSettings(userId, data);
  }

  Future<void> setPrivateProfile(bool value) =>
      _update({'privateProfile': value});

  Future<void> setSearchPrivacy(bool value) =>
      _update({'searchPrivacy': value});

  Future<void> setAppSounds(bool value) => _update({'appSounds': value});

  Future<void> setAllowComments(bool value) =>
      _update({'allowComments': value});

  Future<void> setFilterCommentsOnMyPins(bool value) =>
      _update({'filterCommentsOnMyPins': value});

  Future<void> setFilterCommentsOnOthersPins(bool value) =>
      _update({'filterCommentsOnOthersPins': value});

  Future<void> setShowSimilarProducts(bool value) =>
      _update({'showSimilarProducts': value});

  Future<void> setPrivacyToggle(String key, bool value) async {
    if (key == 'autoplayVideosOnCellular') {
      await _update({'autoplayVideosOnCellular': value});
      return;
    }
    final next = {..._settings.adsPersonalization, key: value};
    await _update({'adsPersonalization': next});
  }

  Future<void> setTwoFactorEnabled(bool value) =>
      _update({'twoFactorEnabled': value});

  Future<void> setGoogleLoginEnabled(bool value) =>
      _update({'googleLoginEnabled': value});

  Future<void> setAppleLoginEnabled(bool value) =>
      _update({'appleLoginEnabled': value});

  Future<void> toggleAi(String title, bool value) => _update({
    'aiContentToggles': {..._settings.aiContentToggles, title: value},
  });

  Future<void> toggleInterest(String title) {
    final next = [..._settings.selectedInterests];
    if (next.contains(title)) {
      next.remove(title);
    } else {
      next.add(title);
    }
    return _update({'selectedInterests': next});
  }

  Future<void> toggleHiddenPin(String id) {
    final next = [..._settings.hiddenPinIds];
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    return _update({'hiddenPinIds': next});
  }

  Future<void> toggleBoardRecommendation(String id, bool value) => _update({
    'boardRecommendationToggles': {
      ..._settings.boardRecommendationToggles,
      id: value,
    },
  });

  void setExpandedNotification(String id) {
    final notifier = _ref.read(expandedNotificationIdProvider.notifier);
    notifier.state = notifier.state == id ? null : id;
  }

  Future<void> setNotificationChannel(
    String id,
    String channel,
    bool value,
  ) async {
    final nextChannels = {
      ...(_settings.notificationSettings[id] ?? const {}),
      channel: value,
    };
    await _update({
      'notificationSettings': {
        ..._settings.notificationSettings,
        id: nextChannels,
      },
    });
  }
}
