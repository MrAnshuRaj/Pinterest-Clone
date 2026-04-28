import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateEntrySheet extends StatelessWidget {
  const CreateEntrySheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateEntrySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 34),
      decoration: const BoxDecoration(
        color: Color(0xFF20211D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Start creating now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CreateOption(
                  icon: Icons.push_pin_outlined,
                  label: 'Pin',
                  onTap: () {
                    Navigator.of(context).pop();
                    router.push('/create/pin');
                  },
                ),
                const SizedBox(width: 22),
                _CreateOption(
                  icon: Icons.content_cut_rounded,
                  label: 'Collage',
                  onTap: () {
                    Navigator.of(context).pop();
                    router.push('/create/collage');
                  },
                ),
                const SizedBox(width: 22),
                _CreateOption(
                  icon: Icons.dashboard_outlined,
                  label: 'Board',
                  onTap: () {
                    Navigator.of(context).pop();
                    router.push('/create/board');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateOption extends StatelessWidget {
  const _CreateOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Column(
        children: [
          Container(
            width: 98,
            height: 98,
            decoration: BoxDecoration(
              color: const Color(0xFF4A4B45),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: Colors.white, size: 38),
          ),
          const SizedBox(height: 13),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
