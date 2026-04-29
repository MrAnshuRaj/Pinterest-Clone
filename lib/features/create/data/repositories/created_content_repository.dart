import 'package:flutter/foundation.dart';

import '../models/created_collage_model.dart';
import '../models/created_pin_model.dart';
import '../../../saved/data/local/saved_content_local_store.dart';

class CreatedContentRepository {
  CreatedContentRepository(this._localStore);

  static const _createdPinsCollection = 'createdPins';
  static const _collagesCollection = 'collages';
  final SavedContentLocalStore _localStore;

  Stream<List<CreatedPinModel>> watchCreatedPins(String userId) {
    return _localStore
        .watchCollection(userId, _createdPinsCollection)
        .handleError((error, stackTrace) {
          debugPrint(
            '[created] createdPins stream error userId=$userId error=$error',
          );
        })
        .map((snapshot) {
          final pins =
              snapshot
                  .map(
                    (doc) => CreatedPinModel.fromMap(
                      doc,
                      id: doc['id'] as String? ?? '',
                    ),
                  )
                  .toList(growable: false)
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          debugPrint(
            '[created] watch local path=$_createdPinsCollection/$userId count=${pins.length}',
          );
          return pins;
        });
  }

  Future<void> createPin(String userId, CreatedPinModel pin) async {
    final pinId = pin.id.isEmpty ? _nextId('created-pin') : pin.id;
    final payload = pin.id.isEmpty ? pin.copyWith(id: pinId) : pin;
    final data = _createdPinStorageMap(payload);
    debugPrint(
      '[created] write pin userId=$userId local=$_createdPinsCollection/$pinId data=$data',
    );
    await _upsertById(userId, _createdPinsCollection, pinId, data);
  }

  Stream<List<CreatedCollageModel>> watchCollages(String userId) {
    return _localStore
        .watchCollection(userId, _collagesCollection)
        .handleError((error, stackTrace) {
          debugPrint(
            '[created] collages stream error userId=$userId error=$error',
          );
        })
        .map((snapshot) {
          final collages =
              snapshot
                  .map(
                    (doc) => CreatedCollageModel.fromMap(
                      doc,
                      id: doc['id'] as String? ?? '',
                    ),
                  )
                  .toList(growable: false)
                ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          debugPrint(
            '[created] watch local path=$_collagesCollection/$userId count=${collages.length}',
          );
          return collages;
        });
  }

  Future<void> createCollage(String userId, CreatedCollageModel collage) async {
    final collageId = collage.id.isEmpty ? _nextId('collage') : collage.id;
    final payload =
        (collage.id.isEmpty ? collage.copyWith(id: collageId) : collage)
            .copyWith(isDraft: false);
    final data = _createdCollageStorageMap(payload);
    debugPrint(
      '[created] write collage userId=$userId local=$_collagesCollection/$collageId data=$data',
    );
    await _upsertById(userId, _collagesCollection, collageId, data);
  }

  Future<void> saveCollageDraft(
    String userId,
    CreatedCollageModel collage,
  ) async {
    final collageId = collage.id.isEmpty ? _nextId('collage') : collage.id;
    final payload =
        (collage.id.isEmpty ? collage.copyWith(id: collageId) : collage)
            .copyWith(isDraft: true);
    final data = _createdCollageStorageMap(payload);
    debugPrint(
      '[created] write collage draft userId=$userId local=$_collagesCollection/$collageId data=$data',
    );
    await _upsertById(userId, _collagesCollection, collageId, data);
  }

  Future<void> _upsertById(
    String userId,
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    await _localStore.updateCollection(userId, collection, (current) {
      final next = current
          .where((item) => (item['id'] as String? ?? '') != id)
          .toList(growable: true);
      next.insert(0, data);
      return next;
    });
  }

  Map<String, dynamic> _createdPinStorageMap(CreatedPinModel pin) {
    return {
      ...pin.toMap(),
      'createdAt': pin.createdAt.toIso8601String(),
      'updatedAt': pin.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _createdCollageStorageMap(CreatedCollageModel collage) {
    return {
      ...collage.toMap(),
      'createdAt': collage.createdAt.toIso8601String(),
      'updatedAt': collage.updatedAt.toIso8601String(),
    };
  }

  String _nextId(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}
