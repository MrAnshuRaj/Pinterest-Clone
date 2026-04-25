import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/pinterest_cached_image.dart';
import '../../home/data/repositories/pin_repository.dart';
import 'widgets/featured_board_section.dart';
import 'widgets/search_bar_widget.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(featuredBoardsProvider);
    final sections = ref.watch(pinRepositoryProvider).getPopularSections();

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 520,
                  width: double.infinity,
                  child: PinterestCachedImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=1100&q=85',
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(2),
                    ),
                  ),
                ),
                Container(
                  height: 520,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.08),
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 6,
                  right: 6,
                  top: 14,
                  child: SearchBarWidget(
                    onTap: () => context.push('/search/type'),
                  ),
                ),
                const Positioned.fill(
                  top: 90,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'On the menu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Vegetarian recipes to make on repeat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      7,
                      (index) => Container(
                        width: index == 0 ? 8 : 7,
                        height: index == 0 ? 8 : 7,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: index == 0
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.42),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Explore featured boards',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Ideas you might like',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            boards.when(
              data: (items) => FeaturedBoardSection(boards: items),
              loading: () => const SizedBox(height: 292),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 26),
            for (final section in sections) ...[
              _PopularStrip(section: section),
              const SizedBox(height: 36),
            ],
          ],
        ),
      ),
    );
  }
}

class _PopularStrip extends StatelessWidget {
  const _PopularStrip({required this.section});

  final PopularSection section;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.go('/search/results/${Uri.encodeComponent(section.query)}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Popular on Pinterest',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          section.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C4E49),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.search_rounded, size: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 256,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Row(
                  children: [
                    for (final image in section.images)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: PinterestCachedImage(
                            imageUrl: image,
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
