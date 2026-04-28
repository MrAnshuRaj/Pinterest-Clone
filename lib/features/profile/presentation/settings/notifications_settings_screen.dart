import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/settings_providers.dart';
import 'settings_widgets.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  static const _sections = [
    _NotificationSection('', [
      'mentions',
      'reminders',
      'comments_with_photos',
    ]),
    _NotificationSection('Social activity', [
      'group_board_updates',
      'group_board_invites',
      'messages',
      'followers',
    ]),
    _NotificationSection('Recommendations', [
      'inspired_home',
      'based_interests',
      'based_activity',
      'boards_like',
      'searches_like',
      'pins_follow',
      'pins_might_like',
      'shopping_pins',
    ]),
    _NotificationSection('Other notifications', [
      'announcements',
      'surveys',
      'reports_updates',
      'shuffles',
      'all_notifications',
    ]),
    _NotificationSection('Pins you created', [
      'created_comments',
      'created_reactions',
      'created_saves',
      'created_views',
      'created_collages',
    ]),
    _NotificationSection('Pins you saved', [
      'saved_comments',
      'saved_mentions',
      'saved_reminders',
      'saved_comments_photos',
    ]),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(pinterestSettingsProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            const PinterestBackHeader(title: 'Notifications'),
            const SizedBox(height: 34),
            for (final section in _sections) ...[
              if (section.title.isNotEmpty) ...[
                const SizedBox(height: 28),
                Text(
                  section.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              for (final id in section.ids)
                _NotificationRow(
                  preference: settings.notifications[id]!,
                  expanded: settings.expandedNotificationId == id,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotificationSection {
  const _NotificationSection(this.title, this.ids);

  final String title;
  final List<String> ids;
}

class _NotificationRow extends ConsumerWidget {
  const _NotificationRow({
    required this.preference,
    required this.expanded,
  });

  final NotificationPreference preference;
  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(pinterestSettingsProvider.notifier);
    return InkWell(
      onTap: () => controller.setExpandedNotification(preference.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    preference.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
            if (!expanded)
              Text(
                preference.summary,
                style: const TextStyle(
                  color: pinterestTextGrey,
                  fontSize: 19,
                ),
              )
            else ...[
              const SizedBox(height: 8),
              Text(
                preference.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'How do you want to be notified?',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              if (preference.hasPush)
                _ChannelSwitch(
                  label: 'Push',
                  value: preference.push,
                  onChanged: (value) => controller.setNotificationChannel(
                    preference.id,
                    'push',
                    value,
                  ),
                ),
              if (preference.hasEmail)
                _ChannelSwitch(
                  label: 'Email',
                  value: preference.email,
                  onChanged: (value) => controller.setNotificationChannel(
                    preference.id,
                    'email',
                    value,
                  ),
                ),
              if (preference.hasInApp)
                _ChannelSwitch(
                  label: 'In-app',
                  value: preference.inApp,
                  onChanged: (value) => controller.setNotificationChannel(
                    preference.id,
                    'inApp',
                    value,
                  ),
                ),
              const Divider(color: Color(0xFF525252), height: 26),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChannelSwitch extends StatelessWidget {
  const _ChannelSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 19),
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF6265F6),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: pinterestGrey,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
