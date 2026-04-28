import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/profile_providers.dart';
import 'settings_widgets.dart';

class DeleteAccountScreen extends ConsumerWidget {
  const DeleteAccountScreen({super.key});

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
              const SizedBox(height: 68),
              const Text(
                'Delete your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Deleting your account is permanent and means you won’t be able to get your Pins or boards back. All your Pinterest account data will be deleted.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20, height: 1.25),
              ),
              const SizedBox(height: 30),
              Text(
                '${profile.name.split(' ').first}, if you’re ready to leave forever, we’ll send you an email with the final step to:',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 20, height: 1.25),
              ),
              const SizedBox(height: 24),
              Text(
                profile.email,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 34),
              FilledButton(
                onPressed: () => _confirm(context),
                style: pinterestButtonStyle(),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF20211D),
        title: const Text('Delete account?'),
        content: const Text(
          'This clone will not actually delete your Clerk account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
