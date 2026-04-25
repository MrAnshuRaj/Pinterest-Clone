import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/pinterest_cached_image.dart';
import '../../../home/data/models/pin_model.dart';

class FeaturedBoardSection extends StatelessWidget {
  const FeaturedBoardSection({super.key, required this.boards});

  final List<FeaturedBoard> boards;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 292,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        itemCount: boards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final board = boards[index];
          return GestureDetector(
            onTap: () => context.go(
              '/search/results/${Uri.encodeComponent(board.title)}',
            ),
            child: SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: PinterestCachedImage(
                              imageUrl: board.imageUrls.first,
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: PinterestCachedImage(
                              imageUrl: board.imageUrls.last,
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    board.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        board.category,
                        style: const TextStyle(
                          color: Color(0xFFD5D5D5),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE60023),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${board.pinsCount} Pins · ${board.ageLabel}',
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
