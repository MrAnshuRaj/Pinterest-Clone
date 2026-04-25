import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../data/repositories/pin_repository.dart';
import 'widgets/pin_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pins = ref.watch(homePinsProvider);

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
                  onPressed: () {},
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
          Expanded(
            child: pins.when(
              data: (items) => MasonryGridView.count(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 16),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 6,
                itemCount: items.length,
                itemBuilder: (context, index) => PinCard(pin: items[index]),
              ),
              loading: () => MasonryGridView.count(
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
              ),
              error: (error, stackTrace) => Center(
                child: Text(
                  'Could not load pins',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
