import 'dart:async';

import 'package:flutter/material.dart';

class BreathingImageCard extends StatefulWidget {
  const BreathingImageCard({
    super.key,
    required this.imageUrl,
    required this.borderRadius,
    required this.duration,
    required this.delay,
    this.alignment = Alignment.center,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double borderRadius;
  final Duration duration;
  final Duration delay;
  final Alignment alignment;
  final BoxFit fit;

  @override
  State<BreathingImageCard> createState() => _BreathingImageCardState();
}

class _BreathingImageCardState extends State<BreathingImageCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _translateY;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween(
      begin: 0.985,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _translateY = Tween(
      begin: 3.0,
      end: -3.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _delayTimer = Timer(widget.delay, () {
      if (!mounted) return;
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _translateY.value),
          child: Transform.scale(
            scale: _scale.value,
            alignment: widget.alignment,
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
          child: Image.network(
            widget.imageUrl,
            fit: widget.fit,
            alignment: widget.alignment,
            filterQuality: FilterQuality.medium,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              }

              return const ColoredBox(color: Color(0xFF1A1A1A));
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return const ColoredBox(color: Color(0xFF1A1A1A));
            },
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: Color(0xFF252525));
            },
          ),
        ),
      ),
    );
  }
}
