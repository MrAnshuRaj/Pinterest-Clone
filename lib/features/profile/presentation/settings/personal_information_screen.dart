import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/profile_providers.dart';
import 'settings_widgets.dart';

class PersonalInformationScreen extends ConsumerWidget {
  const PersonalInformationScreen({super.key});

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
            const PinterestBackHeader(title: 'Personal information'),
            const SizedBox(height: 26),
            const Text(
              'Edit your basic personal info to improve recommendations. This information won’t show up in your public profile.',
              style: TextStyle(
                color: pinterestTextGrey,
                fontSize: 20,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            SettingsRow(
              title: 'Birthdate',
              trailing: _Value(
                profile.birthday.year <= 1970
                    ? ''
                    : formatBirthday(profile.birthday),
              ),
              onTap: () => context.push('/profile/settings/birthdate'),
            ),
            SettingsRow(
              title: 'Gender',
              trailing: _Value(profile.gender),
              onTap: () => context.push('/profile/settings/gender'),
            ),
            SettingsRow(
              title: 'Country/Region',
              trailing: _Value(profile.country),
              onTap: () => context.push('/profile/settings/country'),
            ),
            SettingsRow(
              title: 'Language',
              trailing: _Value(profile.language),
              onTap: () => context.push('/profile/settings/language'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Value extends StatelessWidget {
  const _Value(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(color: Colors.white)),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right_rounded, color: Colors.white),
      ],
    );
  }
}
