import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../create/data/models/created_collage_model.dart';
import '../../create/data/models/created_pin_model.dart';
import '../../home/data/models/pin_model.dart';
import '../data/models/board_model.dart';

enum SavedTab { pins, boards, collages }

class LocalSavedState {
  const LocalSavedState({
    this.savedPins = const [],
    this.createdPins = const [],
    this.boards = const [],
    this.collages = const [],
    this.selectedTab = SavedTab.pins,
  });

  final List<PinModel> savedPins;
  final List<CreatedPinModel> createdPins;
  final List<BoardModel> boards;
  final List<CreatedCollageModel> collages;
  final SavedTab selectedTab;

  LocalSavedState copyWith({
    List<PinModel>? savedPins,
    List<CreatedPinModel>? createdPins,
    List<BoardModel>? boards,
    List<CreatedCollageModel>? collages,
    SavedTab? selectedTab,
  }) {
    return LocalSavedState(
      savedPins: savedPins ?? this.savedPins,
      createdPins: createdPins ?? this.createdPins,
      boards: boards ?? this.boards,
      collages: collages ?? this.collages,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

class LocalSavedStore extends StateNotifier<LocalSavedState> {
  LocalSavedStore() : super(const LocalSavedState());

  void savePin(PinModel pin) {
    debugPrint('[local] save pin id=${pin.id} title=${pin.title}');
    state = state.copyWith(
      savedPins: _upsertById(state.savedPins, pin, (item) => item.id),
    );
  }

  void unsavePin(String pinId) {
    debugPrint('[local] unsave pin id=$pinId');
    state = state.copyWith(
      savedPins: state.savedPins
          .where((pin) => pin.id != pinId)
          .toList(growable: false),
    );
  }

  bool isPinSaved(String pinId) {
    return state.savedPins.any((pin) => pin.id == pinId);
  }

  void createPin(CreatedPinModel pin) {
    debugPrint('[local] create pin id=${pin.id} title=${pin.title}');
    state = state.copyWith(
      createdPins: _upsertById(state.createdPins, pin, (item) => item.id),
      selectedTab: SavedTab.pins,
    );
  }

  void createBoard(BoardModel board) {
    debugPrint('[local] create board id=${board.id} name=${board.name}');
    state = state.copyWith(
      boards: _upsertById(state.boards, board, (item) => item.id),
      selectedTab: SavedTab.boards,
    );
  }

  void addPinsToBoard(String boardId, List<PinModel> pins) {
    debugPrint('[local] add pins boardId=$boardId count=${pins.length}');
    final boardIndex = state.boards.indexWhere((board) => board.id == boardId);
    if (boardIndex == -1) {
      debugPrint(
        '[local] add pins skipped because boardId=$boardId was not found',
      );
      return;
    }

    final board = state.boards[boardIndex];
    final nextPinIds = {
      ...board.pinIds,
      ...pins.map((pin) => pin.id),
    }.toList(growable: false);
    final nextCoverUrls = {
      ...pins.map((pin) => pin.imageUrl).where((url) => url.trim().isNotEmpty),
      ...board.coverImageUrls.where((url) => url.trim().isNotEmpty),
    }.take(4).toList(growable: false);

    final updatedBoard = board.copyWith(
      pinIds: nextPinIds,
      coverImageUrls: nextCoverUrls,
      updatedAt: DateTime.now(),
    );

    final nextBoards = state.boards.toList(growable: true)
      ..[boardIndex] = updatedBoard;

    var nextSavedPins = state.savedPins;
    for (final pin in pins) {
      nextSavedPins = _upsertById(nextSavedPins, pin, (item) => item.id);
    }

    state = state.copyWith(
      boards: nextBoards,
      savedPins: nextSavedPins,
      selectedTab: SavedTab.boards,
    );
  }

  void createCollage(CreatedCollageModel collage) {
    debugPrint(
      '[local] create collage id=${collage.id} title=${collage.title} draft=false',
    );
    state = state.copyWith(
      collages: _upsertById(
        state.collages,
        collage.copyWith(isDraft: false),
        (item) => item.id,
      ),
      selectedTab: SavedTab.collages,
    );
  }

  void saveCollageDraft(CreatedCollageModel collage) {
    debugPrint(
      '[local] create collage id=${collage.id} title=${collage.title} draft=true',
    );
    state = state.copyWith(
      collages: _upsertById(
        state.collages,
        collage.copyWith(isDraft: true),
        (item) => item.id,
      ),
      selectedTab: SavedTab.collages,
    );
  }

  void setSelectedTab(SavedTab tab) {
    if (state.selectedTab == tab) return;
    state = state.copyWith(selectedTab: tab);
  }

  void clearAll() {
    state = const LocalSavedState();
  }

  List<T> _upsertById<T>(List<T> items, T value, String Function(T item) idOf) {
    final next = items
        .where((item) => idOf(item) != idOf(value))
        .toList(growable: true);
    next.insert(0, value);
    return List.unmodifiable(next);
  }
}
