import 'package:flutter/foundation.dart';

import '../../../../core/firebase/firestore_utils.dart';
import '../../../home/data/models/pin_model.dart';
import '../local/saved_content_local_store.dart';

class SavedPinsRepository {
  SavedPinsRepository(this._localStore);

  static const _collection = 'savedPins';
  final SavedContentLocalStore _localStore;

  Stream<List<PinModel>> watchSavedPins(String userId) {
    return _localStore
        .watchCollection(userId, _collection)
        .handleError((error, stackTrace) {
          debugPrint(
            '[saved] savedPins stream error userId=$userId error=$error',
          );
        })
        .map((snapshot) {
          final docs = snapshot.toList(growable: false)
            ..sort((a, b) {
              final aSavedAt = parseFirestoreDate(a['savedAt']);
              final bSavedAt = parseFirestoreDate(b['savedAt']);
              return bSavedAt.compareTo(aSavedAt);
            });
          final pins = docs
              .map((doc) => PinModel.fromMap(doc))
              .toList(growable: false);
          debugPrint(
            '[saved] watch local path=$_collection/$userId count=${pins.length}',
          );
          return pins;
        });
  }

  Future<bool> isPinSaved(String userId, String pinId) async {
    final pins = await _localStore.readCollection(userId, _collection);
    return pins.any((pin) => (pin['pinId'] as String? ?? '') == pinId);
  }

  Future<void> savePin(String userId, PinModel pin) async {
    final data = {
      'pinId': pin.id,
      'title': pin.title,
      'imageUrl': pin.imageUrl,
      'author': pin.author,
      'category': pin.category,
      'description': pin.description,
      'likes': pin.likes,
      'comments': pin.comments,
      'isAiModified': pin.isAiModified,
      'heightRatio': pin.heightRatio,
      'avatarUrl': pin.avatarUrl,
      'savedAt': DateTime.now().toIso8601String(),
    };
    debugPrint(
      '[saved] write savedPin userId=$userId local=$_collection/${pin.id} data=$data',
    );
    await _localStore.updateCollection(userId, _collection, (current) {
      final next = current
          .where((item) => (item['pinId'] as String? ?? '') != pin.id)
          .toList(growable: true);
      next.insert(0, data);
      return next;
    });
  }

  Future<void> unsavePin(String userId, String pinId) async {
    debugPrint(
      '[saved] delete savedPin userId=$userId local=$_collection/$pinId',
    );
    await _localStore.updateCollection(userId, _collection, (current) {
      return current
          .where((item) => (item['pinId'] as String? ?? '') != pinId)
          .toList(growable: false);
    });
  }
}
