import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/pinterest_cached_image.dart';
import '../../create/data/models/created_collage_model.dart';
import '../../create/data/models/created_pin_model.dart';
import '../../home/data/models/pin_model.dart';
import '../../saved/application/saved_providers.dart';
import '../../saved/data/models/board_model.dart';
import '../application/profile_providers.dart';
import 'settings/settings_widgets.dart';
import 'widgets/share_profile_sheet.dart';

class PublicProfileScreen extends ConsumerStatefulWidget {
  const PublicProfileScreen({super.key});

  @override
  ConsumerState<PublicProfileScreen> createState() =>
      _PublicProfileScreenState();
}

class _PublicProfileScreenState extends ConsumerState<PublicProfileScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final profile = ref.watch(profileProvider);
    final savedPins = ref.watch(savedPinsListProvider);
    final createdPins = ref.watch(createdPinsListProvider);
    final boards = ref.watch(boardsListProvider);
    final collages = ref.watch(collagesListProvider);

    if (profileAsync.isLoading && profile.name.isEmpty) {
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
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => ShareProfileSheet.show(context),
                  icon: const Icon(
                    Icons.ios_share_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    PinterestAvatar(initial: profile.avatarInitial, radius: 42),
                    Positioned(
                      right: -4,
                      bottom: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        profile.handle,
                        style: const TextStyle(
                          color: pinterestTextGrey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '0 followers · 0 following',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    profile.bio.isEmpty
                        ? 'Add a short bio to make your profile your own'
                        : profile.bio,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                onPressed: () => context.push('/profile/edit'),
                style: pinterestButtonStyle(),
                child: const Text('Edit profile'),
              ),
            ),
            const SizedBox(height: 46),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ProfileContentTab(
                  label: 'Created',
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                const SizedBox(width: 34),
                _ProfileContentTab(
                  label: 'Saved',
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
              ],
            ),
            const SizedBox(height: 36),
            if (_tab == 0)
              _CreatedGrid(pins: createdPins, author: profile.name)
            else
              _SavedProfileContent(
                pins: savedPins,
                boards: boards,
                collages: collages,
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContentTab extends StatelessWidget {
  const _ProfileContentTab({
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
            height: 3,
            width: 66,
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatedGrid extends StatelessWidget {
  const _CreatedGrid({required this.pins, required this.author});

  final List<CreatedPinModel> pins;
  final String author;

  @override
  Widget build(BuildContext context) {
    if (pins.isEmpty) {
      return const Center(
        child: Text(
          'No created Pins yet',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.58,
      ),
      itemCount: pins.length,
      itemBuilder: (context, index) {
        final pin = pins[index].toPinModel(author: author);
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: PinterestCachedImage(imageUrl: pin.imageUrl),
        );
      },
    );
  }
}

class _SavedProfileContent extends StatelessWidget {
  const _SavedProfileContent({
    required this.pins,
    required this.boards,
    required this.collages,
  });

  final List<PinModel> pins;
  final List<BoardModel> boards;
  final List<CreatedCollageModel> collages;

  @override
  Widget build(BuildContext context) {
    if (pins.isEmpty && boards.isEmpty && collages.isEmpty) {
      return const Center(
        child: Text(
          'No saved ideas yet',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 22,
          children: [
            if (pins.isNotEmpty)
              _MiniBoard(
                title: 'All Pins',
                subtitle:
                    '${pins.length} ${pins.length == 1 ? 'Pin' : 'Pins'} · now',
                urls: pins.take(4).map((pin) => pin.imageUrl).toList(),
                width: 170,
              ),
            for (final board in boards)
              _MiniBoard(
                title: board.name,
                subtitle:
                    '${board.pinIds.length} ${board.pinIds.length == 1 ? 'Pin' : 'Pins'} · now',
                urls: board.coverImageUrls,
                width: 170,
              ),
          ],
        ),
        if (collages.isNotEmpty) ...[
          const SizedBox(height: 42),
          const Text(
            'Collages',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.58,
            ),
            itemCount: collages.length,
            itemBuilder: (context, index) {
              final collage = collages[index];
              final imageUrl = collage.previewImageUrl.isEmpty
                  ? collage.imageUrls.first
                  : collage.previewImageUrl;
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: PinterestCachedImage(imageUrl: imageUrl),
              );
            },
          ),
        ],
        if (pins.isNotEmpty) ...[
          const SizedBox(height: 42),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Saved Pins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {},
                style: pinterestButtonStyle(),
                child: const Text('Organize'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.68,
            ),
            itemCount: pins.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: PinterestCachedImage(imageUrl: pins[index].imageUrl),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _MiniBoard extends StatelessWidget {
  const _MiniBoard({
    required this.title,
    required this.subtitle,
    required this.urls,
    this.width,
  });

  final String title;
  final String subtitle;
  final List<String> urls;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final images = urls.isEmpty
        ? [
            'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=700&q=85',
          ]
        : urls;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 132,
              width: double.infinity,
              child: PinterestCachedImage(imageUrl: images.first),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: pinterestTextGrey, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
