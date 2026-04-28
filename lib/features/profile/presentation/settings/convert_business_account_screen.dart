import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/profile_providers.dart';
import 'settings_widgets.dart';

class ConvertBusinessAccountScreen extends ConsumerWidget {
  const ConvertBusinessAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
          child: Column(
            children: [
              const PinterestBackHeader(title: ''),
              const SizedBox(height: 46),
              const Text(
                'Convert to a business\naccount',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Grow your business or brand with tools like ads and analytics. Your content, profile and followers will stay the same. You can reverse this change in Settings.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 38),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PinterestAvatar(
                    initial: profile.avatarInitial,
                    radius: 34,
                    backgroundColor: const Color(0xFF2F49E8),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const Icon(
                    Icons.storefront_outlined,
                    color: Colors.white,
                    size: 36,
                  ),
                ],
              ),
              const SizedBox(height: 34),
              FilledButton(
                onPressed: () async {
                  await ref.read(profileControllerProvider).convertToBusiness();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Converted to business account'),
                    ),
                  );
                  context.pop();
                },
                style: pinterestButtonStyle(color: pinterestRed).copyWith(
                  minimumSize: const WidgetStatePropertyAll(Size(214, 68)),
                ),
                child: const Text('Convert account'),
              ),
              const Spacer(),
              const Text.rich(
                TextSpan(
                  text: 'By converting, you agree to Pinterest’s ',
                  children: [
                    TextSpan(
                      text: 'Business Terms of Service',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(text: ' and acknowledge you’ve read our '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(text: '. '),
                    TextSpan(
                      text: 'Notice at Collection.',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
