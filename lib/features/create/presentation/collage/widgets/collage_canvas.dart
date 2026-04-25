import 'package:flutter/material.dart';

import '../../../../../shared/widgets/pinterest_cached_image.dart';
import '../../../../home/data/models/pin_model.dart';

class CollageCanvas extends StatelessWidget {
  const CollageCanvas({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelect,
    required this.onMove,
    required this.strokes,
    required this.currentStroke,
    required this.textItems,
    this.previewText,
  });

  final List<CollageItem> items;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final void Function(String id, Offset delta) onMove;
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final List<CollageTextItem> textItems;
  final CollageTextItem? previewText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: ColoredBox(
        color: Colors.white,
        child: CustomPaint(
          painter: _GridAndDrawingPainter(
            strokes: strokes,
            currentStroke: currentStroke,
          ),
          child: Stack(
            children: [
              for (final item in items)
                Positioned(
                  left: item.dx,
                  top: item.dy,
                  child: GestureDetector(
                    onTap: () => onSelect(item.id),
                    onPanUpdate: (details) => onMove(item.id, details.delta),
                    child: Transform.rotate(
                      angle: item.rotation,
                      child: Container(
                        width: item.width,
                        height: item.height,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedId == item.id
                                ? const Color(0xFFE60023)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: PinterestCachedImage(
                          imageUrl: item.imageUrl,
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                  ),
                ),
              for (final item in textItems)
                Positioned(
                  left: item.offset.dx,
                  top: item.offset.dy,
                  child: Text(
                    item.text,
                    style: TextStyle(
                      color: item.color,
                      fontSize: item.fontSize,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              if (previewText != null)
                Center(
                  child: Text(
                    previewText!.text.isEmpty
                        ? 'Type something...'
                        : previewText!.text,
                    style: TextStyle(
                      color: previewText!.text.isEmpty
                          ? const Color(0xFF777777)
                          : previewText!.color,
                      fontSize: previewText!.fontSize,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CollageTextItem {
  const CollageTextItem({
    required this.text,
    required this.offset,
    required this.fontSize,
    required this.color,
  });

  final String text;
  final Offset offset;
  final double fontSize;
  final Color color;
}

class _GridAndDrawingPainter extends CustomPainter {
  const _GridAndDrawingPainter({
    required this.strokes,
    required this.currentStroke,
  });

  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFFD3D3D3)
      ..strokeWidth = 1.2;
    for (double x = 22; x < size.width; x += 26) {
      for (double y = 22; y < size.height; y += 26) {
        canvas.drawCircle(Offset(x, y), 1.4, dotPaint);
      }
    }

    final linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    for (final stroke in [...strokes, currentStroke]) {
      for (var i = 1; i < stroke.length; i++) {
        canvas.drawLine(stroke[i - 1], stroke[i], linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridAndDrawingPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke;
  }
}
