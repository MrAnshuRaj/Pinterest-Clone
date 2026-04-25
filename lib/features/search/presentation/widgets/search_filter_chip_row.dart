import 'package:flutter/material.dart';

import '../../../../shared/widgets/pinterest_cached_image.dart';

class SearchFilterChipRow extends StatelessWidget {
  const SearchFilterChipRow({super.key});

  static const _chips = [
    _ChipData(
      label: 'Aesthetic',
      color: Color(0xFF274AEF),
      imageUrl:
          'https://images.unsplash.com/photo-1519608487953-e999c86e7455?auto=format&fit=crop&w=240&q=80',
    ),
    _ChipData(
      label: 'Outfit',
      color: Color(0xFFD31414),
      imageUrl:
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=240&q=80',
    ),
    _ChipData(
      label: 'Vision board',
      color: Color(0xFF9B1BB2),
      imageUrl:
          'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=240&q=80',
    ),
    _ChipData(
      label: 'Wallpapers',
      color: Color(0xFF0F8754),
      imageUrl:
          'https://images.unsplash.com/photo-1490750967868-88aa4486c946?auto=format&fit=crop&w=240&q=80',
    ),
    _ChipData(
      label: 'Places',
      color: Color(0xFF1A578E),
      imageUrl:
          'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?auto=format&fit=crop&w=240&q=80',
    ),
    _ChipData(
      label: 'Ideas',
      color: Color(0xFF5D5E5A),
      imageUrl:
          'https://images.unsplash.com/photo-1541961017774-22349e4a1262?auto=format&fit=crop&w=240&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _chips.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = _chips[index];
          return Container(
            width: chip.label.length > 9 ? 150 : 118,
            decoration: BoxDecoration(
              color: chip.color,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 52,
                    child: PinterestCachedImage(
                      imageUrl: chip.imageUrl,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                Container(color: chip.color.withValues(alpha: 0.72)),
                Center(
                  child: Text(
                    chip.label,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChipData {
  const _ChipData({
    required this.label,
    required this.color,
    required this.imageUrl,
  });

  final String label;
  final Color color;
  final String imageUrl;
}
