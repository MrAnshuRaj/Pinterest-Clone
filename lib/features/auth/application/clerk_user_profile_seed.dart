import 'dart:math' as math;

import 'package:clerk_auth/clerk_auth.dart' as clerk;

class ClerkUserProfileSeed {
  const ClerkUserProfileSeed({
    required this.userId,
    required this.email,
    required this.name,
    required this.username,
    required this.avatarInitial,
  });

  final String userId;
  final String email;
  final String name;
  final String username;
  final String avatarInitial;

  String get handle => '@$username';
}

ClerkUserProfileSeed deriveClerkUserProfileSeed(
  clerk.User user, {
  String? preferredName,
  String? preferredEmail,
  String? preferredUsername,
}) {
  final email = (preferredEmail?.trim().isNotEmpty ?? false)
      ? preferredEmail!.trim()
      : (user.email ?? '').trim();
  final name = _deriveName(user, preferredName: preferredName, email: email);
  final username = (preferredUsername?.trim().isNotEmpty ?? false)
      ? normalizeUsername(preferredUsername!, userId: user.id)
      : _deriveUsername(user, email: email, fallbackName: name);

  return ClerkUserProfileSeed(
    userId: user.id,
    email: email,
    name: name,
    username: username,
    avatarInitial: deriveAvatarInitial(name: name, email: email),
  );
}

String deriveAvatarInitial({required String name, required String email}) {
  final seed = name.trim().isNotEmpty ? name.trim() : email.trim();
  if (seed.isEmpty) return 'U';

  for (final rune in seed.runes) {
    final char = String.fromCharCode(rune).trim();
    if (RegExp(r'[A-Za-z0-9]').hasMatch(char)) {
      return char.toUpperCase();
    }
  }

  return 'U';
}

String normalizeUsername(String raw, {String? userId}) {
  final cleaned = raw
      .trim()
      .toLowerCase()
      .replaceAll('@', '')
      .replaceAll(RegExp(r'[^a-z0-9._-]+'), '')
      .replaceAll(RegExp(r'[._-]{2,}'), '_')
      .replaceAll(RegExp(r'^[._-]+|[._-]+$'), '');

  if (cleaned.isNotEmpty) {
    return cleaned.length > 20 ? cleaned.substring(0, 20) : cleaned;
  }

  final suffix = _fallbackUserSuffix(userId);
  return 'user$suffix';
}

String _deriveName(
  clerk.User user, {
  String? preferredName,
  required String email,
}) {
  final preferred = preferredName?.trim() ?? '';
  if (preferred.isNotEmpty) return preferred;

  final fullName = user.name.trim();
  if (fullName.isNotEmpty) return fullName;

  final firstName = user.firstName?.trim() ?? '';
  final lastName = user.lastName?.trim() ?? '';
  final combined = [
    firstName,
    lastName,
  ].where((part) => part.isNotEmpty).join(' ');
  if (combined.isNotEmpty) return combined;

  final emailPrefix = _emailPrefix(email);
  if (emailPrefix.isNotEmpty) return _humanizeIdentifier(emailPrefix);

  return 'User ${_fallbackUserSuffix(user.id)}';
}

String _deriveUsername(
  clerk.User user, {
  required String email,
  required String fallbackName,
}) {
  final clerkUsername = normalizeUsername(user.username ?? '', userId: user.id);
  if (!_looksLikeGeneratedFallback(clerkUsername, user.id) ||
      (user.username?.trim().isNotEmpty ?? false)) {
    return clerkUsername;
  }

  final emailPrefix = _emailPrefix(email);
  final emailUsername = normalizeUsername(emailPrefix, userId: user.id);
  if (!_looksLikeGeneratedFallback(emailUsername, user.id) ||
      emailPrefix.isNotEmpty) {
    return emailUsername;
  }

  final nameUsername = normalizeUsername(fallbackName, userId: user.id);
  if (!_looksLikeGeneratedFallback(nameUsername, user.id) ||
      fallbackName.trim().isNotEmpty) {
    return nameUsername;
  }

  return normalizeUsername('', userId: user.id);
}

String _emailPrefix(String email) {
  final trimmed = email.trim();
  if (trimmed.isEmpty || !trimmed.contains('@')) return '';
  return trimmed.split('@').first.trim();
}

String _humanizeIdentifier(String value) {
  final words = value
      .split(RegExp(r'[._-]+'))
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .map(_capitalize)
      .toList(growable: false);

  if (words.isEmpty) {
    return 'User';
  }

  return words.join(' ');
}

bool _looksLikeGeneratedFallback(String username, String userId) {
  return username == 'user${_fallbackUserSuffix(userId)}';
}

String _fallbackUserSuffix(String? userId) {
  final trimmed = userId?.trim() ?? '';
  if (trimmed.isEmpty) return '0000';

  final length = math.min(4, trimmed.length);
  return trimmed.substring(trimmed.length - length).toLowerCase();
}

String _capitalize(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}
