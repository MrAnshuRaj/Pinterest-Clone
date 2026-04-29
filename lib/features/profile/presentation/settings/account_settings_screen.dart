import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/clerk_config.dart';
import '../../../auth/application/auth_providers.dart';
import '../../application/profile_providers.dart';
import '../widgets/share_profile_sheet.dart';
import 'settings_widgets.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final profile = ref.watch(profileProvider);
    if (profileAsync.hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: PinterestStatusView(
          message: friendlyProfileLoadError(profileAsync.error!),
        ),
      );
    }
    if (profileAsync.isLoading && profile.name.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: PinterestStatusView(
          message: 'Loading your account...',
          showSpinner: true,
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            const PinterestBackHeader(title: 'Your account'),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF20211D),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      PinterestAvatar(
                        initial: profile.avatarInitial,
                        radius: 45,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              profile.handle,
                              style: const TextStyle(
                                color: pinterestTextGrey,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => context.push('/profile'),
                          style: pinterestButtonStyle(color: Colors.black),
                          child: const Text('View profile'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => ShareProfileSheet.show(context),
                          style: pinterestButtonStyle(color: Colors.black),
                          child: const Text('Share profile'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 38),
            const _SectionTitle('Settings'),
            SettingsRow(
              title: 'Account management',
              onTap: () => context.push('/profile/settings/account-management'),
            ),
            SettingsRow(
              title: 'Profile visibility',
              onTap: () => context.push('/profile/settings/profile-visibility'),
            ),
            SettingsRow(
              title: 'Refine your recommendations',
              onTap: () =>
                  context.push('/profile/settings/refine-recommendations'),
            ),
            SettingsRow(
              title: 'Link to Pinterest',
              onTap: () => context.push('/profile/settings/link-instagram'),
            ),
            SettingsRow(
              title: 'Social permissions and activity',
              onTap: () => context.push('/profile/settings/social-permissions'),
            ),
            SettingsRow(
              title: 'Notifications',
              onTap: () => context.push('/profile/settings/notifications'),
            ),
            SettingsRow(
              title: 'Privacy and data',
              onTap: () => context.push('/profile/settings/privacy-data'),
            ),
            SettingsRow(
              title: 'Reports and violations center',
              onTap: () => context.push('/profile/settings/reports-violations'),
            ),
            const SizedBox(height: 38),
            const _SectionTitle('Login'),
            SettingsRow(
              title: 'Add account',
              onTap: () => context.push('/profile/settings/add-account'),
            ),
            SettingsRow(
              title: 'Security',
              onTap: () => context.push('/profile/settings/security-logins'),
            ),
            SettingsRow(
              title: 'Be a beta tester',
              external: true,
              onTap: () => _placeholder(context),
            ),
            SettingsRow(title: 'Log out', onTap: () => _logout(context, ref)),
            const SizedBox(height: 38),
            const _SectionTitle('Support'),
            SettingsRow(
              title: 'Help center',
              external: true,
              onTap: () => _placeholder(context),
            ),
            SettingsRow(
              title: 'Terms of service',
              external: true,
              onTap: () => _placeholder(context),
            ),
            SettingsRow(
              title: 'Privacy policy',
              external: true,
              onTap: () => _placeholder(context),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _logout(BuildContext context, WidgetRef ref) async {
    if (!isClerkConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clerk is not configured, so logout is a demo.'),
        ),
      );
      return;
    }
    final authState = ClerkAuth.of(context, listen: false);
    await ref.read(clerkAuthServiceProvider(authState)).signOut();
  }

  static void _placeholder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This settings page is a placeholder')),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
