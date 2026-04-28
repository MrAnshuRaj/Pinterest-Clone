import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/profile_providers.dart';
import 'settings_widgets.dart';

class AccountManagementScreen extends ConsumerWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            const PinterestBackHeader(title: 'Account management'),
            const SizedBox(height: 22),
            const Text(
              'Make changes to your personal information or account type',
              style: TextStyle(
                color: pinterestTextGrey,
                fontSize: 20,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Your account',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 18),
            SettingsRow(
              title: 'Personal information',
              onTap: () =>
                  context.push('/profile/settings/personal-information'),
            ),
            SettingsRow(
              title: 'Email',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 155,
                    child: Text(
                      profile.email,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white),
                ],
              ),
              onTap: () {},
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF147447),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFFA9F7C5),
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Confirmed',
                    style: TextStyle(
                      color: Color(0xFFA9F7C5),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SettingsRow(
              title: 'Password',
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Change password',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.chevron_right_rounded, color: Colors.white),
                ],
              ),
              onTap: () => context.push('/profile/settings/change-password'),
            ),
            SettingsRow(
              title: 'Convert to a business account',
              subtitle:
                  'Grow your business or brand with tools like ads and analytics. Your content, profile and followers will stay the same.',
              onTap: () => context.push('/profile/settings/convert-business'),
            ),
            SettingsRow(
              title: 'App sounds',
              subtitle: 'Turn on for sounds from the Pinterest app',
              trailing: Switch(
                value: profile.appSounds,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF6265F6),
                onChanged: (value) =>
                    ref.read(profileProvider.notifier).setAppSounds(value),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Deactivation and deletion',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 18),
            SettingsRow(
              title: 'Deactivate account',
              subtitle: 'Hide your Pins and profile',
              onTap: () => context.push('/profile/settings/deactivate'),
            ),
            SettingsRow(
              title: 'Delete your data and account',
              subtitle: 'Delete your data and account',
              onTap: () => context.push('/profile/settings/delete-account'),
            ),
          ],
        ),
      ),
    );
  }
}
