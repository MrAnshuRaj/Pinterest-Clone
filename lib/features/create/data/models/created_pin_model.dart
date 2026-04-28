import '../../../../core/firebase/firestore_utils.dart';
import '../../../home/data/models/pin_model.dart';

class CreatedPinModel {
  const CreatedPinModel({
    required this.id,
    required this.title,
    required this.description,
    required this.link,
    required this.imageUrl,
    required this.boardId,
    required this.topics,
    required this.altText,
    required this.allowComments,
    required this.showSimilarProducts,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String link;
  final String imageUrl;
  final String? boardId;
  final List<String> topics;
  final String altText;
  final bool allowComments;
  final bool showSimilarProducts;
  final DateTime createdAt;

  factory CreatedPinModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return CreatedPinModel(
      id: id ?? map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      link: map['link'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      boardId: map['boardId'] as String?,
      topics: stringListFrom(map['topics']),
      altText: map['altText'] as String? ?? '',
      allowComments: map['allowComments'] as bool? ?? true,
      showSimilarProducts: map['showSimilarProducts'] as bool? ?? true,
      createdAt: parseFirestoreDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'imageUrl': imageUrl,
      'boardId': boardId,
      'topics': topics,
      'altText': altText,
      'allowComments': allowComments,
      'showSimilarProducts': showSimilarProducts,
      'createdAt': timestampFromDate(createdAt),
    };
  }

  CreatedPinModel copyWith({
    String? id,
    String? title,
    String? description,
    String? link,
    String? imageUrl,
    String? boardId,
    List<String>? topics,
    String? altText,
    bool? allowComments,
    bool? showSimilarProducts,
    DateTime? createdAt,
  }) {
    return CreatedPinModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      link: link ?? this.link,
      imageUrl: imageUrl ?? this.imageUrl,
      boardId: boardId ?? this.boardId,
      topics: topics ?? this.topics,
      altText: altText ?? this.altText,
      allowComments: allowComments ?? this.allowComments,
      showSimilarProducts: showSimilarProducts ?? this.showSimilarProducts,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  PinModel toPinModel({required String author}) {
    return PinModel(
      id: id,
      title: title,
      imageUrl: imageUrl,
      author: author,
      description: description,
      likes: 0,
      comments: 0,
      category: topics.isEmpty ? 'created' : topics.first.toLowerCase(),
      isAiModified: false,
      heightRatio: 1.22,
    );
  }
}
