import 'package:flutter/material.dart';

class PinActionRow extends StatelessWidget {
  const PinActionRow({
    super.key,
    required this.likes,
    required this.comments,
    required this.liked,
    required this.saved,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onMore,
    required this.onSave,
  });

  final int likes;
  final int comments;
  final bool liked;
  final bool saved;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onMore;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          _ActionIcon(
            icon: liked
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            label: '$likes',
            onTap: onLike,
          ),
          const SizedBox(width: 15),
          _ActionIcon(
            icon: Icons.chat_bubble_outline_rounded,
            label: '$comments',
            onTap: onComment,
          ),
          const SizedBox(width: 14),
          _RoundIcon(icon: Icons.upload_rounded, onTap: onShare),
          const SizedBox(width: 12),
          _RoundIcon(icon: Icons.more_horiz_rounded, onTap: onMore),
          const Spacer(),
          FilledButton(
            onPressed: onSave,
            style: FilledButton.styleFrom(
              backgroundColor: saved
                  ? const Color(0xFF3F3F3F)
                  : const Color(0xFFE60023),
              fixedSize: const Size(112, 66),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              saved ? 'Saved' : 'Save',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
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
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 36),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 32),
    );
  }
}
