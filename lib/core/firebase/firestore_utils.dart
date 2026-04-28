import 'package:cloud_firestore/cloud_firestore.dart';

DateTime parseFirestoreDate(dynamic value, {DateTime? fallback}) {
  final resolvedFallback = fallback ?? DateTime.fromMillisecondsSinceEpoch(0);
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is DateTime) {
    return value;
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  if (value is String) {
    return DateTime.tryParse(value) ?? resolvedFallback;
  }
  return resolvedFallback;
}

Timestamp timestampFromDate(DateTime value) => Timestamp.fromDate(value);

List<String> stringListFrom(dynamic value) {
  if (value is Iterable) {
    return value.whereType<String>().toList(growable: false);
  }
  return const [];
}

Map<String, bool> boolMapFrom(dynamic value) {
  if (value is! Map) return const {};

  final result = <String, bool>{};
  value.forEach((key, dynamic rawValue) {
    if (key is! String) return;
    if (rawValue is bool) {
      result[key] = rawValue;
      return;
    }
    if (rawValue is String) {
      result[key] = rawValue.toLowerCase() == 'true';
      return;
    }
    if (rawValue is num) {
      result[key] = rawValue != 0;
    }
  });
  return result;
}

Map<String, dynamic> dynamicMapFrom(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, dynamic item) => MapEntry(key.toString(), item));
  }
  return const {};
}

Map<String, Map<String, bool>> nestedBoolMapFrom(dynamic value) {
  final parent = dynamicMapFrom(value);
  return parent.map((key, nested) => MapEntry(key, boolMapFrom(nested)));
}
