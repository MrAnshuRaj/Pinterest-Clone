import 'package:flutter/material.dart';

class TagTopicsScreen extends StatefulWidget {
  const TagTopicsScreen({super.key, this.initialSelected = const []});

  final List<String> initialSelected;

  @override
  State<TagTopicsScreen> createState() => _TagTopicsScreenState();
}

class _TagTopicsScreenState extends State<TagTopicsScreen> {
  final _controller = TextEditingController(text: 'Gift');
  late final Set<String> _selected = {...widget.initialSelected};

  static const _giftTopics = [
    'Gift Box',
    'Gift Basket',
    'Christmas Gift Ideas',
    'Gift Cards',
    'Gift Guide',
    'Gift Ideas For Men',
    'Teacher Appreciation Gifts',
    'Gift Bag',
    'Gift Tags',
    'Gift Packaging',
    'Gift For Brother',
    'Gifts For Him',
    'Gift Card Holder',
    'DIY Gifts',
    'Gift Box Template',
    'Gifts For Dad',
    'Valentine Gifts',
    'DIY Gift Box',
    'Gifts For Friends',
  ];

  static const _wrapTopics = [
    'Wrap Dress',
    'Wrap Skirt',
    'Wrap Around Porch',
    'Wrap Bracelet',
    'Lettuce Wrap Recipes',
    'Plastic Wrap',
    'Christmas Gift Wrapping',
    'Head Wraps',
    'DIY Wrap Bracelet',
    'Tortilla Wraps',
    'Bacon Wrapped',
    'Leather Wrap Bracelet',
    'Wire Wrap Jewelry',
    'Veggie Wraps',
    'Gift Wraps',
    'African Head Wraps',
    'Sandwich Wraps',
    'Creative Gift Wraps',
    'Wire Wrapping Tutorial',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> get _topics {
    final query = _controller.text.toLowerCase();
    final base = query.contains('wrap') ? _wrapTopics : _giftTopics;
    if (query.trim().isEmpty) return base;
    return base
        .where((topic) => topic.toLowerCase().contains(query.trim()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 74,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Tag topics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilledButton(
                      onPressed: _selected.isEmpty
                          ? null
                          : () => Navigator.of(context).pop(_selected.toList()),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE60023),
                        disabledBackgroundColor: const Color(0xFF4A4B45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 18),
                children: [
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.4,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1.6,
                        ),
                      ),
                    ),
                  ),
                  if (_selected.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Selected',
                      style: TextStyle(color: Color(0xFF9F9F9F), fontSize: 20),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final topic in _selected)
                          _TopicChip(
                            label: topic,
                            selected: true,
                            onTap: () =>
                                setState(() => _selected.remove(topic)),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 34),
                  Wrap(
                    spacing: 6,
                    runSpacing: 8,
                    children: [
                      for (final topic in _topics)
                        _TopicChip(
                          label: topic,
                          selected: _selected.contains(topic),
                          onTap: () {
                            setState(() {
                              _selected.contains(topic)
                                  ? _selected.remove(topic)
                                  : _selected.add(topic);
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      backgroundColor: selected
          ? const Color(0xFFE6E6E6)
          : const Color(0xFF4A4B45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
