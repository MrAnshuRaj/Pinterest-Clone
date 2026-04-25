import 'package:flutter/material.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  final _altController = TextEditingController();
  bool _allowComments = true;
  bool _showSimilarProducts = true;

  @override
  void initState() {
    super.initState();
    _altController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _altController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
          children: [
            SizedBox(
              height: 74,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Advanced settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 48),
            const Text('Engagement settings', style: _sectionStyle),
            const SizedBox(height: 22),
            _SwitchRow(
              title: 'Allow comments',
              value: _allowComments,
              onChanged: (value) => setState(() => _allowComments = value),
            ),
            const SizedBox(height: 28),
            _AltTextBox(controller: _altController),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text(
                    'This helps people using screen readers understand what your Pin is about.',
                    style: TextStyle(
                      color: Color(0xFF9F9F9F),
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),
                Text(
                  '${_altController.text.length}/500',
                  style: const TextStyle(
                    color: Color(0xFF9F9F9F),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 62),
            const Text('Shopping recommendations', style: _sectionStyle),
            const SizedBox(height: 22),
            _SwitchRow(
              title: 'Show similar products',
              value: _showSimilarProducts,
              onChanged: (value) =>
                  setState(() => _showSimilarProducts = value),
            ),
            const SizedBox(height: 4),
            const Text(
              'People can shop products similar to what’s shown in this Pin using visual search.',
              style: TextStyle(
                color: Color(0xFFB5B5B5),
                fontSize: 17,
                height: 1.28,
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Shopping recommendations aren’t available for Pins with tagged products or paid partnership label.',
              style: TextStyle(
                color: Color(0xFF9F9F9F),
                fontSize: 17,
                height: 1.28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF6C7DFF),
        ),
      ],
    );
  }
}

class _AltTextBox extends StatelessWidget {
  const _AltTextBox({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alt text',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          TextField(
            controller: controller,
            maxLength: 500,
            maxLines: 2,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: const InputDecoration(
              hintText: 'Describe your Pin’s visual details',
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}

const _sectionStyle = TextStyle(
  color: Colors.white,
  fontSize: 22,
  fontWeight: FontWeight.w800,
);
