import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/clerk_config.dart';
import '../../../shared/widgets/pinterest_cached_image.dart';
import '../../auth/application/auth_providers.dart';
import '../../create/presentation/create_entry_sheet.dart';
import '../../home/data/models/pin_model.dart';
import '../../home/data/repositories/pin_repository.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pins = ref.watch(pinRepositoryProvider).getMockPinsSync();
    final savedIds = ref.watch(savedPinsProvider);
    final createdPins = ref.watch(createdPinsProvider);
    final collages = ref.watch(createdCollagesProvider);
    final savedPins = [
      ...createdPins,
      ...pins.where((pin) => savedIds.contains(pin.id)),
    ];
    final fallbackPins = savedPins.isEmpty
        ? pins.take(3).toList()
        : savedPins.take(3).toList();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 28, 12, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFC75A00),
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 26),
                _ProfileTab(
                  label: 'Pins',
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                const SizedBox(width: 26),
                _ProfileTab(
                  label: 'Boards',
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
                const SizedBox(width: 26),
                _ProfileTab(
                  label: 'Collages',
                  selected: _tab == 2,
                  onTap: () => setState(() => _tab = 2),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showSettings(context),
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                            style: TextStyle(
                              color: Color(0xFF9F9F9F),
                              fontSize: 19,
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
            Row(
              children: [
                _FilterPill(icon: Icons.grid_view_rounded),
                const SizedBox(width: 8),
                _FilterPill(label: 'Favorites', icon: Icons.star_rounded),
                const SizedBox(width: 8),
                const _FilterPill(label: 'Created by you'),
              ],
            ),
            const SizedBox(height: 22),
            Expanded(
              child: switch (_tab) {
                0 => _SavedPinsPreview(pins: fallbackPins),
                1 => _BoardsPreview(pins: pins),
                _ => _CollagesPreview(collages: collages),
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    final parentContext = context;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF20211D),
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListTile(
            onTap: () async {
              Navigator.of(context).pop();
              if (!isClerkConfigured) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Clerk is not configured, so there is no active session to log out.',
                    ),
                  ),
                );
                return;
              }

              final authState = ClerkAuth.of(parentContext, listen: false);
              await ref.read(clerkAuthServiceProvider(authState)).signOut();
            },
            leading: const Icon(Icons.logout_rounded, color: Colors.white),
            title: const Text(
              'Log out',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({
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
            width: 46,
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
        color: const Color(0xFF4A4B45),
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

class _SavedPinsPreview extends StatelessWidget {
  const _SavedPinsPreview({required this.pins});

  final List<PinModel> pins;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved Pins'))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 340,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (pins.length > 1)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(
                      width: 190,
                      height: 170,
                      child: PinterestCachedImage(imageUrl: pins[1].imageUrl),
                    ),
                  ),
                if (pins.length > 2)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: SizedBox(
                      width: 190,
                      height: 170,
                      child: PinterestCachedImage(imageUrl: pins[2].imageUrl),
                    ),
                  ),
                SizedBox(
                  width: 190,
                  height: 340,
                  child: PinterestCachedImage(imageUrl: pins.first.imageUrl),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${pins.length} Pins saved',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardsPreview extends StatelessWidget {
  const _BoardsPreview({required this.pins});

  final List<PinModel> pins;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SavedPinsPreview(pins: pins.take(3).toList()),
        const SizedBox(height: 22),
        const Center(
          child: Text(
            'Favorites',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _CollagesPreview extends StatelessWidget {
  const _CollagesPreview({required this.collages});

  final List<CreatedCollage> collages;

  @override
  Widget build(BuildContext context) {
    if (collages.isEmpty) {
      return const Center(
        child: Text(
          'No collages yet',
          style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: collages.length,
      itemBuilder: (context, index) {
        final collage = collages[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: GridTile(
            footer: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black.withValues(alpha: 0.45),
              child: Text(
                collage.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            child: PinterestCachedImage(imageUrl: collage.imageUrls.first),
          ),
        );
      },
    );
  }
}
