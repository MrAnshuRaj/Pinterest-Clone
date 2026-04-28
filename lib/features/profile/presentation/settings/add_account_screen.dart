import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'settings_widgets.dart';

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            const PinterestBackHeader(title: 'Add account'),
            const SizedBox(height: 24),
            const Text(
              'Add a new account or connect an existing account for seamless account switching',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20, height: 1.2),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF20211D),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: const Color(0xFF2F49E8),
                    child: const Icon(
                      Icons.storefront_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create a free business account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Unlock tools to help:',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        for (final item in const [
                          'Grow your audience',
                          'Drive traffic',
                          'Sell more products',
                        ])
                          Text(
                            '✓ $item',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              height: 1.45,
                            ),
                          ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: () =>
                              context.push('/profile/settings/convert-business'),
                          style: pinterestButtonStyle(color: pinterestRed),
                          child: const Text('Create'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _AddAccountOption(
              icon: Icons.add_rounded,
              color: const Color(0xFF098E4A),
              title: 'Create a new personal account',
              subtitle: 'Create a separate account with another email address',
              onTap: () => context.push('/signup'),
            ),
            _AddAccountOption(
              icon: Icons.person_add_alt_1_rounded,
              color: const Color(0xFFE05B00),
              title: 'Connect existing account',
              subtitle:
                  'Connect Pinterest accounts with different emails for seamless account switching',
              onTap: () => _snack(context),
            ),
            SettingsRow(
              title: 'Manage accounts',
              subtitle:
                  'You can change or convert your account at any time. Go to Settings > Account settings > Account changes',
              onTap: () => _snack(context),
            ),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account switching is a demo action')),
    );
  }
}

class _AddAccountOption extends StatelessWidget {
  const _AddAccountOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 38),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 34),
          ],
        ),
      ),
    );
  }
}
