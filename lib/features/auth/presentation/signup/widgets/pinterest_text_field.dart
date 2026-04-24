import 'package:flutter/material.dart';

class PinterestTextField extends StatelessWidget {
  const PinterestTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.autofocus = false,
    this.suffix,
    this.onSubmitted,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool autofocus;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      autofocus: autofocus,
      onSubmitted: onSubmitted,
      autofillHints: autofillHints,
      cursorColor: const Color(0xFFE60023),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        floatingLabelBehavior: labelText == null
            ? FloatingLabelBehavior.never
            : FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: suffix == null
            ? null
            : Padding(padding: const EdgeInsets.only(right: 14), child: suffix),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.white, width: 1.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.white, width: 1.8),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 22,
          vertical: labelText == null ? 22 : 18,
        ),
      ),
    );
  }
}
