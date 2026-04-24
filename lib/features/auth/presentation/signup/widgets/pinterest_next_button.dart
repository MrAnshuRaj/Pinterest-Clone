import 'package:flutter/material.dart';

class PinterestNextButton extends StatelessWidget {
  const PinterestNextButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFE60023),
          disabledBackgroundColor: const Color(0xFF4B4A43),
          disabledForegroundColor: const Color(0xFF9E9D99),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
