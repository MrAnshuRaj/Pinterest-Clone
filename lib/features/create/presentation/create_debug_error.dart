import 'package:cloud_firestore/cloud_firestore.dart';

String formatCreateDebugError(
  Object error, {
  required String operation,
  String? path,
}) {
  final lines = <String>['$operation failed.'];

  if (path != null && path.trim().isNotEmpty) {
    lines.add('Path: $path');
  }

  if (error is FirebaseException) {
    final reason = switch (error.code) {
      'permission-denied' => 'Missing or insufficient Firestore permissions.',
      'unavailable' => 'Firestore is unavailable or your network is offline.',
      'failed-precondition' => 'A Firestore precondition failed.',
      'invalid-argument' => 'Firestore rejected the request data.',
      _ =>
        error.message?.trim().isNotEmpty == true
            ? error.message!.trim()
            : 'Firestore error code: ${error.code}',
    };
    lines.add('Firestore: ${error.code}');
    lines.add('Reason: $reason');
    return lines.join('\n');
  }

  if (error is StateError) {
    lines.add('Reason: ${error.message}');
    return lines.join('\n');
  }

  if (error is RangeError) {
    lines.add('Reason: Missing required list data or invalid index access.');
    lines.add('Details: $error');
    return lines.join('\n');
  }

  lines.add('Error: ${error.runtimeType}');
  lines.add('Details: $error');
  return lines.join('\n');
}
