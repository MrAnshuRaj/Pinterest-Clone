import '../../../../core/firebase/firestore_utils.dart';

class InboxUpdateModel {
  const InboxUpdateModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.type,
    required this.createdAt,
    required this.read,
    required this.hidden,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String type;
  final DateTime createdAt;
  final bool read;
  final bool hidden;

  factory InboxUpdateModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return InboxUpdateModel(
      id: id ?? map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String?,
      imageUrl: map['imageUrl'] as String?,
      type: map['type'] as String? ?? 'image',
      createdAt: parseFirestoreDate(map['createdAt']),
      read: map['read'] as bool? ?? false,
      hidden: map['hidden'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'type': type,
      'createdAt': timestampFromDate(createdAt),
      'read': read,
      'hidden': hidden,
    };
  }

  InboxUpdateModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    String? type,
    DateTime? createdAt,
    bool? read,
    bool? hidden,
  }) {
    return InboxUpdateModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
      hidden: hidden ?? this.hidden,
    );
  }
}
