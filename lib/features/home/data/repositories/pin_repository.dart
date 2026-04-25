import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pin_model.dart';

final pinRepositoryProvider = Provider<PinRepository>((ref) {
  return PinRepository(Dio());
});

final homePinsProvider = FutureProvider<List<PinModel>>((ref) {
  return ref.watch(pinRepositoryProvider).getHomePins();
});

final searchResultsProvider = FutureProvider.family<List<PinModel>, String>((
  ref,
  query,
) {
  return ref.watch(pinRepositoryProvider).searchPins(query);
});

final relatedPinsProvider = FutureProvider.family<List<PinModel>, String>((
  ref,
  category,
) {
  return ref.watch(pinRepositoryProvider).getRelatedPins(category);
});

final pinByIdProvider = FutureProvider.family<PinModel?, String>((ref, id) {
  return ref.watch(pinRepositoryProvider).getPinById(id);
});

final featuredBoardsProvider = FutureProvider<List<FeaturedBoard>>((ref) {
  return ref.watch(pinRepositoryProvider).getFeaturedBoards();
});

final savedPinsProvider = StateNotifierProvider<SavedPinsNotifier, Set<String>>(
  (ref) => SavedPinsNotifier(),
);

final createdPinsProvider =
    StateNotifierProvider<CreatedPinsNotifier, List<PinModel>>(
      (ref) => CreatedPinsNotifier(),
    );

final createdCollagesProvider =
    StateNotifierProvider<CollageListNotifier, List<CreatedCollage>>(
      (ref) => CollageListNotifier(),
    );

final draftCollagesProvider =
    StateNotifierProvider<CollageListNotifier, List<CreatedCollage>>(
      (ref) => CollageListNotifier(),
    );

final searchFilterProvider = StateProvider<String>((ref) => 'All Pins');

class SavedPinsNotifier extends StateNotifier<Set<String>> {
  SavedPinsNotifier() : super(<String>{});

  void toggle(String id) {
    final next = {...state};
    next.contains(id) ? next.remove(id) : next.add(id);
    state = next;
  }
}

class CreatedPinsNotifier extends StateNotifier<List<PinModel>> {
  CreatedPinsNotifier() : super(const []);

  void add(PinModel pin) {
    state = [pin, ...state];
  }
}

class CollageListNotifier extends StateNotifier<List<CreatedCollage>> {
  CollageListNotifier() : super(const []);

  void add(CreatedCollage collage) {
    state = [collage, ...state];
  }
}

class PopularSection {
  const PopularSection({
    required this.title,
    required this.images,
    required this.query,
  });

  final String title;
  final List<String> images;
  final String query;
}

class PinRepository {
  PinRepository(this.dio);

  final Dio dio;

  Future<List<PinModel>> getHomePins() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return _pins;
  }

  List<PinModel> getMockPinsSync() => _pins;

  Future<List<PinModel>> searchPins(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return _pins;

    final matches = _pins.where((pin) {
      final text =
          '${pin.title} ${pin.category} ${pin.description} ${pin.author}'
              .toLowerCase();
      return text.contains(normalized) ||
          normalized.split(' ').any((part) => text.contains(part));
    }).toList();

    if (matches.length >= 6) return matches;
    if (normalized.contains('travel')) {
      return _pins.where((pin) => pin.category == 'travel').toList();
    }
    if (normalized.contains('tattoo')) {
      return _pins.where((pin) => pin.category == 'tattoo').toList();
    }
    if (normalized.contains('wallpaper')) {
      return _pins.where((pin) => pin.category == 'wallpaper').toList();
    }
    if (normalized.contains('car')) {
      return _pins.where((pin) => pin.category == 'cars').toList();
    }
    return [
      ...matches,
      ..._pins.where((pin) => !matches.contains(pin)),
    ].take(18).toList();
  }

  Future<List<PinModel>> getRelatedPins(String category) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final related = _pins.where((pin) => pin.category == category).toList();
    if (related.length >= 4) return related;
    return [
      ...related,
      ..._pins.where((pin) => pin.category != category),
    ].take(12).toList();
  }

  Future<PinModel?> getPinById(String id) async {
    final pins = await getHomePins();
    for (final pin in pins) {
      if (pin.id == id) return pin;
    }
    return null;
  }

  Future<List<FeaturedBoard>> getFeaturedBoards() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _boards;
  }

  List<PopularSection> getPopularSections() => _popularSections;

  List<CommentModel> getMockComments(String pinId) => const [
    CommentModel(
      id: 'c1',
      username: 'nuri',
      avatarInitial: 'N',
      text: 'Amazing picture Permission SV your photos thanks',
      timeAgo: '1d',
      reactions: 1,
      repliesCount: 1,
    ),
    CommentModel(
      id: 'c2',
      username: 'delapanjuni',
      avatarInitial: 'D',
      text: 'Izin save',
      timeAgo: '1d',
      reactions: 1,
      repliesCount: 1,
      showTranslation: true,
    ),
    CommentModel(
      id: 'c3',
      username: 'travelsoftly',
      avatarInitial: 'T',
      text: 'This place is on my list now.',
      timeAgo: '2d',
      reactions: 3,
      repliesCount: 0,
      showTranslation: true,
    ),
  ];
}

