import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../../create/data/models/created_collage_model.dart';
import '../../create/data/models/created_pin_model.dart';
import '../../create/data/repositories/created_content_repository.dart';
import '../../home/data/models/pin_model.dart';
import '../../profile/application/profile_providers.dart';
import '../data/models/board_model.dart';
import '../data/repositories/boards_repository.dart';
import '../data/repositories/saved_pins_repository.dart';

final savedTabProvider = StateProvider<int>((ref) => 0);

final boardsRepositoryProvider = Provider<BoardsRepository>((ref) {
  return BoardsRepository();
});

final savedPinsRepositoryProvider = Provider<SavedPinsRepository>((ref) {
  return SavedPinsRepository();
});

final createdContentRepositoryProvider = Provider<CreatedContentRepository>((
  ref,
) {
  return CreatedContentRepository();
});

final boardsProvider = StreamProvider<List<BoardModel>>(
  (ref) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return Stream.value(const []);
    return ref.watch(boardsRepositoryProvider).watchBoards(userId);
  },
  dependencies: [currentUserIdProvider],
);

final boardsListProvider = Provider<List<BoardModel>>(
  (ref) {
    return ref.watch(boardsProvider).valueOrNull ?? const <BoardModel>[];
  },
  dependencies: [boardsProvider],
);

final savedPinsProvider = StreamProvider<List<PinModel>>(
  (ref) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return Stream.value(const []);
    return ref.watch(savedPinsRepositoryProvider).watchSavedPins(userId);
  },
  dependencies: [currentUserIdProvider],
);

final savedPinsListProvider = Provider<List<PinModel>>(
  (ref) {
    return ref.watch(savedPinsProvider).valueOrNull ?? const <PinModel>[];
  },
  dependencies: [savedPinsProvider],
);

final savedPinIdsProvider = Provider<Set<String>>(
  (ref) {
    final pins = ref.watch(savedPinsProvider).valueOrNull ?? const <PinModel>[];
    return pins.map((pin) => pin.id).toSet();
  },
  dependencies: [savedPinsProvider],
);

final createdPinsProvider = StreamProvider<List<CreatedPinModel>>(
  (ref) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return Stream.value(const []);
    return ref.watch(createdContentRepositoryProvider).watchCreatedPins(userId);
  },
  dependencies: [currentUserIdProvider],
);

final createdPinsListProvider = Provider<List<CreatedPinModel>>(
  (ref) {
    return ref.watch(createdPinsProvider).valueOrNull ??
        const <CreatedPinModel>[];
  },
  dependencies: [createdPinsProvider],
);

final collagesProvider = StreamProvider<List<CreatedCollageModel>>(
  (ref) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return Stream.value(const []);
    return ref.watch(createdContentRepositoryProvider).watchCollages(userId);
  },
  dependencies: [currentUserIdProvider],
);

final collagesListProvider = Provider<List<CreatedCollageModel>>(
  (ref) {
    return ref.watch(collagesProvider).valueOrNull ??
        const <CreatedCollageModel>[];
  },
  dependencies: [collagesProvider],
);

final selectedBoardPinsProvider = Provider.family<List<PinModel>, String>(
  (ref, boardId) {
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
  },
  dependencies: [
    boardsListProvider,
    savedPinsListProvider,
    createdPinsListProvider,
    resolvedUserProfileProvider,
  ],
);

final savedContentControllerProvider = Provider<SavedContentController>((ref) {
  return SavedContentController(ref);
});

class SavedContentController {
  SavedContentController(this._ref);

  final Ref _ref;

  String? get _userId => _ref.read(currentUserIdProvider);

  Future<String?> createBoard(BoardModel board) async {
    final userId = _userId;
    if (userId == null) return null;
    return _ref.read(boardsRepositoryProvider).createBoard(userId, board);
  }

  Future<void> addPinsToBoard(String boardId, List<PinModel> pins) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref
        .read(boardsRepositoryProvider)
        .addPinsToBoard(userId, boardId, pins);
  }

  Future<void> savePin(PinModel pin) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref.read(savedPinsRepositoryProvider).savePin(userId, pin);
  }

  Future<void> unsavePin(String pinId) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref.read(savedPinsRepositoryProvider).unsavePin(userId, pinId);
  }

  Future<void> toggleSavedPin(PinModel pin) async {
    final ids = _ref.read(savedPinIdsProvider);
    if (ids.contains(pin.id)) {
      await unsavePin(pin.id);
      return;
    }
    await savePin(pin);
  }

  Future<void> createPin(CreatedPinModel pin) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref.read(createdContentRepositoryProvider).createPin(userId, pin);
  }

  Future<void> createCollage(CreatedCollageModel collage) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref
        .read(createdContentRepositoryProvider)
        .createCollage(userId, collage);
  }

  Future<void> saveCollageDraft(CreatedCollageModel collage) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref
        .read(createdContentRepositoryProvider)
        .saveCollageDraft(userId, collage);
  }
}
