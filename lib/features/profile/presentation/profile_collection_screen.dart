import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/pinterest_cached_image.dart';
import '../../saved/application/saved_providers.dart';
import 'settings/settings_widgets.dart';

class ProfileCollectionScreen extends ConsumerStatefulWidget {
  const ProfileCollectionScreen({super.key});

  @override
  ConsumerState<ProfileCollectionScreen> createState() =>
      _ProfileCollectionScreenState();
}

class _ProfileCollectionScreenState
    extends ConsumerState<ProfileCollectionScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final createdPinsAsync = ref.watch(createdPinsProvider);
    final savedPinsAsync = ref.watch(savedPinsProvider);
    final boardsAsync = ref.watch(boardsProvider);
    final collagesAsync = ref.watch(collagesProvider);
    final createdPins = ref.watch(createdPinsListProvider);
    final savedPins = ref.watch(savedPinsListProvider);
    final boards = ref.watch(boardsListProvider);
    final collages = ref.watch(collagesListProvider);
    final publishedCollages = collages
        .where((collage) => !collage.isDraft)
        .toList(growable: false);
    final isLoading =
        createdPinsAsync.isLoading ||
        savedPinsAsync.isLoading ||
        boardsAsync.isLoading ||
        collagesAsync.isLoading;

    if (isLoading &&
        createdPins.isEmpty &&
        savedPins.isEmpty &&
        boards.isEmpty &&
        collages.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: PinterestStatusView(
          message: 'Loading your profile...',
          showSpinner: true,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            PinterestBackHeader(title: '', trailing: const SizedBox(width: 48)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Switch(
                  label: 'Created',
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                const SizedBox(width: 32),
                _Switch(
                  label: 'Saved',
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Expanded(
              child: _tab == 0
                  ? _PinsGrid(
                      urls: [
                        ...createdPins.map((pin) => pin.imageUrl),
                        ...publishedCollages.map(
                          (collage) => collage.previewImageUrl.isEmpty
                              ? collage.imageUrls.first
                              : collage.previewImageUrl,
                        ),
                      ],
                      emptyMessage: 'No created content yet',
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        if (boards.isNotEmpty) ...[
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (final board in boards)
                                _BoardPreview(
                                  title: board.name,
                                  imageUrl: board.coverImageUrls.isEmpty
                                      ? null
                                      : board.coverImageUrls.first,
                                ),
                            ],
                          ),
                          const SizedBox(height: 18),
                        ],
                        _PinsGrid(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          urls: [
                            ...collages.map(
                              (collage) => collage.previewImageUrl.isEmpty
                                  ? collage.imageUrls.first
                                  : collage.previewImageUrl,
                            ),
                            ...savedPins.map((pin) => pin.imageUrl),
                          ],
                          emptyMessage: 'No saved ideas yet',
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinsGrid extends StatelessWidget {
  const _PinsGrid({
    required this.urls,
    required this.emptyMessage,
    this.shrinkWrap = false,
    this.physics,
  });

  final List<String> urls;
  final String emptyMessage;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.58,
      ),
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: PinterestCachedImage(imageUrl: urls[index]),
        );
      },
    );
  }
}

class _BoardPreview extends StatelessWidget {
  const _BoardPreview({required this.title, required this.imageUrl});

  final String title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 112,
              height: 88,
              child: PinterestCachedImage(
                imageUrl: imageUrl ??
                    'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=700&q=85',
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 66,
            height: 3,
            color: selected ? Colors.white : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
