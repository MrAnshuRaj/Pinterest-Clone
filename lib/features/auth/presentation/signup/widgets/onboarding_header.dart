import 'package:flutter/material.dart';

import 'onboarding_progress_dots.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.onBack,
    required this.activeIndex,
    required this.totalDots,
  });

  final VoidCallback onBack;
  final int activeIndex;
  final int totalDots;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            splashRadius: 22,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: OnboardingProgressDots(
                totalDots: totalDots,
                activeIndex: activeIndex,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
