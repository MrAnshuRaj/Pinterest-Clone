import 'package:flutter/material.dart';

import '../../../../shared/widgets/pinterest_cached_image.dart';

class CollagePhotoPickerScreen extends StatefulWidget {
  const CollagePhotoPickerScreen({super.key});

  @override
  State<CollagePhotoPickerScreen> createState() =>
      _CollagePhotoPickerScreenState();
}

class _CollagePhotoPickerScreenState extends State<CollagePhotoPickerScreen> {
  final Set<String> _selected = {};
  int _tab = 0;

  static const _images = [
    'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1494905998402-395d579af36f?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1541961017774-22349e4a1262?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1490750967868-88aa4486c946?auto=format&fit=crop&w=800&q=85',
  ];

  @override
  Widget build(BuildContext context) {
    final images = _tab == 0 ? _images : _images.reversed.toList();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 18),
              decoration: const BoxDecoration(
                color: Color(0xFF20211D),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Select up to 10 photos.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton.filled(
                        onPressed: () => Navigator.of(context).pop(),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF3E3F3A),
                        ),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 56,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2B27),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFF4B4C46)),
                        ),
                        child: Row(
                          children: [
                            _Segment(
                              label: 'Photos',
                              selected: _tab == 0,
                              onTap: () => setState(() => _tab = 0),
                            ),
                            _Segment(
                              label: 'Collections',
                              selected: _tab == 1,
                              onTap: () => setState(() => _tab = 1),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton.filled(
                        onPressed: () =>
                            Navigator.of(context).pop(_selected.toList()),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF4A4B45),
                        ),
                        icon: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 90),
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final image = images[index];
                  final selected = _selected.contains(image);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selected.remove(image);
                        } else if (_selected.length < 10) {
                          _selected.add(image);
                        }
                      });
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PinterestCachedImage(
                          imageUrl: image,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        if (selected)
                          Container(
                            color: Colors.black.withValues(alpha: 0.35),
                          ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 27,
                            height: 27,
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFE60023)
                                  : Colors.black.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white),
                            ),
                            child: selected
                                ? const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 86,
        color: Colors.black.withValues(alpha: 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              IconButton.filled(
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF4A4B45),
                ),
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
              ),
              const Spacer(),
              const Text(
                'Select Photos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              IconButton.filled(
                onPressed: () => _showSearch(context),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF4A4B45),
                ),
                icon: const Icon(Icons.search_rounded, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF20211D),
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          22,
          0,
          22,
          22 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Search photos'),
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
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
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4A4B45) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
