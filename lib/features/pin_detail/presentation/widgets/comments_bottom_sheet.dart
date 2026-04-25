import 'package:flutter/material.dart';

import '../../../home/data/models/pin_model.dart';

class CommentsBottomSheet extends StatefulWidget {
  const CommentsBottomSheet({
    super.key,
    required this.comments,
    required this.onShare,
  });

  final List<CommentModel> comments;
  final VoidCallback onShare;

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final _controller = TextEditingController();
  late final List<CommentModel> _comments = [...widget.comments];
  bool _showTip = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addComment([String? text]) {
    final value = (text ?? _controller.text).trim();
    if (value.isEmpty) return;
    setState(() {
      _comments.insert(
        0,
        CommentModel(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          username: 'you',
          avatarInitial: 'Y',
          text: value,
          timeAgo: 'now',
          reactions: 0,
          repliesCount: 0,
        ),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.76,
      minChildSize: 0.48,
      maxChildSize: 0.94,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFF20211D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 5,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF777872),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${_comments.length} comments',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onShare,
                      icon: const Icon(
                        Icons.upload_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFF383934)),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                  children: [
                    if (_showTip)
                      _TipCard(
                        onDismiss: () => setState(() => _showTip = false),
                      ),
                    const SizedBox(height: 18),
                    for (final comment in _comments)
                      _CommentTile(comment: comment),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  14,
                  20,
                  14 + MediaQuery.viewInsetsOf(context).bottom,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF20211D),
                  border: Border(top: BorderSide(color: Color(0xFF383934))),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final chip in const [
                            'Love it ❤️',
                            'Brilliant!',
                            'Obsessed 😍',
                            'Looks good!',
                          ])
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ActionChip(
                                onPressed: () => _addComment(chip),
                                backgroundColor: const Color(0xFF4A4B45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                label: Text(
                                  chip,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton.filled(
                          onPressed: () {},
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF4A4B45),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add_rounded),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onSubmitted: _addComment,
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Add a comment',
                              hintStyle: const TextStyle(
                                color: Color(0xFFA8A8A8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(999),
                                borderSide: const BorderSide(
                                  color: Color(0xFF666761),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(999),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF30312B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Easier actions on comments\nSwipe left or tap and hold on a comment to take actions like delete, edit or report',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                height: 1.18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: onDismiss,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE60023),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF3455E8),
            child: Text(
              comment.avatarInitial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: comment.username,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                    children: [
                      TextSpan(
                        text: '  ${comment.timeAgo}',
                        style: const TextStyle(
                          color: Color(0xFFA8A8A8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  comment.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.25,
                  ),
                ),
                if (comment.showTranslation) ...[
                  const SizedBox(height: 9),
                  const Text(
                    'See translation',
                    style: TextStyle(color: Color(0xFFA8A8A8), fontSize: 16),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Reply',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${comment.reactions} reaction',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ],
                ),
                if (comment.repliesCount > 0) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(width: 46, height: 1, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        'View ${comment.repliesCount} reply',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: const [
              Icon(Icons.flag_outlined, color: Colors.white, size: 28),
              SizedBox(height: 18),
              Icon(Icons.block_rounded, color: Colors.white, size: 28),
            ],
          ),
        ],
      ),
    );
  }
}
