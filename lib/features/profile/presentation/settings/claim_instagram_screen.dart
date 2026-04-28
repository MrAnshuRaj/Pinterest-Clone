import 'package:flutter/material.dart';

import 'settings_widgets.dart';

class ClaimInstagramScreen extends StatelessWidget {
  const ClaimInstagramScreen({super.key});

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
              const PinterestBackHeader(title: 'Instagram'),
              const SizedBox(height: 38),
              const Text(
                'Claim your Instagram account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Connect your account to auto-create your Instagram posts as Pins. Learn more',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20, height: 1.25),
              ),
              const SizedBox(height: 62),
              FilledButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Instagram connection is not configured in this clone',
                    ),
                  ),
                ),
                style: pinterestButtonStyle(color: pinterestRed).copyWith(
                  minimumSize: const WidgetStatePropertyAll(Size(104, 66)),
                ),
                child: const Text('Claim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
