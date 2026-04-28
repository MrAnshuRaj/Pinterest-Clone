import '../../../../core/firebase/firestore_utils.dart';

class PinModel {
  const PinModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.description,
    required this.likes,
    required this.comments,
    required this.category,
    required this.isAiModified,
    required this.heightRatio,
    this.avatarUrl,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String author;
  final String description;
  final String? avatarUrl;
  final int likes;
  final int comments;
  final String category;
  final bool isAiModified;
  final double heightRatio;

  factory PinModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return PinModel(
      id: id ?? map['pinId'] as String? ?? map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      author: map['author'] as String? ?? '',
      description: map['description'] as String? ?? '',
      likes: map['likes'] as int? ?? 0,
      comments: map['comments'] as int? ?? 0,
      category: map['category'] as String? ?? '',
      isAiModified: map['isAiModified'] as bool? ?? false,
      heightRatio: (map['heightRatio'] as num?)?.toDouble() ?? 1.22,
      avatarUrl: map['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pinId': id,
      'title': title,
      'imageUrl': imageUrl,
      'author': author,
      'description': description,
      'likes': likes,
      'comments': comments,
      'category': category,
      'isAiModified': isAiModified,
      'heightRatio': heightRatio,
      'avatarUrl': avatarUrl,
      'savedAt': timestampFromDate(DateTime.now()),
    };
  }

  PinModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? author,
    String? description,
    String? avatarUrl,
    int? likes,
    int? comments,
    String? category,
    bool? isAiModified,
    double? heightRatio,
  }) {
    return PinModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      category: category ?? this.category,
      isAiModified: isAiModified ?? this.isAiModified,
      heightRatio: heightRatio ?? this.heightRatio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class CommentModel {
  const CommentModel({
    required this.id,
    required this.username,
    required this.avatarInitial,
    required this.text,
    required this.timeAgo,
    required this.reactions,
    required this.repliesCount,
    this.showTranslation = false,
  });

  final String id;
  final String username;
  final String avatarInitial;
  final String text;
  final String timeAgo;
  final int reactions;
  final int repliesCount;
  final bool showTranslation;
}

class CollageItem {
  const CollageItem({
    required this.id,
    required this.imageUrl,
    required this.dx,
    required this.dy,
    required this.width,
    required this.height,
    this.rotation = 0,
  });

  final String id;
  final String imageUrl;
  final double dx;
  final double dy;
  final double width;
  final double height;
  final double rotation;

  CollageItem copyWith({
    double? dx,
    double? dy,
    double? width,
    double? height,
    double? rotation,
  }) {
    return CollageItem(
      id: id,
      imageUrl: imageUrl,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
    );
  }
}

class FeaturedBoard {
  const FeaturedBoard({
    required this.id,
    required this.title,
    required this.category,
    required this.pinsCount,
    required this.ageLabel,
    required this.imageUrls,
  });

  final String id;
  final String title;
  final String category;
  final int pinsCount;
  final String ageLabel;
  final List<String> imageUrls;
}
