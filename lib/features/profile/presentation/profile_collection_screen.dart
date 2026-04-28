import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/pinterest_cached_image.dart';
import '../../home/data/repositories/pin_repository.dart';
import 'settings/settings_widgets.dart';

class ProfileCollectionScreen extends ConsumerStatefulWidget {
  const ProfileCollectionScreen({super.key});

  @override
  ConsumerState<ProfileCollectionScreen> createState() =>
      _ProfileCollectionScreenState();
}

class _ProfileCollectionScreenState
    extends ConsumerState<ProfileCollectionScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pins = ref.watch(pinRepositoryProvider).getMockPinsSync();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            PinterestBackHeader(title: '', trailing: const SizedBox(width: 48)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Switch(
                  label: 'Created',
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                const SizedBox(width: 32),
                _Switch(
                  label: 'Saved',
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.58,
                ),
                itemCount: pins.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: PinterestCachedImage(imageUrl: pins[index].imageUrl),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 66,
            height: 3,
            color: selected ? Colors.white : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
