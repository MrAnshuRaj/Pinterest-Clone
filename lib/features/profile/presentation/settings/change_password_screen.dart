import 'package:flutter/material.dart';

import 'settings_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  bool _showCurrent = false;
  bool _showNext = false;

  @override
  void initState() {
    super.initState();
    _current.addListener(() => setState(() {}));
    _next.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    super.dispose();
  }

  bool get _valid => _current.text.isNotEmpty && _next.text.length >= 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
          child: Column(
            children: [
              PinterestBackHeader(
                title: 'Change password',
                trailing: FilledButton(
                  onPressed: _valid
                      ? () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password change is not connected in this demo',
                              ),
                            ),
                          )
                      : null,
                  style: pinterestButtonStyle(color: pinterestRed),
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(height: 22),
              _PasswordField(
                label: 'Current password',
                controller: _current,
                visible: _showCurrent,
                onToggle: () => setState(() => _showCurrent = !_showCurrent),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset is not connected in this demo'),
                    ),
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: pinterestTextGrey),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _PasswordField(
                label: 'New password',
                hint: 'Create a strong password',
                controller: _next,
                visible: _showNext,
                onToggle: () => setState(() => _showNext = !_showNext),
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Use 8 or more letters, numbers and symbols',
                  style: TextStyle(color: pinterestTextGrey, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.visible,
    required this.onToggle,
    this.hint,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool visible;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white, width: 1.1),
        ),
      ),
    );
  }
}
