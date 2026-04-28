class BoardModel {
  const BoardModel({
    required this.id,
    required this.name,
    required this.coverImageUrls,
    required this.pinIds,
    required this.isSecret,
    required this.isGroupBoard,
    required this.createdAt,
  });

  final String id;
  final String name;
  final List<String> coverImageUrls;
  final List<String> pinIds;
  final bool isSecret;
  final bool isGroupBoard;
  final DateTime createdAt;

  BoardModel copyWith({
    String? name,
    List<String>? coverImageUrls,
    List<String>? pinIds,
    bool? isSecret,
    bool? isGroupBoard,
    DateTime? createdAt,
  }) {
    return BoardModel(
      id: id,
      name: name ?? this.name,
      coverImageUrls: coverImageUrls ?? this.coverImageUrls,
      pinIds: pinIds ?? this.pinIds,
      isSecret: isSecret ?? this.isSecret,
      isGroupBoard: isGroupBoard ?? this.isGroupBoard,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
