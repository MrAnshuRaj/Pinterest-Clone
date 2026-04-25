import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key, this.initialFilter = 'All Pins'});

  final String initialFilter;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late String _selected;

  static const _options = ['All Pins', 'Videos', 'Boards', 'Profiles'];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 72,
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
                            'Filter by',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                for (final option in _options)
                  InkWell(
                    onTap: () => setState(() => _selected = option),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(50, 9, 42, 9),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          _PinterestRadio(selected: _selected == option),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => setState(() => _selected = 'All Pins'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF4C4E49),
                      fixedSize: const Size(102, 66),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(_selected),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE60023),
                      fixedSize: const Size(102, 66),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

class _PinterestRadio extends StatelessWidget {
  const _PinterestRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? const Color(0xFF8091FF) : const Color(0xFFD8D8D8),
          width: selected ? 8 : 1.5,
        ),
      ),
      child: selected
          ? const Center(
              child: CircleAvatar(radius: 4.5, backgroundColor: Colors.black),
            )
          : null,
    );
  }
}
