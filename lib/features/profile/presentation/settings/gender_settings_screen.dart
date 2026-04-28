import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/profile_providers.dart';
import 'settings_widgets.dart';

class GenderSettingsScreen extends ConsumerWidget {
  const GenderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gender = ref.watch(profileProvider).gender;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            const PinterestBackHeader(title: 'Gender'),
            const SizedBox(height: 30),
            for (final option in const ['Female', 'Male', 'Custom'])
              InkWell(
                onTap: () =>
                    ref.read(profileProvider.notifier).setGender(option),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Row(
                    children: [
                      Icon(
                        gender == option
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: gender == option
                            ? const Color(0xFF8F96FF)
                            : pinterestTextGrey,
                        size: 34,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        option,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
