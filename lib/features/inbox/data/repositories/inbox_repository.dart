import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firebase/firestore_refs.dart';
import '../models/inbox_update_model.dart';

class InboxRepository {
  InboxRepository({FirebaseFirestore? firestore})
    : _refs = FirestoreRefs(firestore ?? FirebaseFirestore.instance);

  final FirestoreRefs _refs;

  Stream<List<InboxUpdateModel>> watchUpdates(String userId) async* {
    try {
      await for (final snapshot in _refs
          .inboxUpdates(userId)
          .orderBy('createdAt', descending: true)
          .snapshots()) {
        yield snapshot.docs
            .map((doc) => InboxUpdateModel.fromMap(doc.data(), id: doc.id))
            .where((item) => !item.hidden)
            .toList(growable: false);
      }
    } catch (_) {
      yield const [];
    }
  }

  Future<void> seedDefaultUpdatesIfEmpty(String userId) async {
    try {
      final collection = _refs.inboxUpdates(userId);
      final snapshot = await collection.limit(1).get();
      if (snapshot.docs.isNotEmpty) return;

      final batch = collection.firestore.batch();
      final now = DateTime.now();
      final updates = [
        InboxUpdateModel(
          id: 'welcome',
          title: 'A beautiful life is your calling',
          subtitle: 'Fresh ideas picked for your boards',
          imageUrl: null,
          type: 'image',
          createdAt: now.subtract(const Duration(hours: 5)),
          read: false,
          hidden: false,
        ),
        InboxUpdateModel(
          id: 'discover',
          title: 'Discover ideas inspired by what you save',
          subtitle: 'Open Search to explore more',
          imageUrl: null,
          type: 'search',
          createdAt: now.subtract(const Duration(days: 1)),
          read: false,
          hidden: false,
        ),
      ];

      for (final update in updates) {
        batch.set(_refs.inboxUpdateDoc(userId, update.id), update.toMap());
      }

      await batch.commit();
    } catch (_) {
      // Inbox should still render its empty state even when Firestore access
      // is unavailable in the current demo setup.
    }
  }

  Future<void> markRead(String userId, String updateId) {
    return _refs.inboxUpdateDoc(userId, updateId).set({
      'read': true,
    }, SetOptions(merge: true));
  }

  Future<void> hideUpdate(String userId, String updateId) {
    return _refs.inboxUpdateDoc(userId, updateId).set({
      'hidden': true,
      'read': true,
    }, SetOptions(merge: true));
  }
}
