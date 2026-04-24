import 'package:flutter/material.dart';

class OnboardingProgressDots extends StatelessWidget {
  const OnboardingProgressDots({
    super.key,
    required this.totalDots,
    required this.activeIndex,
  });

  final int totalDots;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalDots, (index) {
        final isActive = index == activeIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 14 : 11,
          height: isActive ? 14 : 11,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : const Color(0xFF5A5A5A),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
