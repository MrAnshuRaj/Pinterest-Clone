import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/settings_providers.dart';
import 'settings_widgets.dart';

class LoginOptionsScreen extends ConsumerWidget {
  const LoginOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(pinterestSettingsProvider);
    final controller = ref.read(pinterestSettingsProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            const PinterestBackHeader(title: ''),
            const SizedBox(height: 72),
            _LoginOptionRow(
              label: 'Google',
              value: settings.googleLoginEnabled,
              onChanged: controller.setGoogleLoginEnabled,
            ),
            const SizedBox(height: 48),
            _LoginOptionRow(
              label: 'Apple',
              value: settings.appleLoginEnabled,
              onChanged: (value) {
                controller.setAppleLoginEnabled(value);
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Apple sign-in is not configured in this clone',
                      ),
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

class _LoginOptionRow extends StatelessWidget {
  const _LoginOptionRow({
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
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
