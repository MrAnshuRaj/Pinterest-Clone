import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../home/data/repositories/pin_repository.dart';
import '../../../home/presentation/widgets/pin_card.dart';

class MoreToExploreGrid extends ConsumerWidget {
  const MoreToExploreGrid({
    super.key,
    required this.category,
    required this.currentPinId,
  });

  final String category;
  final String currentPinId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final related = ref.watch(relatedPinsProvider(category));

    return related.when(
      data: (pins) {
        final items = pins.where((pin) => pin.id != currentPinId).toList();
        return MasonryGridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 6,
          itemCount: items.length,
          itemBuilder: (context, index) => PinCard(pin: items[index]),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFFE60023)),
        ),
      ),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
