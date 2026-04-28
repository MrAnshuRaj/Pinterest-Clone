import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/data/models/pin_model.dart';
import '../../home/data/repositories/pin_repository.dart';
import '../data/models/board_model.dart';

final savedTabProvider = StateProvider<int>((ref) => 0);

final boardsProvider = StateNotifierProvider<BoardsNotifier, List<BoardModel>>(
  (ref) => BoardsNotifier(),
);

final selectedBoardPinsProvider = Provider.family<List<PinModel>, String>((
  ref,
  boardId,
) {
  BoardModel? found;
  for (final item in ref.watch(boardsProvider)) {
    if (item.id == boardId) {
      found = item;
      break;
    }
  }
  final board = found;
  if (board == null) return const [];

  final pins = ref.watch(pinRepositoryProvider).getMockPinsSync();
  final createdPins = ref.watch(createdPinsProvider);
  final allPins = [...createdPins, ...pins];
  return allPins.where((pin) => board.pinIds.contains(pin.id)).toList();
});

class BoardsNotifier extends StateNotifier<List<BoardModel>> {
  BoardsNotifier()
    : super([
        BoardModel(
          id: 'travel',
          name: 'Travel',
          coverImageUrls: const [
            'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?auto=format&fit=crop&w=700&q=85',
            'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=700&q=85',
            'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?auto=format&fit=crop&w=700&q=85',
          ],
          pinIds: const [
            'travel-venice',
            'travel-road',
            'travel-island',
            'travel-plane-window',
          ],
          isSecret: false,
          isGroupBoard: false,
          createdAt: DateTime(2026, 4, 26),
        ),
      ]);

  BoardModel create({
    required String name,
    required bool isSecret,
    bool isGroupBoard = false,
  }) {
    final board = BoardModel(
      id: 'board-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      coverImageUrls: const [],
      pinIds: const [],
      isSecret: isSecret,
      isGroupBoard: isGroupBoard,
      createdAt: DateTime.now(),
    );
    state = [board, ...state];
    return board;
  }

  void addPins({required String boardId, required List<PinModel> pins}) {
    state = [
      for (final board in state)
        if (board.id == boardId)
          board.copyWith(
            pinIds: {...board.pinIds, ...pins.map((pin) => pin.id)}.toList(),
            coverImageUrls: [
              ...pins.map((pin) => pin.imageUrl),
              ...board.coverImageUrls,
            ].take(4).toList(),
          )
        else
          board,
    ];
  }
}
