import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firebase/firestore_refs.dart';
import '../../../home/data/models/pin_model.dart';

class SavedPinsRepository {
  SavedPinsRepository({FirebaseFirestore? firestore})
    : _refs = FirestoreRefs(firestore ?? FirebaseFirestore.instance);

  final FirestoreRefs _refs;

  Stream<List<PinModel>> watchSavedPins(String userId) {
    return _refs
        .savedPins(userId)
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PinModel.fromMap(doc.data(), id: doc.id))
              .toList(growable: false),
        );
  }

  Future<bool> isPinSaved(String userId, String pinId) async {
    final snapshot = await _refs.savedPinDoc(userId, pinId).get();
    return snapshot.exists;
  }

  Future<void> savePin(String userId, PinModel pin) {
    return _refs.savedPinDoc(userId, pin.id).set({
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
      'savedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> unsavePin(String userId, String pinId) {
    return _refs.savedPinDoc(userId, pinId).delete();
  }
}
