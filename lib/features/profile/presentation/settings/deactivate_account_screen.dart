import 'package:flutter/material.dart';

import 'settings_widgets.dart';

class DeactivateAccountScreen extends StatelessWidget {
  const DeactivateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
          child: Column(
            children: [
              const PinterestBackHeader(title: ''),
              const SizedBox(height: 62),
              const Text(
                'Deactivate your\naccount',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Deactivating your account means no one will see your Pins or your profile and you won’t be linked to YouTube, Etsy, or Instagram anymore.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'You can reactivate your account anytime. If you want to use Pinterest again, just log in with anshurajwork@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => _confirm(context),
                style: pinterestButtonStyle(),
                child: const Text('Continue'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF20211D),
          title: const Text('Deactivate account?'),
          content: const Text('This is only a demo action in this clone.'),
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
        );
      },
    );
  }
}
