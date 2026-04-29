import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/pinterest_cached_image.dart';
import '../../create/data/models/created_collage_model.dart';
import '../../create/data/models/created_pin_model.dart';
import '../../create/presentation/create_entry_sheet.dart';
import '../../home/data/models/pin_model.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/presentation/settings/settings_widgets.dart';
import '../application/saved_providers.dart';
import '../data/models/board_model.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key, this.initialTabIndex});

  final int? initialTabIndex;

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  int? _pendingInitialTab;

  @override
  void initState() {
    super.initState();
    _pendingInitialTab = widget.initialTabIndex;
  }

  @override
  void didUpdateWidget(covariant SavedScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex != widget.initialTabIndex) {
      _pendingInitialTab = widget.initialTabIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(savedTabProvider);
    final tab = _pendingInitialTab ?? selectedTab;
    final savedPins = ref.watch(savedPinsProvider);
    final createdPins = ref.watch(createdPinsProvider);
    final boards = ref.watch(boardsProvider);
    final collages = ref.watch(collagesProvider);
    final profile = ref.watch(profileProvider);
    final author = profile.name.trim().isEmpty ? 'Profile' : profile.name;

    debugPrint(
      '[local] saved page pins=${savedPins.length + createdPins.length} boards=${boards.length} collages=${collages.length}',
    );

    final pendingTab = _pendingInitialTab;
    if (pendingTab != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(localSavedStoreProvider.notifier)
            .setSelectedTab(savedTabFromIndex(pendingTab));
        setState(() {
          _pendingInitialTab = null;
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
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
                  _SavedTab(
                    label: 'Pins',
                    index: savedPinsTabIndex,
                    selected: tab == savedPinsTabIndex,
                  ),
                  const SizedBox(width: 24),
                  _SavedTab(
                    label: 'Boards',
                    index: savedBoardsTabIndex,
                    selected: tab == savedBoardsTabIndex,
                  ),
                  const SizedBox(width: 24),
                  _SavedTab(
                    label: 'Collages',
                    index: savedCollagesTabIndex,
                    selected: tab == savedCollagesTabIndex,
                  ),
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
              if (tab == savedPinsTabIndex)
                const Row(
                  children: [
                    _FilterPill(icon: Icons.grid_view_rounded),
                    SizedBox(width: 8),
                    _FilterPill(label: 'Favorites'),
                    SizedBox(width: 8),
                    _FilterPill(label: 'Created by you'),
                  ],
                )
              else if (tab == savedBoardsTabIndex)
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
                child: _buildSavedTabBody(
                  tab: tab,
                  author: author,
                  savedPins: savedPins,
                  createdPins: createdPins,
                  boards: boards,
                  collages: collages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSavedTabBody({
  required int tab,
  required String author,
  required List<PinModel> savedPins,
  required List<CreatedPinModel> createdPins,
  required List<BoardModel> boards,
  required List<CreatedCollageModel> collages,
}) {
  switch (tab) {
    case savedPinsTabIndex:
      return _PinsTab(
        pins: _mergeSavedAndCreatedPins(
          savedPins: savedPins,
          createdPins: createdPins,
          author: author,
        ),
      );
    case savedBoardsTabIndex:
      return _BoardsTab(boards: boards);
    default:
      return _CollagesTab(collages: collages);
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
      onTap: () => ref
          .read(localSavedStoreProvider.notifier)
          .setSelectedTab(savedTabFromIndex(index)),
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
    if (pins.isEmpty) {
      return const Center(
        child: Text(
          'No Pins yet',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.58,
      ),
      itemCount: pins.length,
      itemBuilder: (context, index) {
        final pin = pins[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: pin.imageUrl.trim().isEmpty
              ? Container(
                  color: const Color(0xFF202020),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white54,
                  ),
                )
              : PinterestCachedImage(
                  imageUrl: pin.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                ),
        );
      },
    );
  }
}

class _BoardsTab extends StatelessWidget {
  const _BoardsTab({required this.boards});

  final List<BoardModel> boards;

  @override
  Widget build(BuildContext context) {
    if (boards.isEmpty) {
      return const Center(
        child: Text(
          'No boards yet',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
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
      ],
    );
  }
}

class _CollagesTab extends StatelessWidget {
  const _CollagesTab({required this.collages});

  final List<CreatedCollageModel> collages;

  @override
  Widget build(BuildContext context) {
    if (collages.isEmpty) {
      return const Center(
        child: Text(
          'No collages yet',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.58,
      ),
      itemCount: collages.length,
      itemBuilder: (context, index) {
        final collage = collages[index];
        final previewImage = collage.previewImageUrl.isNotEmpty
            ? collage.previewImageUrl
            : (collage.imageUrls.isNotEmpty ? collage.imageUrls.first : '');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: previewImage.isEmpty
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: const Color(0xFF202020),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white54,
                            ),
                          )
                        : PinterestCachedImage(
                            imageUrl: previewImage,
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
                    collage.title.isEmpty
                        ? formatRelativeDate(collage.createdAt)
                        : collage.title,
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

List<PinModel> _mergeSavedAndCreatedPins({
  required List<PinModel> savedPins,
  required List<CreatedPinModel> createdPins,
  required String author,
}) {
  final byId = <String, PinModel>{};

  for (final pin in createdPins) {
    byId[pin.id] = pin.toPinModel(author: author);
  }
  for (final pin in savedPins) {
    byId[pin.id] = pin;
  }

  return byId.values.toList(growable: false);
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
              child: imageUrls.isEmpty
                  ? _GreyBoardPlaceholder()
                  : Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: PinterestCachedImage(
                            imageUrl: imageUrls.first,
                          ),
                        ),
                        if (imageUrls.length > 1)
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: PinterestCachedImage(
                                    imageUrl: imageUrls[1 % imageUrls.length],
                                  ),
                                ),
                                Expanded(
                                  child: PinterestCachedImage(
                                    imageUrl: imageUrls[2 % imageUrls.length],
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

class _GreyBoardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(color: const Color(0xFF4B4D47))),
        Container(width: 1, color: Colors.black),
        Expanded(
          child: Column(
            children: [
              Expanded(child: Container(color: const Color(0xFF4B4D47))),
              Container(height: 1, color: Colors.black),
              Expanded(child: Container(color: const Color(0xFF4B4D47))),
            ],
          ),
        ),
      ],
    );
  }
}
