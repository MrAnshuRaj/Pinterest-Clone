import 'package:flutter/material.dart';

class TagTopicsScreen extends StatefulWidget {
  const TagTopicsScreen({super.key, this.initialSelected = const []});

  final List<String> initialSelected;

  @override
  State<TagTopicsScreen> createState() => _TagTopicsScreenState();
}

class _TagTopicsScreenState extends State<TagTopicsScreen> {
  final _controller = TextEditingController();
  late final Set<String> _selected = {
    for (final topic in widget.initialSelected) _formatTopic(topic),
  };

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

  String get _query => _controller.text.trim();

  List<String> get _suggestedTopics {
    final query = _query;
    if (query.isEmpty) return const [];

    final rawCandidates = <String>[
      query,
      ...query
          .split(',')
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty),
      ...query
          .split(RegExp(r'[\s,/]+'))
          .map((part) => part.trim())
          .where((part) => part.length >= 3),
    ];

    final suggestions = <String>[];
    final seen = <String>{};
    for (final candidate in rawCandidates) {
      final formatted = _formatTopic(candidate);
      final key = formatted.toLowerCase();
      if (formatted.isEmpty || seen.contains(key) || _selected.contains(formatted)) {
        continue;
      }
      seen.add(key);
      suggestions.add(formatted);
    }
    return suggestions;
  }

  void _addTopic(String value) {
    final formatted = _formatTopic(value);
    if (formatted.isEmpty) return;

    setState(() {
      _selected.add(formatted);
      _controller.clear();
    });
  }

  String _formatTopic(String value) {
    final cleaned = value
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) return '';

    return cleaned
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) {
          final lower = word.toLowerCase();
          if (lower.length == 1) return lower.toUpperCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
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
                          : () => Navigator.of(
                              context,
                            ).pop(_selected.toList(growable: false)),
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
                    textInputAction: TextInputAction.done,
                    onSubmitted: _addTopic,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Type a topic and press done',
                      hintStyle: const TextStyle(color: Color(0xFF8C8C8C)),
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
                  if (_query.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    FilledButton.tonal(
                      onPressed: () => _addTopic(_query),
                      style: FilledButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        backgroundColor: const Color(0xFF20211D),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text('Add "${_formatTopic(_query)}"'),
                    ),
                  ],
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
                  const SizedBox(height: 28),
                  if (_suggestedTopics.isNotEmpty) ...[
                    const Text(
                      'Suggestions',
                      style: TextStyle(color: Color(0xFF9F9F9F), fontSize: 20),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      children: [
                        for (final topic in _suggestedTopics)
                          _TopicChip(
                            label: topic,
                            selected: false,
                            onTap: () => _addTopic(topic),
                          ),
                      ],
                    ),
                  ] else if (_selected.isEmpty && _query.isEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Text(
                        'Start typing to create your own topics.',
                        style: TextStyle(
                          color: Color(0xFF9F9F9F),
                          fontSize: 18,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
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
