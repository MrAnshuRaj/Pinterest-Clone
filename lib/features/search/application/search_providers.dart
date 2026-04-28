import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/data/repositories/pin_repository.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/application/settings_providers.dart';
import '../../saved/application/saved_providers.dart';

final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryController, List<String>>(
      (ref) => SearchHistoryController(),
    );

final searchSuggestionsProvider = Provider.family<List<String>, String>(
  (ref, rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    final history = ref.watch(searchHistoryProvider);
    final settings = ref.watch(pinterestSettingsProvider);
    final profile = ref.watch(profileProvider);
    final boards = ref.watch(boardsListProvider);
    final savedPins = ref.watch(savedPinsListProvider);
    final createdPins = ref.watch(createdPinsListProvider);
    final popularSections = ref.watch(pinRepositoryProvider).getPopularSections();

    final candidatePool = <String>[
      ...history,
      ...settings.selectedInterests,
      ...profile.selectedInterests,
      ...boards.map((board) => board.name),
      ...savedPins.expand((pin) => [
        pin.title,
        pin.category,
        '${pin.category} ideas',
      ]),
      ...createdPins.expand((pin) => [pin.title, ...pin.topics]),
      ...popularSections.expand((section) => [section.title, section.query]),
    ];

    final rankedCandidates = _uniqueNormalized(
      candidatePool.where((item) => item.trim().isNotEmpty),
    );

    if (query.isEmpty) {
      return rankedCandidates.take(10).toList(growable: false);
    }

    final matching = rankedCandidates.where((item) {
      final lower = item.toLowerCase();
      return lower.contains(query);
    }).toList(growable: true);

    final generated = _uniqueNormalized([
      query,
      '$query ideas',
      '$query inspiration',
      '$query aesthetic',
      '$query wallpaper',
      '$query outfit',
      '$query checklist',
      '$query board',
    ]);

    for (final item in generated) {
      if (!matching.any(
        (existing) => existing.toLowerCase() == item.toLowerCase(),
      )) {
        matching.add(item);
      }
    }

    return matching.take(10).toList(growable: false);
  },
  dependencies: [
    searchHistoryProvider,
    pinterestSettingsProvider,
    profileProvider,
    boardsListProvider,
    savedPinsListProvider,
    createdPinsListProvider,
  ],
);

class SearchHistoryController extends StateNotifier<List<String>> {
  SearchHistoryController()
    : super(const [
        'tattoo ideas',
        'home decor',
        'wallpapers',
        'outfit ideas',
        'recipes',
      ]);

  void record(String query) {
    final normalized = query.trim();
    if (normalized.isEmpty) return;

    final next = [
      normalized,
      ...state.where(
        (item) => item.toLowerCase() != normalized.toLowerCase(),
      ),
    ];
    state = next.take(10).toList(growable: false);
  }
}

List<String> _uniqueNormalized(Iterable<String> items) {
  final seen = <String>{};
  final results = <String>[];

  for (final item in items) {
    final trimmed = item.trim();
    if (trimmed.isEmpty) continue;
    final key = trimmed.toLowerCase();
    if (seen.add(key)) {
      results.add(trimmed);
    }
  }

  return results;
}
