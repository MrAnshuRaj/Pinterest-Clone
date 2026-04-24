import 'package:flutter/material.dart';

import 'breathing_image_card.dart';

class AuthImageCollage extends StatelessWidget {
  const AuthImageCollage({super.key, required this.height});

  final double height;

  static const _imageSpecs = [
    _CollageImageSpec(
      imageUrl:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
      leftFactor: -0.06,
      topFactor: 0.02,
      widthFactor: 0.38,
      heightFactor: 0.34,
      borderRadius: 22,
      duration: Duration(milliseconds: 5400),
      delay: Duration(milliseconds: 0),
      alignment: Alignment.centerLeft,
    ),
    _CollageImageSpec(
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80',
      leftFactor: 0.66,
      topFactor: -0.08,
      widthFactor: 0.34,
      heightFactor: 0.20,
      borderRadius: 20,
      duration: Duration(milliseconds: 6200),
      delay: Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
    ),
    _CollageImageSpec(
      imageUrl:
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1200&q=80',
      leftFactor: 0.22,
      topFactor: 0.18,
      widthFactor: 0.56,
      heightFactor: 0.56,
      borderRadius: 24,
      duration: Duration(milliseconds: 7000),
      delay: Duration(milliseconds: 120),
      alignment: Alignment.topCenter,
    ),
    _CollageImageSpec(
      imageUrl:
          'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=900&q=80',
      leftFactor: 0.84,
      topFactor: 0.50,
      widthFactor: 0.22,
      heightFactor: 0.24,
      borderRadius: 22,
      duration: Duration(milliseconds: 5900),
      delay: Duration(milliseconds: 520),
      alignment: Alignment.center,
    ),
    _CollageImageSpec(
      imageUrl:
          'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?auto=format&fit=crop&w=900&q=80',
      leftFactor: -0.08,
      topFactor: 0.67,
      widthFactor: 0.38,
      heightFactor: 0.32,
      borderRadius: 22,
      duration: Duration(milliseconds: 6800),
      delay: Duration(milliseconds: 240),
      alignment: Alignment.center,
    ),
    _CollageImageSpec(
      imageUrl:
          'https://images.unsplash.com/photo-1517705008128-361805f42e86?auto=format&fit=crop&w=900&q=80',
      leftFactor: 0.84,
      topFactor: 0.80,
      widthFactor: 0.24,
      heightFactor: 0.22,
      borderRadius: 20,
      duration: Duration(milliseconds: 6400),
      delay: Duration(milliseconds: 680),
      alignment: Alignment.center,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                for (final spec in _imageSpecs)
                  Positioned(
                    left: width * spec.leftFactor,
                    top: height * spec.topFactor,
                    width: width * spec.widthFactor,
                    height: height * spec.heightFactor,
                    child: BreathingImageCard(
                      imageUrl: spec.imageUrl,
                      borderRadius: spec.borderRadius,
                      duration: spec.duration,
                      delay: spec.delay,
                      alignment: spec.alignment,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CollageImageSpec {
  const _CollageImageSpec({
    required this.imageUrl,
    required this.leftFactor,
    required this.topFactor,
    required this.widthFactor,
    required this.heightFactor,
    required this.borderRadius,
    required this.duration,
    required this.delay,
    required this.alignment,
  });

  final String imageUrl;
  final double leftFactor;
  final double topFactor;
  final double widthFactor;
  final double heightFactor;
  final double borderRadius;
  final Duration duration;
  final Duration delay;
  final Alignment alignment;
}
