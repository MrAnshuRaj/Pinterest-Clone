import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../create/data/models/created_collage_model.dart';
import '../../create/data/models/created_pin_model.dart';
import '../../home/data/models/pin_model.dart';
import '../../profile/application/profile_providers.dart';
import '../data/models/board_model.dart';
import 'local_saved_store.dart';

const savedPinsTabIndex = 0;
const savedBoardsTabIndex = 1;
const savedCollagesTabIndex = 2;

int? savedTabIndexFromQuery(String? tab) {
  switch (tab?.trim().toLowerCase()) {
    case 'pins':
      return savedPinsTabIndex;
    case 'boards':
      return savedBoardsTabIndex;
    case 'collages':
      return savedCollagesTabIndex;
  }
  return null;
}

SavedTab savedTabFromIndex(int index) {
  switch (index) {
    case savedBoardsTabIndex:
      return SavedTab.boards;
    case savedCollagesTabIndex:
      return SavedTab.collages;
    case savedPinsTabIndex:
    default:
      return SavedTab.pins;
  }
}

int savedTabToIndex(SavedTab tab) {
  switch (tab) {
    case SavedTab.pins:
      return savedPinsTabIndex;
    case SavedTab.boards:
      return savedBoardsTabIndex;
    case SavedTab.collages:
      return savedCollagesTabIndex;
  }
}

final localSavedStoreProvider =
    StateNotifierProvider<LocalSavedStore, LocalSavedState>((ref) {
      return LocalSavedStore();
    });

final savedTabProvider = Provider<int>((ref) {
  final tab = ref.watch(
    localSavedStoreProvider.select((state) => state.selectedTab),
  );
  return savedTabToIndex(tab);
});

final savedPinsProvider = Provider<List<PinModel>>((ref) {
  return ref.watch(localSavedStoreProvider.select((state) => state.savedPins));
});

final savedPinsListProvider = savedPinsProvider;

final savedPinIdsProvider = Provider<Set<String>>((ref) {
  final pins = ref.watch(savedPinsProvider);
  return pins.map((pin) => pin.id).toSet();
});

final createdPinsProvider = Provider<List<CreatedPinModel>>((ref) {
  return ref.watch(
    localSavedStoreProvider.select((state) => state.createdPins),
  );
});

final createdPinsListProvider = createdPinsProvider;

final boardsProvider = Provider<List<BoardModel>>((ref) {
  return ref.watch(localSavedStoreProvider.select((state) => state.boards));
});

final boardsListProvider = boardsProvider;

final collagesProvider = Provider<List<CreatedCollageModel>>((ref) {
  return ref.watch(localSavedStoreProvider.select((state) => state.collages));
});

final collagesListProvider = collagesProvider;

final selectedBoardPinsProvider = Provider.family<List<PinModel>, String>((
  ref,
  boardId,
) {
  final boards = ref.watch(boardsListProvider);
  final savedPins = ref.watch(savedPinsListProvider);
  final createdPins = ref.watch(createdPinsListProvider);
  final createdPinMap = {for (final pin in createdPins) pin.id: pin};

  BoardModel? board;
  for (final item in boards) {
    if (item.id == boardId) {
      board = item;
      break;
    }
  }
  if (board == null) return const [];

  final savedPinMap = {for (final pin in savedPins) pin.id: pin};
  final author = ref.watch(resolvedUserProfileProvider).name;

  return board.pinIds
      .map((pinId) {
        final saved = savedPinMap[pinId];
        if (saved != null) return saved;
        final created = createdPinMap[pinId];
        if (created != null) return created.toPinModel(author: author);
        return null;
      })
      .whereType<PinModel>()
      .toList(growable: false);
});
