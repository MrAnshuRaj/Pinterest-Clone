import '../../../../core/firebase/firestore_utils.dart';

class BoardModel {
  const BoardModel({
    required this.id,
    required this.name,
    required this.coverImageUrls,
    required this.pinIds,
    required this.isSecret,
    required this.isGroupBoard,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final List<String> coverImageUrls;
  final List<String> pinIds;
  final bool isSecret;
  final bool isGroupBoard;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory BoardModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return BoardModel(
      id: id,
      name: map['name'] as String? ?? '',
      coverImageUrls: stringListFrom(map['coverImageUrls']),
      pinIds: stringListFrom(map['pinIds']),
      isSecret: map['isSecret'] as bool? ?? false,
      isGroupBoard: map['isGroupBoard'] as bool? ?? false,
      createdAt: parseFirestoreDate(map['createdAt']),
      updatedAt: parseFirestoreDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'coverImageUrls': coverImageUrls,
      'pinIds': pinIds,
      'isSecret': isSecret,
      'isGroupBoard': isGroupBoard,
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  BoardModel copyWith({
    String? id,
    String? name,
    List<String>? coverImageUrls,
    List<String>? pinIds,
    bool? isSecret,
    bool? isGroupBoard,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BoardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      coverImageUrls: coverImageUrls ?? this.coverImageUrls,
      pinIds: pinIds ?? this.pinIds,
      isSecret: isSecret ?? this.isSecret,
      isGroupBoard: isGroupBoard ?? this.isGroupBoard,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
