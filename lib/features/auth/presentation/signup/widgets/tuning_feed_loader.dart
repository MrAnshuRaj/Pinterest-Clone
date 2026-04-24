import 'dart:math' as math;

import 'package:flutter/material.dart';

class TuningFeedLoader extends StatefulWidget {
  const TuningFeedLoader({super.key});

  @override
  State<TuningFeedLoader> createState() => _TuningFeedLoaderState();
}

class _TuningFeedLoaderState extends State<TuningFeedLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _cards = [
    _LoaderCardData(
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=900&q=80',
      angle: -0.14,
      dx: -82,
      dy: 26,
    ),
    _LoaderCardData(
      imageUrl:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=900&q=80',
      angle: 0,
      dx: 0,
      dy: 0,
    ),
    _LoaderCardData(
      imageUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
      angle: 0.12,
      dx: 70,
      dy: 24,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final wave = Curves.easeInOut.transform(_controller.value);

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 6, 0, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.72,
                  height: 7,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE60023),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 72),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tuning your feed...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.3,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 320,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    for (var index = 0; index < _cards.length; index++)
                      _AnimatedLoaderCard(
                        data: _cards[index],
                        index: index,
                        wave: wave,
                      ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFFE60023),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedLoaderCard extends StatelessWidget {
  const _AnimatedLoaderCard({
    required this.data,
    required this.index,
    required this.wave,
  });

  final _LoaderCardData data;
  final int index;
  final double wave;

  @override
  Widget build(BuildContext context) {
    final offsetY = math.sin((wave + index * 0.18) * math.pi) * 10;
    final opacity = 0.9 - (index * 0.1) + (wave * 0.06);

    return Transform.translate(
      offset: Offset(data.dx + wave * 8, data.dy + offsetY),
      child: Transform.rotate(
        angle: data.angle + math.sin((wave + index * 0.12) * math.pi) * 0.02,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: SizedBox(
            width: 182,
            height: 248,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.network(
                data.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const ColoredBox(color: Color(0xFF1A1A1A));
                },
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(color: Color(0xFF2A2A2A));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoaderCardData {
  const _LoaderCardData({
    required this.imageUrl,
    required this.angle,
    required this.dx,
    required this.dy,
  });

  final String imageUrl;
  final double angle;
  final double dx;
  final double dy;
}
