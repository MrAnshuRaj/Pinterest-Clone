import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/settings_providers.dart';
import 'settings_widgets.dart';

class SecurityLoginsScreen extends ConsumerWidget {
  const SecurityLoginsScreen({super.key});

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
            const PinterestBackHeader(title: 'Security and Logins'),
            const SizedBox(height: 28),
            const Text(
              'Include additional security like turning on two-factor authentication and checking your list of connected devices to keep your account, Pins and boards safe. Learn more',
              style: TextStyle(
                color: pinterestTextGrey,
                fontSize: 20,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            SettingsSwitchRow(
              title: 'Two-factor authentication',
              subtitle:
                  'This makes your account extra secure. Along with your password, you’ll need to enter the secret code that we text your phone each time you log in. Learn more',
              value: settings.twoFactorEnabled,
              onChanged: ref
                  .read(pinterestSettingsProvider.notifier)
                  .setTwoFactorEnabled,
            ),
            const SizedBox(height: 26),
            SettingsRow(
              title: 'Login options',
              onTap: () => context.push('/profile/settings/login-options'),
            ),
          ],
        ),
      ),
    );
  }
}
