import 'package:flutter/material.dart';

class CollageBottomToolbar extends StatelessWidget {
  const CollageBottomToolbar({
    super.key,
    required this.onDraw,
    required this.onText,
    required this.onAdd,
    required this.onPhotos,
    required this.onTools,
  });

  final VoidCallback onDraw;
  final VoidCallback onText;
  final VoidCallback onAdd;
  final VoidCallback onPhotos;
  final VoidCallback onTools;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ToolButton(icon: Icons.gesture_rounded, onTap: onDraw),
            _ToolButton(icon: Icons.text_fields_rounded, onTap: onText),
            InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                  size: 42,
                ),
              ),
            ),
            _ToolButton(icon: Icons.photo_outlined, onTap: onPhotos),
            _ToolButton(icon: Icons.apps_rounded, onTap: onTools),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 34),
    );
  }
}
