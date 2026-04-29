import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedContentLocalStore {
  Future<SharedPreferences>? _preferences;
  final Map<String, StreamController<List<Map<String, dynamic>>>> _controllers =
      {};

  Stream<List<Map<String, dynamic>>> watchCollection(
    String userId,
    String collection,
  ) async* {
    yield await readCollection(userId, collection);
    yield* _controllerFor(userId, collection).stream;
  }

  Future<List<Map<String, dynamic>>> readCollection(
    String userId,
    String collection,
  ) async {
    final prefs = await _prefs;
    final raw = prefs.getString(_storageKey(userId, collection));
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const [];
      }
      return decoded
          .whereType<Map>()
          .map(
            (item) => item.map((key, value) => MapEntry(key.toString(), value)),
          )
          .toList(growable: false);
    } catch (error, stackTrace) {
      debugPrint(
        '[local-store] failed to decode $collection for $userId error=$error',
      );
      debugPrintStack(stackTrace: stackTrace);
      return const [];
    }
  }

  Future<void> writeCollection(
    String userId,
    String collection,
    List<Map<String, dynamic>> items,
  ) async {
    final normalized = items.map(_normalizeMap).toList(growable: false);
    final prefs = await _prefs;
    await prefs.setString(
      _storageKey(userId, collection),
      jsonEncode(normalized),
    );
    _controllerFor(userId, collection).add(normalized);
  }

  Future<void> updateCollection(
    String userId,
    String collection,
    List<Map<String, dynamic>> Function(List<Map<String, dynamic>> current)
    updater,
  ) async {
    final current = await readCollection(userId, collection);
    final next = updater(current);
    await writeCollection(userId, collection, next);
  }

  StreamController<List<Map<String, dynamic>>> _controllerFor(
    String userId,
    String collection,
  ) {
    final key = _storageKey(userId, collection);
    return _controllers.putIfAbsent(
      key,
      () => StreamController<List<Map<String, dynamic>>>.broadcast(),
    );
  }

  Future<SharedPreferences> get _prefs =>
      _preferences ??= SharedPreferences.getInstance();

  String _storageKey(String userId, String collection) =>
      'saved-content/$userId/$collection';

  Map<String, dynamic> _normalizeMap(Map<String, dynamic> value) {
    return value.map((key, item) => MapEntry(key, _normalizeValue(item)));
  }

  dynamic _normalizeValue(dynamic value) {
    if (value == null || value is num || value is String || value is bool) {
      return value;
    }
    if (value is DateTime) {
      return value.toIso8601String();
    }
    if (value is Iterable) {
      return value.map(_normalizeValue).toList(growable: false);
    }
    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(key.toString(), _normalizeValue(item)),
      );
    }

    final timestampDate = _maybeTimestampToDate(value);
    if (timestampDate != null) {
      return timestampDate.toIso8601String();
    }

    return value.toString();
  }

  DateTime? _maybeTimestampToDate(dynamic value) {
    try {
      final maybeDate = value.toDate();
      if (maybeDate is DateTime) {
        return maybeDate;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
