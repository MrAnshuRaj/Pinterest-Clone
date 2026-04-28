import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firebase/firestore_refs.dart';
import '../models/created_collage_model.dart';
import '../models/created_pin_model.dart';

class CreatedContentRepository {
  CreatedContentRepository({FirebaseFirestore? firestore})
    : _refs = FirestoreRefs(firestore ?? FirebaseFirestore.instance);

  final FirestoreRefs _refs;

  Stream<List<CreatedPinModel>> watchCreatedPins(String userId) {
    return _refs
        .createdPins(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CreatedPinModel.fromMap(doc.data(), id: doc.id))
              .toList(growable: false),
        );
  }

  Future<void> createPin(String userId, CreatedPinModel pin) {
    return _refs.createdPinDoc(userId, pin.id).set(pin.toMap());
  }

  Stream<List<CreatedCollageModel>> watchCollages(String userId) {
    return _refs
        .collages(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CreatedCollageModel.fromMap(doc.data(), id: doc.id))
              .toList(growable: false),
        );
  }

  Future<void> createCollage(String userId, CreatedCollageModel collage) {
    return _refs
        .collageDoc(userId, collage.id)
        .set(collage.copyWith(isDraft: false).toMap());
  }

  Future<void> saveCollageDraft(String userId, CreatedCollageModel collage) {
    return _refs
        .collageDoc(userId, collage.id)
        .set(collage.copyWith(isDraft: true).toMap());
  }
}
