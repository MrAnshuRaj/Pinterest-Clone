import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/profile_providers.dart';
import 'settings_widgets.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(profileProvider).language;
    const options = [
      'English (India)',
      'English (United States)',
      'Hindi',
      'Spanish',
      'French',
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            const PinterestBackHeader(title: 'Language'),
            const SizedBox(height: 28),
            const Text(
              'Choose languages you speak to customize the content you see. This won’t change your app language. To change your app language, go to General > Language & Region > Phone language.',
              style: TextStyle(
                color: pinterestTextGrey,
                fontSize: 20,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 28),
            for (final option in options)
              SettingsRow(
                title: option,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (option == language)
                      const Icon(Icons.check_rounded, color: Colors.white),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
                onTap: () {
                  ref.read(profileProvider.notifier).setLanguage(option);
                  context.pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
