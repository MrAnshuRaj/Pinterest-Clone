import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/pinterest_cached_image.dart';
import '../../home/data/models/pin_model.dart';
import '../../home/data/repositories/pin_repository.dart';
import '../../home/presentation/widgets/pin_card.dart';
import 'widgets/comments_bottom_sheet.dart';
import 'widgets/more_to_explore_grid.dart';
import 'widgets/pin_action_row.dart';
import 'widgets/share_pin_sheet.dart';

class PinDetailScreen extends ConsumerStatefulWidget {
  const PinDetailScreen({super.key, required this.pinId, this.initialPin});

  final String pinId;
  final PinModel? initialPin;

  @override
  ConsumerState<PinDetailScreen> createState() => _PinDetailScreenState();
}

class _PinDetailScreenState extends ConsumerState<PinDetailScreen> {
  bool _liked = false;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.initialPin?.likes ?? 0;
  }

  void _toggleLike(PinModel pin) {
    setState(() {
      _liked = !_liked;
      _likes += _liked ? 1 : -1;
    });
  }

  void _showComments(PinModel pin) {
    final comments = ref.read(pinRepositoryProvider).getMockComments(pin.id);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsBottomSheet(
        comments: comments,
        onShare: () {
          Navigator.of(context).pop();
          _showShare(pin);
        },
      ),
    );
  }

  void _showShare(PinModel pin) {
    final relatedImages = ref
        .read(pinRepositoryProvider)
        .getMockPinsSync()
        .where((item) => item.id != pin.id)
        .take(3)
        .map((item) => item.imageUrl)
        .toList();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          SharePinSheet(pin: pin, relatedImages: relatedImages),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialPin = widget.initialPin;
    if (initialPin != null) return _buildDetail(context, initialPin);

    final pin = ref.watch(pinByIdProvider(widget.pinId));
    return pin.when(
      data: (item) {
        if (item == null) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'Pin not found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        if (_likes == 0) _likes = item.likes;
        return _buildDetail(context, item);
      },
      loading: () => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFE60023)),
        ),
      ),
      error: (error, stackTrace) => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Could not open pin',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, PinModel pin) {
    final saved = ref.watch(savedPinsProvider).contains(pin.id);
    final imageRatio = 1 / math.min(pin.heightRatio, 1.78);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: 'pin-${pin.id}',
                    child: AspectRatio(
                      aspectRatio: imageRatio,
                      child: PinterestCachedImage(
                        imageUrl: pin.imageUrl,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 12,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.46),
                        foregroundColor: Colors.white,
                        fixedSize: const Size(56, 56),
                      ),
                      icon: const Icon(Icons.chevron_left_rounded, size: 42),
                    ),
                  ),
                  if (pin.isAiModified)
                    const Positioned(
                      left: 28,
                      bottom: 22,
                      child: Text(
                        'AI modified',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      height: 58,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.74),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Search image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.search_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              PinActionRow(
                likes: _likes,
                comments: pin.comments,
                liked: _liked,
                saved: saved,
                onLike: () => _toggleLike(pin),
                onComment: () => _showComments(pin),
                onShare: () => _showShare(pin),
                onMore: () => PinCard.showPinMenu(context),
                onSave: () =>
                    ref.read(savedPinsProvider.notifier).toggle(pin.id),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: Text(
                        pin.author.isEmpty ? 'P' : pin.author[0],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        pin.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 10, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        pin.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          height: 1.12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF3B3B38),
                        foregroundColor: Colors.white,
                        fixedSize: const Size(42, 42),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 28, 18, 14),
                child: Text(
                  'More to explore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 24),
                child: MoreToExploreGrid(
                  category: pin.category,
                  currentPinId: pin.id,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
