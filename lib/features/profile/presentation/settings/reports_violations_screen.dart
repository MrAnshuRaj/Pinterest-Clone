import 'package:flutter/material.dart';

import 'settings_widgets.dart';

class ReportsViolationsScreen extends StatefulWidget {
  const ReportsViolationsScreen({super.key});

  @override
  State<ReportsViolationsScreen> createState() =>
      _ReportsViolationsScreenState();
}

class _ReportsViolationsScreenState extends State<ReportsViolationsScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            const PinterestBackHeader(title: 'Reports and violations center'),
            const SizedBox(height: 28),
            const Text(
              'Find information related to boards, comments, Pins, or profiles that violate our Community Guidelines or local law. If you believe we’ve mistakenly taken action, you can submit an appeal within 6 months of our action. Learn more',
              style: TextStyle(color: pinterestTextGrey, fontSize: 19, height: 1.18),
            ),
            const SizedBox(height: 36),
            Row(
              children: [
                _Tab(
                  label: 'Your account',
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                const SizedBox(width: 34),
                _Tab(
                  label: 'Your reports',
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
              ],
            ),
            const SizedBox(height: 64),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 34),
              decoration: BoxDecoration(
                color: pinterestGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF737DFF),
                    size: 44,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _tab == 0 ? 'Nothing to see here!' : 'No reports yet',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _tab == 0
                        ? 'Looks like you don’t have violations.'
                        : 'Reports you submit will appear here.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 4,
            width: 104,
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}
