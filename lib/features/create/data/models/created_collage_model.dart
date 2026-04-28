import '../../../../core/firebase/firestore_utils.dart';

class CreatedCollageModel {
  const CreatedCollageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.previewImageUrl,
    required this.isDraft,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String previewImageUrl;
  final bool isDraft;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CreatedCollageModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final imageUrls = stringListFrom(map['imageUrls']);
    return CreatedCollageModel(
      id: id ?? map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrls: imageUrls,
      previewImageUrl:
          map['previewImageUrl'] as String? ??
          (imageUrls.isEmpty ? '' : imageUrls.first),
      isDraft: map['isDraft'] as bool? ?? false,
      createdAt: parseFirestoreDate(map['createdAt']),
      updatedAt: parseFirestoreDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'previewImageUrl': previewImageUrl,
      'isDraft': isDraft,
      'createdAt': timestampFromDate(createdAt),
      'updatedAt': timestampFromDate(updatedAt),
    };
  }

  CreatedCollageModel copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? imageUrls,
    String? previewImageUrl,
    bool? isDraft,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CreatedCollageModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      isDraft: isDraft ?? this.isDraft,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
