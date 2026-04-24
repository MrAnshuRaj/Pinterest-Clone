import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.foregroundColor = Colors.white,
    this.borderColor,
    this.leading,
    this.height = 52,
  });

  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final Widget? leading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: borderColor == null
                ? null
                : Border.all(color: borderColor!, width: 1.2),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(18),
            splashColor: foregroundColor.withValues(alpha: 0.12),
            highlightColor: foregroundColor.withValues(alpha: 0.06),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (leading != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: leading!,
                    ),
                  ),
                Text(
                  label,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
