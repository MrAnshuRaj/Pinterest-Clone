import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../data/models/pin_model.dart';
import '../data/repositories/pin_repository.dart';
import 'widgets/pin_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  List<PinModel> _pins = const [];
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Object? _initialError;
  int _nextPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialFeed());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadInitialFeed() async {
    setState(() {
      _isInitialLoading = true;
      _initialError = null;
      _pins = const [];
      _hasMore = true;
      _nextPage = 0;
    });
    await _loadMorePins(reset: true);
  }

  Future<void> _loadMorePins({bool reset = false}) async {
    if (_isLoadingMore || (!_hasMore && !reset)) return;

    setState(() {
      _isLoadingMore = true;
      if (reset) {
        _initialError = null;
      }
    });

    try {
      final pageToLoad = reset ? 0 : _nextPage;
      final items = await ref
          .read(pinRepositoryProvider)
          .getHomeFeedPage(page: pageToLoad);

      if (!mounted) return;

      setState(() {
        _pins = reset ? items : [..._pins, ...items];
        _nextPage = pageToLoad + 1;
        _hasMore = items.length == PinRepository.homeFeedPageSize;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _initialError = error;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _handleScroll() {
    if (!_scrollController.hasClients || _isLoadingMore || !_hasMore) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 1000) {
      _loadMorePins();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 14, 6),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'All',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 28,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () =>
                      context.push('/profile/settings/refine-recommendations'),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF4B4D48),
                    foregroundColor: Colors.white,
                    fixedSize: const Size(48, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.auto_fix_high_rounded, size: 25),
                ),
              ],
            ),
          ),
          Expanded(child: _buildFeed(context)),
        ],
      ),
    );
  }

  Widget _buildFeed(BuildContext context) {
    if (_isInitialLoading) {
      return MasonryGridView.count(
        padding: const EdgeInsets.fromLTRB(6, 4, 6, 16),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 6,
        itemCount: 8,
        itemBuilder: (context, index) => Container(
          height: index.isEven ? 250 : 330,
          decoration: BoxDecoration(
            color: const Color(0xFF202020),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      );
    }

    if (_pins.isEmpty && _initialError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Could not load pins',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadInitialFeed,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    return MasonryGridView.count(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 16),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 6,
      itemCount: _pins.length + (_isLoadingMore ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= _pins.length) {
          return const _FeedLoadingTile();
        }
        return PinCard(pin: _pins[index]);
      },
    );
  }
}

class _FeedLoadingTile extends StatelessWidget {
  const _FeedLoadingTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Color(0xFFE60023),
          ),
        ),
      ),
    );
  }
}
