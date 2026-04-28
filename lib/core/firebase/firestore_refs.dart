import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRefs {
  const FirestoreRefs(this.firestore);

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get users =>
      firestore.collection('users');

  DocumentReference<Map<String, dynamic>> userDoc(String userId) =>
      users.doc(userId);

  DocumentReference<Map<String, dynamic>> settingsDoc(String userId) =>
      userDoc(userId).collection('settings').doc('app');

  CollectionReference<Map<String, dynamic>> boards(String userId) =>
      userDoc(userId).collection('boards');

  DocumentReference<Map<String, dynamic>> boardDoc(
    String userId,
    String boardId,
  ) => boards(userId).doc(boardId);

  CollectionReference<Map<String, dynamic>> savedPins(String userId) =>
      userDoc(userId).collection('savedPins');

  DocumentReference<Map<String, dynamic>> savedPinDoc(
    String userId,
    String pinId,
  ) => savedPins(userId).doc(pinId);

  CollectionReference<Map<String, dynamic>> createdPins(String userId) =>
      userDoc(userId).collection('createdPins');

  DocumentReference<Map<String, dynamic>> createdPinDoc(
    String userId,
    String pinId,
  ) => createdPins(userId).doc(pinId);

  CollectionReference<Map<String, dynamic>> collages(String userId) =>
      userDoc(userId).collection('collages');

  DocumentReference<Map<String, dynamic>> collageDoc(
    String userId,
    String collageId,
  ) => collages(userId).doc(collageId);

  CollectionReference<Map<String, dynamic>> inboxUpdates(String userId) =>
      userDoc(userId).collection('inboxUpdates');

  DocumentReference<Map<String, dynamic>> inboxUpdateDoc(
    String userId,
    String updateId,
  ) => inboxUpdates(userId).doc(updateId);
}
