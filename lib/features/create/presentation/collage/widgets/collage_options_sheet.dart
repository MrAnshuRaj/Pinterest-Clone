import 'package:flutter/material.dart';

class CollageOptionsSheet extends StatelessWidget {
  const CollageOptionsSheet({
    super.key,
    required this.onSaveDraft,
    required this.onStartNew,
    required this.onDuplicate,
  });

  final VoidCallback onSaveDraft;
  final VoidCallback onStartNew;
  final VoidCallback onDuplicate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF20211D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Collage options',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            _Option(
              label: 'Learn how to collage',
              onTap: () => _snack(context, 'Collage tips are coming soon.'),
            ),
            _Option(label: 'Save as a draft', onTap: onSaveDraft),
            _Option(label: 'Start a new collage', onTap: onStartNew),
            _Option(label: 'Duplicate', onTap: onDuplicate),
            _Option(
              label: 'Download image',
              onTap: () => _snack(context, 'Image downloaded'),
            ),
            const SizedBox(height: 18),
            Center(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4A4B45),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Option extends StatelessWidget {
  const _Option({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
