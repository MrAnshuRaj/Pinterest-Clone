import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/pinterest_cached_image.dart';
import '../../data/models/pin_model.dart';

class PinCard extends StatelessWidget {
  const PinCard({super.key, required this.pin, this.showTitle = false});

  final PinModel pin;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/pin/${pin.id}', extra: pin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: 'pin-${pin.id}',
                child: AspectRatio(
                  aspectRatio: 1 / pin.heightRatio,
                  child: PinterestCachedImage(imageUrl: pin.imageUrl),
                ),
              ),
              Positioned(
                right: 4,
                bottom: 3,
                child: IconButton(
                  onPressed: () => showPinMenu(context),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black.withValues(alpha: 0.18),
                  ),
                  icon: const Icon(Icons.more_horiz_rounded, size: 27),
                ),
              ),
            ],
          ),
          if (showTitle) ...[
            const SizedBox(height: 8),
            Text(
              pin.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static void showPinMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF171717),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetAction(
                  label: 'Hide Pin',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _SheetAction(
                  label: 'Download image',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _SheetAction(
                  label: 'Report Pin',
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 8),
                _SheetAction(
                  label: 'Cancel',
                  centered: true,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.label,
    required this.onTap,
    this.centered = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        textAlign: centered ? TextAlign.center : TextAlign.start,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