const _pins = [
  PinModel(
    id: 'travel-venice',
    title: 'Venice Canals, Italy Travel Inspiration',
    imageUrl:
        'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?auto=format&fit=crop&w=900&q=85',
    author: 'Global Travel Inspiration Collection',
    description: 'Golden hour gondola ride through Venice with old bridges.',
    likes: 34,
    comments: 4,
    category: 'travel',
    isAiModified: true,
    heightRatio: 1.72,
  ),
  PinModel(
    id: 'travel-dubai-night',
    title: 'Dubai Skyline Balcony View',
    imageUrl:
        'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=900&q=85',
    author: 'City Places',
    description:
        'A blue hour city view with lights, towers, and a high balcony.',
    likes: 89,
    comments: 12,
    category: 'travel',
    isAiModified: false,
    heightRatio: 1.45,
  ),
  PinModel(
    id: 'travel-island',
    title: 'Turquoise Island Boat Trip',
    imageUrl:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=900&q=85',
    author: 'Beach Saved Ideas',
    description: 'Clear water, cliffs, and a dreamy summer itinerary.',
    likes: 58,
    comments: 7,
    category: 'travel',
    isAiModified: false,
    heightRatio: 1.18,
  ),
  PinModel(
    id: 'travel-road',
    title: 'Road Trip Through the Mountains',
    imageUrl:
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=900&q=85',
    author: 'Weekend Route',
    description: 'Long road, wide sky, and quiet places to stop.',
    likes: 74,
    comments: 10,
    category: 'travel',
    isAiModified: false,
    heightRatio: 1.28,
  ),
  PinModel(
    id: 'travel-plane-window',
    title: 'Airplane Window Travel Mood',
    imageUrl:
        'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&w=900&q=85',
    author: 'Boarding Pass Ideas',
    description: 'Clouds from the window seat before landing.',
    likes: 42,
    comments: 3,
    category: 'travel',
    isAiModified: false,
    heightRatio: 1.05,
  ),
  PinModel(
    id: 'travel-hotel-room',
    title: 'Hotel Room With City Morning Light',
    imageUrl:
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=900&q=85',
    author: 'Stay Board',
    description: 'Warm hotel room inspiration for a short city escape.',
    likes: 29,
    comments: 2,
    category: 'travel',
    isAiModified: false,
    heightRatio: 1.24,
  ),
  PinModel(
    id: 'car-bugatti',
    title: 'Luxury Car Night Street',
    imageUrl:
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=900&q=85',
    author: 'Car Videos',
    description: 'Dark red sports car parked outside classic city buildings.',
    likes: 144,
    comments: 16,
    category: 'cars',
    isAiModified: false,
    heightRatio: 1.32,
  ),
  PinModel(
    id: 'car-porsche',
    title: 'Porsche Detail Shot',
    imageUrl:
        'https://images.unsplash.com/photo-1494905998402-395d579af36f?auto=format&fit=crop&w=900&q=85',
    author: 'Garage Saves',
    description: 'Close detail for a moody car edit.',
    likes: 101,
    comments: 9,
    category: 'cars',
    isAiModified: false,
    heightRatio: 1.1,
  ),
  PinModel(
    id: 'tattoo-line',
    title: 'Minimal Fine Line Tattoo Ideas',
    imageUrl:
        'https://images.unsplash.com/photo-1542727365-19732a80dcfd?auto=format&fit=crop&w=900&q=85',
    author: 'Ink Saves',
    description: 'Simple tattoo placement ideas and clean line inspiration.',
    likes: 67,
    comments: 8,
    category: 'tattoo',
    isAiModified: false,
    heightRatio: 1.58,
  ),
  PinModel(
    id: 'tattoo-hand',
    title: 'Hand Tattoo Reference',
    imageUrl:
        'https://images.unsplash.com/photo-1590246814883-2ea990fca608?auto=format&fit=crop&w=900&q=85',
    author: 'Studio Flash',
    description: 'Detailed black ink design reference.',
    likes: 83,
    comments: 11,
    category: 'tattoo',
    isAiModified: false,
    heightRatio: 1.5,
  ),
  PinModel(
    id: 'wallpaper-night',
    title: 'Blue Night Sky Wallpaper',
    imageUrl:
        'https://images.unsplash.com/photo-1519608487953-e999c86e7455?auto=format&fit=crop&w=900&q=85',
    author: 'Phone Wallpapers',
    description: 'Dark sky wallpaper for lock screens.',
    likes: 93,
    comments: 14,
    category: 'wallpaper',
    isAiModified: false,
    heightRatio: 1.36,
  ),
  PinModel(
    id: 'wallpaper-flower',
    title: 'Soft Floral Aesthetic Wallpaper',
    imageUrl:
        'https://images.unsplash.com/photo-1490750967868-88aa4486c946?auto=format&fit=crop&w=900&q=85',
    author: 'Aesthetic Saves',
    description: 'Gentle floral image for a calm phone background.',
    likes: 48,
    comments: 5,
    category: 'wallpaper',
    isAiModified: false,
    heightRatio: 1.42,
  ),
  PinModel(
    id: 'drawing-desk',
    title: 'Easy Drawing Sketchbook Ideas',
    imageUrl:
        'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=900&q=85',
    author: 'Creative Notes',
    description: 'Beginner sketchbook ideas with pencils and paint.',
    likes: 38,
    comments: 3,
    category: 'drawing',
    isAiModified: false,
    heightRatio: 1.14,
  ),
  PinModel(
    id: 'fashion-outfit',
    title: 'Neutral Travel Outfit',
    imageUrl:
        'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=85',
    author: 'Outfit Saves',
    description: 'Simple outfit idea for travel days and city walks.',
    likes: 112,
    comments: 19,
    category: 'fashion',
    isAiModified: false,
    heightRatio: 1.55,
  ),
  PinModel(
    id: 'food-vegetarian',
    title: 'Vegetarian Dinner Bowl',
    imageUrl:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=85',
    author: 'On the Menu',
    description: 'Fresh vegetarian recipe ideas to make on repeat.',
    likes: 76,
    comments: 6,
    category: 'food',
    isAiModified: false,
    heightRatio: 1.1,
  ),
  PinModel(
    id: 'home-living',
    title: 'Warm Home Decor Corner',
    imageUrl:
        'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=900&q=85',
    author: 'Home Decor Ideas',
    description: 'Soft light, textured furniture, and a lived-in room.',
    likes: 54,
    comments: 6,
    category: 'home decor',
    isAiModified: false,
    heightRatio: 1.22,
  ),
  PinModel(
    id: 'art-paint',
    title: 'Colorful Painting Texture',
    imageUrl:
        'https://images.unsplash.com/photo-1541961017774-22349e4a1262?auto=format&fit=crop&w=900&q=85',
    author: 'Art Board',
    description: 'Bright color study and painterly texture.',
    likes: 64,
    comments: 5,
    category: 'art',
    isAiModified: false,
    heightRatio: 1.3,
  ),
  PinModel(
    id: 'photo-gallery',
    title: 'Dreamy Photo Gallery Color Study',
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=900&q=85',
    author: 'My Photo Gallery',
    description: 'Soft landscape tones for a gallery board.',
    likes: 71,
    comments: 8,
    category: 'photo gallery',
    isAiModified: true,
    heightRatio: 1.26,
  ),
];

