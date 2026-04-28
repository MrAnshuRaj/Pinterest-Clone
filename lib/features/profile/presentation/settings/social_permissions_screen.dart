import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/settings_providers.dart';
import 'settings_widgets.dart';

class SocialPermissionsScreen extends ConsumerWidget {
  const SocialPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(pinterestSettingsProvider);
    final controller = ref.read(settingsControllerProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            const PinterestBackHeader(title: 'Social permissions and activity'),
            const SizedBox(height: 28),
            const Text(
              'Choose how others can interact with you on Pinterest, and find Pins you’ve interacted with in the past',
              style: TextStyle(
                color: pinterestTextGrey,
                fontSize: 20,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 28),
            const _Section('Messages'),
            SettingsRow(
              title: 'Message settings',
              subtitle:
                  'Choose who can send you a message and add you to group conversations',
              onTap: () => _snack(context),
            ),
            const SizedBox(height: 28),
            const _Section('Comments'),
            SettingsSwitchRow(
              title: 'Allow comments on your Pins',
              subtitle:
                  'Comments will be turned on by default for your new and existing Pins',
              value: settings.allowComments,
              onChanged: controller.setAllowComments,
            ),
            SettingsSwitchRow(
              title: 'Filter comments on my Pins',
              subtitle:
                  'Hide comments from everyone on Pins you created that contain specific words or phrases',
              value: settings.filterCommentsOnMyPins,
              onChanged: controller.setFilterCommentsOnMyPins,
            ),
            SettingsSwitchRow(
              title: 'Filter comments on others’ Pins',
              subtitle:
                  'Hide comments from others’ Pins that contain specific words or phrases',
              value: settings.filterCommentsOnOthersPins,
              onChanged: controller.setFilterCommentsOnOthersPins,
            ),
            SettingsRow(
              title: '@Mentions',
              subtitle: 'Choose who can mention you in a comment',
              onTap: () => _snack(context),
            ),
            SettingsRow(
              title: 'Comment history',
              subtitle:
                  'Find comments you’ve added and go to Pins you’ve commented on',
              onTap: () => _snack(context),
            ),
            const SizedBox(height: 28),
            const _Section('Block list'),
            SettingsRow(
              title: 'Blocked accounts',
              subtitle: 'Manage people you’ve blocked',
              onTap: () => _snack(context),
            ),
            const SizedBox(height: 28),
            const _Section('Shopping recommendations'),
            SettingsSwitchRow(
              title: 'Show similar products',
              subtitle:
                  'People can shop products similar to what’s shown in this Pin using visual search.',
              value: settings.showSimilarProducts,
              onChanged: controller.setShowSimilarProducts,
            ),
            const Text(
              'Shopping recommendations aren’t available for Pins with tagged products or paid partnership label.',
              style: TextStyle(
                color: pinterestTextGrey,
                fontSize: 16,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This setting is a placeholder')),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 22),
    );
  }
}
