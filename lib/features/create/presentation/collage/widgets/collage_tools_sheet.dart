import 'package:flutter/material.dart';

class CollageToolsSheet extends StatelessWidget {
  const CollageToolsSheet({
    super.key,
    required this.onDraw,
    required this.onText,
    required this.onPhotos,
    required this.onLayers,
    required this.onLayouts,
  });

  final VoidCallback onDraw;
  final VoidCallback onText;
  final VoidCallback onPhotos;
  final VoidCallback onLayers;
  final VoidCallback onLayouts;

  @override
  Widget build(BuildContext context) {
    final options = [
      _Tool('Draw', Icons.gesture_rounded, onDraw),
      _Tool('Text', Icons.text_fields_rounded, onText),
      _Tool('Discover', Icons.add_rounded, onPhotos),
      _Tool('Photos', Icons.photo_outlined, onPhotos),
      _Tool(
        'Camera',
        Icons.camera_alt_outlined,
        () => _snack(context, 'Camera is coming soon.'),
      ),
      _Tool('Layers', Icons.layers_outlined, onLayers),
      _Tool('Layouts', Icons.dashboard_outlined, onLayouts),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
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
                      'Collage tools',
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
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisExtent: 92,
              ),
              itemBuilder: (context, index) {
                final option = options[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    option.onTap();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      Icon(option.icon, color: Colors.white, size: 34),
                      const SizedBox(height: 8),
                      Text(
                        option.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
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

class _Tool {
  const _Tool(this.label, this.icon, this.onTap);

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}