const _boards = [
  FeaturedBoard(
    id: 'valentine',
    title: 'DIY Valentine\'s gifts',
    category: 'Crafts',
    pinsCount: 75,
    ageLabel: '2mo',
    imageUrls: [
      'https://images.unsplash.com/photo-1518199266791-5375a83190b7?auto=format&fit=crop&w=600&q=85',
      'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=600&q=85',
    ],
  ),
  FeaturedBoard(
    id: 'heisei',
    title: 'Heisei vibes to try',
    category: 'Aesthetics',
    pinsCount: 78,
    ageLabel: '8mo',
    imageUrls: [
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=600&q=85',
      'https://images.unsplash.com/photo-1490750967868-88aa4486c946?auto=format&fit=crop&w=600&q=85',
    ],
  ),
  FeaturedBoard(
    id: 'room',
    title: 'Cozy room inspiration',
    category: 'Home decor',
    pinsCount: 94,
    ageLabel: '1mo',
    imageUrls: [
      'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=600&q=85',
      'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&q=85',
    ],
  ),
];

const _popularSections = [
  PopularSection(
    title: 'Tattoo ideas',
    query: 'tattoo ideas',
    images: [
      'https://images.unsplash.com/photo-1542727365-19732a80dcfd?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1590246814883-2ea990fca608?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1598371839696-5c5bb00bdc28?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1611501275019-9b5cda994e8d?auto=format&fit=crop&w=500&q=85',
    ],
  ),
  PopularSection(
    title: 'My photo gallery',
    query: 'my photo gallery',
    images: [
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1519608487953-e999c86e7455?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1541961017774-22349e4a1262?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1490750967868-88aa4486c946?auto=format&fit=crop&w=500&q=85',
    ],
  ),
  PopularSection(
    title: 'Wallpaper aesthetic',
    query: 'wallpaper aesthetic',
    images: [
      'https://images.unsplash.com/photo-1519608487953-e999c86e7455?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1490750967868-88aa4486c946?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1497250681960-ef046c08a56e?auto=format&fit=crop&w=500&q=85',
    ],
  ),
  PopularSection(
    title: 'Easy drawings',
    query: 'easy drawings',
    images: [
      'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1541961017774-22349e4a1262?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=500&q=85',
    ],
  ),
  PopularSection(
    title: 'Car videos',
    query: 'car videos',
    images: [
      'https://images.unsplash.com/photo-1494905998402-395d579af36f?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=500&q=85',
      'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=500&q=85',
    ],
  ),
];
