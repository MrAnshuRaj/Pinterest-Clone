import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/models/inbox_update_model.dart';
import '../data/repositories/inbox_repository.dart';

final inboxRepositoryProvider = Provider<InboxRepository>((ref) {
  return InboxRepository();
});

final inboxUpdatesProvider = StreamProvider<List<InboxUpdateModel>>(
  (ref) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return Stream.value(const []);
    final repository = ref.watch(inboxRepositoryProvider);
    unawaited(repository.seedDefaultUpdatesIfEmpty(userId));
    return repository.watchUpdates(userId);
  },
  dependencies: [currentUserIdProvider],
);

final inboxControllerProvider = Provider<InboxController>((ref) {
  return InboxController(ref);
});

class InboxController {
  InboxController(this._ref);

  final Ref _ref;

  String? get _userId => _ref.read(currentUserIdProvider);

  Future<void> markRead(String updateId) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref.read(inboxRepositoryProvider).markRead(userId, updateId);
  }

  Future<void> hideUpdate(String updateId) async {
    final userId = _userId;
    if (userId == null) return;
    await _ref.read(inboxRepositoryProvider).hideUpdate(userId, updateId);
  }
}
