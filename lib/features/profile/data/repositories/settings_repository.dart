import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firebase/firestore_refs.dart';
import '../models/app_settings_model.dart';

class SettingsRepository {
  SettingsRepository({FirebaseFirestore? firestore})
    : _refs = FirestoreRefs(firestore ?? FirebaseFirestore.instance);

  final FirestoreRefs _refs;

  Stream<AppSettingsModel> watchSettings(String userId) {
    return _refs.settingsDoc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return AppSettingsModel.defaults();
      return AppSettingsModel.fromMap(snapshot.data() ?? const {});
    });
  }

  Future<void> ensureDefaultSettings(String userId) async {
    final doc = _refs.settingsDoc(userId);
    final snapshot = await doc.get();
    if (snapshot.exists) return;
    await doc.set(AppSettingsModel.defaults().toMap());
  }

  Future<void> updateSettings(String userId, Map<String, dynamic> data) {
    return _refs.settingsDoc(userId).set({
      ...data,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));
  }

  Future<void> updateNestedSetting(
    String userId,
    String fieldPath,
    dynamic value,
  ) {
    return updateSettings(userId, {fieldPath: value});
  }
}
