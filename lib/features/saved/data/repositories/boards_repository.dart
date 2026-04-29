import 'package:flutter/foundation.dart';

import '../../../home/data/models/pin_model.dart';
import '../models/board_model.dart';
import '../local/saved_content_local_store.dart';

class BoardsRepository {
  BoardsRepository(this._localStore);

  static const _collection = 'boards';
  final SavedContentLocalStore _localStore;

  Stream<List<BoardModel>> watchBoards(String userId) {
    return _localStore
        .watchCollection(userId, _collection)
        .handleError((error, stackTrace) {
          debugPrint('[saved] boards stream error userId=$userId error=$error');
        })
        .map((snapshot) {
          final boards =
              snapshot
                  .map(
                    (doc) =>
                        BoardModel.fromMap(doc, id: doc['id'] as String? ?? ''),
                  )
                  .toList(growable: false)
                ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          debugPrint(
            '[saved] watch local path=$_collection/$userId count=${boards.length}',
          );
          return boards;
        });
  }

  Future<String> createBoard(String userId, BoardModel board) async {
    final boardId = board.id.isEmpty ? _nextId('board') : board.id;
    final now = DateTime.now();
    final payload = board
        .copyWith(id: boardId, createdAt: board.createdAt, updatedAt: now)
        .toMap();
    debugPrint(
      '[saved] write board userId=$userId local=$_collection/$boardId data=$payload',
    );
    await _localStore.updateCollection(userId, _collection, (current) {
      final next = current
          .where((item) => (item['id'] as String? ?? '') != boardId)
          .toList(growable: true);
      next.insert(0, _boardStorageMap(payload));
      return next;
    });
    return boardId;
  }

  Future<void> addPinsToBoard(
    String userId,
    String boardId,
    List<PinModel> pins,
  ) async {
    await _localStore.updateCollection(userId, _collection, (current) {
      final next = current.toList(growable: true);
      final index = next.indexWhere(
        (item) => (item['id'] as String? ?? '') == boardId,
      );
      if (index == -1) {
        debugPrint(
          '[saved] update board skipped because local=$_collection/$boardId does not exist',
        );
        throw StateError('Board "$boardId" does not exist.');
      }

      final board = BoardModel.fromMap(next[index], id: boardId);
      final nextPinIds = {
        ...board.pinIds,
        ...pins.map((pin) => pin.id),
      }.toList(growable: false);
      final nextCoverUrls = {
        ...pins.map((pin) => pin.imageUrl),
        ...board.coverImageUrls,
      }.take(4).toList(growable: false);
      debugPrint(
        '[saved] update board userId=$userId local=$_collection/$boardId pinCount=${nextPinIds.length} coverCount=${nextCoverUrls.length}',
      );

      next[index] = _boardStorageMap(
        board
            .copyWith(
              pinIds: nextPinIds,
              coverImageUrls: nextCoverUrls,
              updatedAt: DateTime.now(),
            )
            .toMap(),
      );
      return next;
    });
  }

  Future<void> updateBoard(
    String userId,
    String boardId,
    Map<String, dynamic> data,
  ) async {
    debugPrint(
      '[saved] merge board userId=$userId local=$_collection/$boardId data=$data',
    );
    await _localStore.updateCollection(userId, _collection, (current) {
      final next = current.toList(growable: true);
      final index = next.indexWhere(
        (item) => (item['id'] as String? ?? '') == boardId,
      );
      if (index == -1) {
        throw StateError('Board "$boardId" does not exist.');
      }

      next[index] = _boardStorageMap({
        ...next[index],
        ...data,
        'id': boardId,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return next;
    });
  }

  Future<void> deleteBoard(String userId, String boardId) async {
    await _localStore.updateCollection(userId, _collection, (current) {
      return current
          .where((item) => (item['id'] as String? ?? '') != boardId)
          .toList(growable: false);
    });
  }

  Map<String, dynamic> _boardStorageMap(Map<String, dynamic> value) {
    return {
      ...value,
      'createdAt': value['createdAt'] is String
          ? value['createdAt']
          : (value['createdAt'] as DateTime?)?.toIso8601String(),
      'updatedAt': value['updatedAt'] is String
          ? value['updatedAt']
          : (value['updatedAt'] as DateTime?)?.toIso8601String(),
    };
  }

  String _nextId(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}
