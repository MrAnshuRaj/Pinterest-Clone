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

class CreatedCollage {
  const CreatedCollage({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.createdAt,
    this.isDraft = false,
  });

  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final DateTime createdAt;
  final bool isDraft;
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
