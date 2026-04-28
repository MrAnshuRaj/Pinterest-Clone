import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/settings_providers.dart';
import 'settings_widgets.dart';

class ProfileVisibilityScreen extends ConsumerWidget {
  const ProfileVisibilityScreen({super.key});

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
            const PinterestBackHeader(title: 'Profile visibility'),
            const SizedBox(height: 28),
            const Text(
              'Manage how your profile can be viewed on and off of Pinterest',
              style: TextStyle(
                color: pinterestTextGrey,
                fontSize: 20,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            SettingsSwitchRow(
              title: 'Private profile',
              subtitle:
                  'Only people you approve can view your profile, Pins, boards, followers and following lists. Learn more',
              value: settings.privateProfile,
              onChanged: controller.setPrivateProfile,
            ),
            SettingsSwitchRow(
              title: 'Search privacy',
              subtitle:
                  'Hide your profile and boards from search engines (Ex. Google) Learn more',
              value: settings.searchPrivacy,
              onChanged: (value) {
                controller.setSearchPrivacy(value);
                if (value) {
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF20211D),
                      title: const Text('Search privacy enabled'),
                      content: const Text(
                        'Search engines may take time to update.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
