import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PinterestCachedImage extends StatelessWidget {
  const PinterestCachedImage({
    super.key,
    required this.imageUrl,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String imageUrl;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(18);

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 180),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: const Color(0xFF202020),
          highlightColor: const Color(0xFF353535),
          child: Container(color: const Color(0xFF202020)),
        ),
        errorWidget: (context, url, error) => Container(
          color: const Color(0xFF242424),
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      ),
    );
  }
}
