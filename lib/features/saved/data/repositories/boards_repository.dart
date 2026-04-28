import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firebase/firestore_refs.dart';
import '../../../home/data/models/pin_model.dart';
import '../models/board_model.dart';

class BoardsRepository {
  BoardsRepository({FirebaseFirestore? firestore})
    : _refs = FirestoreRefs(firestore ?? FirebaseFirestore.instance);

  final FirestoreRefs _refs;

  Stream<List<BoardModel>> watchBoards(String userId) {
    return _refs
        .boards(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BoardModel.fromMap(doc.data(), id: doc.id))
              .toList(growable: false),
        );
  }

  Future<String> createBoard(String userId, BoardModel board) async {
    final doc = board.id.isEmpty
        ? _refs.boards(userId).doc()
        : _refs.boardDoc(userId, board.id);
    final now = DateTime.now();
    await doc.set(
      board
          .copyWith(id: doc.id, createdAt: board.createdAt, updatedAt: now)
          .toMap(),
    );
    return doc.id;
  }

  Future<void> addPinsToBoard(
    String userId,
    String boardId,
    List<PinModel> pins,
  ) async {
    final doc = _refs.boardDoc(userId, boardId);
    await _refs.boards(userId).firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc);
      if (!snapshot.exists) return;

      final board = BoardModel.fromMap(
        snapshot.data() ?? {},
        id: boardId,
      );
      final nextPinIds = {
        ...board.pinIds,
        ...pins.map((pin) => pin.id),
      }.toList();
      final nextCoverUrls = {
        ...pins.map((pin) => pin.imageUrl),
        ...board.coverImageUrls,
      }.take(4).toList();

      transaction.update(doc, {
        'pinIds': nextPinIds,
        'coverImageUrls': nextCoverUrls,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    });
  }

  Future<void> updateBoard(
    String userId,
    String boardId,
    Map<String, dynamic> data,
  ) {
    return _refs.boardDoc(userId, boardId).set({
      ...data,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));
  }

  Future<void> deleteBoard(String userId, String boardId) {
    return _refs.boardDoc(userId, boardId).delete();
  }
}
