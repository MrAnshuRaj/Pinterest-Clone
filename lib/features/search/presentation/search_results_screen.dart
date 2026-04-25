import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../home/data/repositories/pin_repository.dart';
import '../../home/presentation/widgets/pin_card.dart';
import 'widgets/search_filter_chip_row.dart';

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key, required this.query});

  final String query;

  Future<void> _openFilter(BuildContext context, WidgetRef ref) async {
    final selected = await context.push<String>(
      '/search/filter',
      extra: ref.read(searchFilterProvider),
    );
    if (selected != null) {
      ref.read(searchFilterProvider.notifier).state = selected;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decodedQuery = Uri.decodeComponent(query);
    final pins = ref.watch(searchResultsProvider(decodedQuery));
    final filter = ref.watch(searchFilterProvider);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 12, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/search'),
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        context.push('/search/type', extra: decodedQuery),
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white, width: 1.1),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        decodedQuery,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => _openFilter(context, ref),
                  icon: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ],
            ),
          ),
          const SearchFilterChipRow(),
          if (filter != 'All Pins')
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  filter,
                  style: const TextStyle(
                    color: Color(0xFF9B9B9B),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Expanded(
            child: pins.when(
              data: (items) => MasonryGridView.count(
                padding: const EdgeInsets.fromLTRB(6, 10, 6, 16),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 6,
                itemCount: items.length,
                itemBuilder: (context, index) => PinCard(pin: items[index]),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFE60023)),
              ),
              error: (error, stackTrace) => const Center(
                child: Text(
                  'Could not load results',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
