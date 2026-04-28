import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/home/data/models/pin_model.dart';
import '../../../../features/home/data/repositories/pin_repository.dart';
import '../../../../features/profile/presentation/settings/settings_widgets.dart';
import '../../../../features/saved/application/saved_providers.dart';
import '../../../../shared/widgets/pinterest_cached_image.dart';

class SavePinsToBoardScreen extends ConsumerStatefulWidget {
  const SavePinsToBoardScreen({super.key, required this.boardId});

  final String boardId;

  @override
  ConsumerState<SavePinsToBoardScreen> createState() =>
      _SavePinsToBoardScreenState();
}

class _SavePinsToBoardScreenState extends ConsumerState<SavePinsToBoardScreen> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final pins = ref.watch(pinRepositoryProvider).getMockPinsSync();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            PinterestBackHeader(
              title: 'Save some Pins to your board',
              leading: IconButton(
                onPressed: () => context.go('/saved'),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            Expanded(
              child: MasonryGridView.count(
                padding: EdgeInsets.fromLTRB(
                  6,
                  14,
                  6,
                  _selected.isEmpty ? 18 : 96,
                ),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 8,
                itemCount: pins.length,
                itemBuilder: (context, index) {
                  final pin = pins[index];
                  final selected = _selected.contains(pin.id);
                  return _SelectablePinCard(
                    pin: pin,
                    selected: selected,
                    onTap: () => setState(() {
                      selected
                          ? _selected.remove(pin.id)
                          : _selected.add(pin.id);
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _selected.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
                child: SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: () => _save(pins),
                    style: pinterestButtonStyle(color: pinterestRed),
                    child: const Text('Done'),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _save(List<PinModel> pins) async {
    final selectedPins = pins
        .where((pin) => _selected.contains(pin.id))
        .toList(growable: false);
    final controller = ref.read(savedContentControllerProvider);
    await controller.addPinsToBoard(widget.boardId, selectedPins);
    for (final pin in selectedPins) {
      await controller.savePin(pin);
    }
    ref.read(savedTabProvider.notifier).state = 1;
    if (!mounted) return;
    context.go('/saved');
  }
}

class _SelectablePinCard extends StatelessWidget {
  const _SelectablePinCard({
    required this.pin,
    required this.selected,
    required this.onTap,
  });

  final PinModel pin;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1 / pin.heightRatio.clamp(1.2, 1.65),
                  child: PinterestCachedImage(imageUrl: pin.imageUrl),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    selected ? Icons.check_rounded : Icons.push_pin_rounded,
                    color: selected ? Colors.black : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 2, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    pin.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(Icons.more_horiz_rounded, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
