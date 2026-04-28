import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/pinterest_cached_image.dart';
import '../../create/presentation/create_entry_sheet.dart';
import '../../home/data/models/pin_model.dart';
import '../../home/data/repositories/pin_repository.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/presentation/settings/settings_widgets.dart';
import '../application/saved_providers.dart';
import '../data/models/board_model.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(savedTabProvider);
    final profile = ref.watch(profileProvider);
    final pins = ref.watch(pinRepositoryProvider).getMockPinsSync();
    final boards = ref.watch(boardsProvider);
    final collages = ref.watch(createdCollagesProvider);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 28, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => context.push('/profile'),
                  child: PinterestAvatar(
                    initial: profile.avatarInitial,
                    radius: 25,
                  ),
                ),
                const Spacer(),
                _SavedTab(label: 'Pins', index: 0, selected: tab == 0),
                const SizedBox(width: 24),
                _SavedTab(label: 'Boards', index: 1, selected: tab == 1),
                const SizedBox(width: 24),
                _SavedTab(label: 'Collages', index: 2, selected: tab == 2),
                const Spacer(),
                IconButton(
                  onPressed: () => context.push('/profile/settings'),
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white, width: 1.1),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Search your saved ideas',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: pinterestTextGrey,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => CreateEntrySheet.show(context),
                  icon: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (tab == 0)
              const Row(
                children: [
                  _FilterPill(icon: Icons.grid_view_rounded),
                  SizedBox(width: 8),
                  _FilterPill(label: 'Favorites'),
                  SizedBox(width: 8),
                  _FilterPill(label: 'Created by you'),
                ],
              )
            else if (tab == 1)
              const Row(
                children: [
                  _FilterPill(icon: Icons.swap_vert_rounded),
                  SizedBox(width: 8),
                  _FilterPill(label: 'Group'),
                  SizedBox(width: 8),
                  _FilterPill(label: 'Archived'),
                ],
              )
            else
              const Row(
                children: [
                  _FilterPill(label: 'Published'),
                  SizedBox(width: 8),
                  _FilterPill(label: 'In progress'),
                ],
              ),
            const SizedBox(height: 22),
            Expanded(
              child: switch (tab) {
                0 => _PinsTab(pins: pins),
                1 => _BoardsTab(boards: boards, pins: pins),
                _ => _CollagesTab(collages: collages),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedTab extends ConsumerWidget {
  const _SavedTab({
    required this.label,
    required this.index,
    required this.selected,
  });

  final String label;
  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => ref.read(savedTabProvider.notifier).state = index,
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
            width: 48,
            height: 3,
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

class _FilterPill extends StatelessWidget {
  const _FilterPill({this.label, this.icon});

  final String? label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: pinterestGrey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white, size: 24),
          if (label != null && icon != null) const SizedBox(width: 6),
          if (label != null)
            Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }
}

class _PinsTab extends StatelessWidget {
  const _PinsTab({required this.pins});

  final List<PinModel> pins;

  @override
  Widget build(BuildContext context) {
    final preview = pins.take(4).toList();
    return ListView(
      children: [
        _BoardCard(
          name: '${preview.length} Pins saved',
          subtitle: '',
          imageUrls: preview.map((pin) => pin.imageUrl).toList(),
          width: double.infinity,
        ),
      ],
    );
  }
}

class _BoardsTab extends StatelessWidget {
  const _BoardsTab({required this.boards, required this.pins});

  final List<BoardModel> boards;
  final List<PinModel> pins;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 22,
          children: [
            for (final board in boards)
              _BoardCard(
                name: board.name,
                subtitle:
                    '${board.pinIds.length} ${board.pinIds.length == 1 ? 'Pin' : 'Pins'} now',
                imageUrls: board.coverImageUrls,
                width: 180,
              ),
          ],
        ),
        const SizedBox(height: 58),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Unorganized ideas',
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
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: pins.length > 8 ? 8 : pins.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 120,
                  child: PinterestCachedImage(imageUrl: pins[index].imageUrl),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CollagesTab extends StatelessWidget {
  const _CollagesTab({required this.collages});

  final List<CreatedCollage> collages;

  @override
  Widget build(BuildContext context) {
    final items = collages.isEmpty
        ? [
            CreatedCollage(
              id: 'draft-boy',
              title: 'Boy',
              description: '',
              imageUrls: const [
                'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=500&q=85',
              ],
              createdAt: DateTime(2026, 4, 26),
              isDraft: true,
            ),
            CreatedCollage(
              id: 'draft-camp',
              title: 'My collage',
              description: '',
              imageUrls: const [
                'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=500&q=85',
              ],
              createdAt: DateTime(2026, 4, 26),
            ),
          ]
        : collages;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.58,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final collage = items[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: PinterestCachedImage(
                      imageUrl: collage.imageUrls.first,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  if (collage.isDraft)
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    collage.title.isEmpty ? 'Apr 26' : collage.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(Icons.more_horiz_rounded, color: Colors.white),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _BoardCard extends StatelessWidget {
  const _BoardCard({
    required this.name,
    required this.subtitle,
    required this.imageUrls,
    required this.width,
  });

  final String name;
  final String subtitle;
  final List<String> imageUrls;
  final double width;

  @override
  Widget build(BuildContext context) {
    final fallback = imageUrls.isEmpty
        ? [
            'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=700&q=85',
            'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?auto=format&fit=crop&w=700&q=85',
          ]
        : imageUrls;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 128,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PinterestCachedImage(imageUrl: fallback.first),
                  ),
                  if (fallback.length > 1)
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: PinterestCachedImage(
                              imageUrl: fallback[1 % fallback.length],
                            ),
                          ),
                          Expanded(
                            child: PinterestCachedImage(
                              imageUrl: fallback[2 % fallback.length],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(
                color: pinterestTextGrey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
