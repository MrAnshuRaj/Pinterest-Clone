import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/pinterest_cached_image.dart';
import '../../../home/data/models/pin_model.dart';
import '../../../home/data/repositories/pin_repository.dart';
import '../../../saved/application/saved_providers.dart';
import '../../application/settings_providers.dart';
import 'settings_widgets.dart';

class RefineRecommendationsScreen extends ConsumerStatefulWidget {
  const RefineRecommendationsScreen({super.key});

  @override
  ConsumerState<RefineRecommendationsScreen> createState() =>
      _RefineRecommendationsScreenState();
}

class _RefineRecommendationsScreenState
    extends ConsumerState<RefineRecommendationsScreen> {
  int _tab = 0;

  static const _tabs = [
    'Pins',
    'AI content',
    'Interests',
    'Boards',
    'Following',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 12, 0),
              child: PinterestBackHeader(
                title: 'Refine your recommendations',
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 58,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                separatorBuilder: (context, index) => const SizedBox(width: 28),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => setState(() => _tab = index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _tabs[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          height: 3,
                          width: 42,
                          decoration: BoxDecoration(
                            color: _tab == index
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: switch (_tab) {
                0 => const _PinsRefineTab(),
                1 => const _AiContentTab(),
                2 => const _InterestsTab(),
                3 => const _BoardsRefineTab(),
                _ => const _FollowingTab(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PinsRefineTab extends ConsumerWidget {
  const _PinsRefineTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pins = ref.watch(pinRepositoryProvider).getMockPinsSync();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 4, 28, 20),
          child: Text(
            'Hide Pins you’ve saved or viewed close-up',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        Expanded(
          child: MasonryGridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 10,
            itemCount: pins.length,
            itemBuilder: (context, index) {
              final pin = pins[index];
              return _HideablePin(pin: pin, index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _HideablePin extends ConsumerWidget {
  const _HideablePin({required this.pin, required this.index});

  final PinModel pin;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hidden = ref.watch(pinterestSettingsProvider).hiddenPinIds.contains(
          pin.id,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Opacity(
              opacity: hidden ? 0.38 : 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 1 / pin.heightRatio.clamp(1.0, 1.55),
                  child: PinterestCachedImage(imageUrl: pin.imageUrl),
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: InkWell(
                onTap: () => ref
                    .read(pinterestSettingsProvider.notifier)
                    .toggleHiddenPin(pin.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xCC4A4B45),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hidden
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_off_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (index < 4)
          const Text(
            'Travel',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        Text(
          index < 4 ? '2m ago' : index < 6 ? '2h ago' : '2d ago',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }
}

class _AiContentTab extends ConsumerWidget {
  const _AiContentTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(pinterestSettingsProvider);
    final controller = ref.read(pinterestSettingsProvider.notifier);
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 28),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'See more or less AI-modified content by turning interests on or off.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(height: 22),
        for (final item in aiCategories)
          SettingsSwitchRow(
            title: item,
            value: settings.aiToggles[item] ?? true,
            onChanged: (value) => controller.toggleAi(item, value),
          ),
      ],
    );
  }
}

class _InterestsTab extends ConsumerWidget {
  const _InterestsTab();

  static const _interests = [
    ('Food and Drinks', 'https://images.unsplash.com/photo-1497534446932-c925b458314e?auto=format&fit=crop&w=500&q=85'),
    ('Home Decor', 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=500&q=85'),
    ('Quotes', 'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=500&q=85'),
    ('Wallpapers', 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=500&q=85'),
    ('Anime', 'https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=500&q=85'),
    ('Ganesha', 'https://images.unsplash.com/photo-1599983915785-338a5a0271d7?auto=format&fit=crop&w=500&q=85'),
    ('Cars', 'https://images.unsplash.com/photo-1494905998402-395d579af36f?auto=format&fit=crop&w=500&q=85'),
    ('Nature Photography', 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=500&q=85'),
    ('Luxury Cars', 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=500&q=85'),
    ('Soccer', 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&w=500&q=85'),
    ('Comics Art', 'https://images.unsplash.com/photo-1601645191163-3fc0d5d64e35?auto=format&fit=crop&w=500&q=85'),
    ('Landscape Photography', 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=500&q=85'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(pinterestSettingsProvider).selectedInterests;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 28),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 18,
        childAspectRatio: 0.82,
      ),
      itemCount: _interests.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _GridIntro(
            text: 'Edit your interests to get personalized recommendations',
          );
        }
        final item = _interests[index - 1];
        final isSelected = selected.contains(item.$1);
        return InkWell(
          onTap: () => ref
              .read(pinterestSettingsProvider.notifier)
              .toggleInterest(item.$1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: PinterestCachedImage(
                        imageUrl: item.$2,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.black87,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isSelected ? Icons.check_rounded : Icons.add_rounded,
                          color: isSelected ? Colors.black : Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.$1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GridIntro extends StatelessWidget {
  const _GridIntro({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class _BoardsRefineTab extends ConsumerWidget {
  const _BoardsRefineTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(boardsProvider);
    final settings = ref.watch(pinterestSettingsProvider);
    final controller = ref.read(pinterestSettingsProvider.notifier);
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 28),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Switch off a board to remove its Home tab and recommendations. Don’t worry, this won’t affect your board.',
            style: TextStyle(color: Colors.white, fontSize: 18, height: 1.2),
          ),
        ),
        const SizedBox(height: 22),
        for (final board in boards)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: PinterestCachedImage(
                      imageUrl: board.coverImageUrls.isEmpty
                          ? 'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?auto=format&fit=crop&w=500&q=85'
                          : board.coverImageUrls.first,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        board.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${board.pinIds.length} Pins',
                        style: const TextStyle(color: pinterestTextGrey),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value:
                      settings.boardRecommendationToggles[board.id] ?? true,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF6265F6),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: pinterestGrey,
                  onChanged: (value) =>
                      controller.toggleBoardRecommendation(board.id, value),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FollowingTab extends StatelessWidget {
  const _FollowingTab();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 4, 28, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unfollow a person or brand to stop seeing their published Pins. They won’t be notified that you’ve unfollowed them.',
            style: TextStyle(color: Colors.white, fontSize: 18, height: 1.2),
          ),
          SizedBox(height: 92),
          Center(
            child: Text(
              'You’re not following\nanyone or anything\nyet. Follow the\nboards, brands and\npeople that you want\nto see more of in your\nhome feed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                height: 1.28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
