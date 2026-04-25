import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchTypingScreen extends StatefulWidget {
  const SearchTypingScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  State<SearchTypingScreen> createState() => _SearchTypingScreenState();
}

class _SearchTypingScreenState extends State<SearchTypingScreen> {
  late final TextEditingController _controller;

  static const _recentSearches = [
    'tattoo ideas',
    'home decor',
    'wallpapers',
    'outfits',
    'recipes',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? 'travel');
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> get _suggestions {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) return _recentSearches;

    if (query.startsWith('travel')) {
      return const [
        'travel',
        'travel aesthetic',
        'traveling aesthetic',
        'travel inspiration',
        'travel list',
        'travel pictures',
        'travel video',
        'travel checklist',
        'travel vision board',
      ];
    }

    return [
      query,
      '$query aesthetic',
      '$query ideas',
      '$query inspiration',
      '$query wallpaper',
      '$query outfit',
      '$query checklist',
    ];
  }

  void _submit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    context.go('/search/results/${Uri.encodeComponent(query)}');
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white, width: 1.4),
                      ),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _submit,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.fromLTRB(
                            20,
                            18,
                            6,
                            14,
                          ),
                          suffixIcon: query.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () => _controller.clear(),
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/search'),
                    child: const Text(
                      'Cancel',
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
            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(top: 8),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    onTap: () => _submit(suggestion),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 26),
                    minLeadingWidth: 36,
                    leading: const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: _SuggestionText(
                      suggestion: suggestion,
                      query: query,
                    ),
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

class _SuggestionText extends StatelessWidget {
  const _SuggestionText({required this.suggestion, required this.query});

  final String suggestion;
  final String query;

  @override
  Widget build(BuildContext context) {
    final normalized = query.toLowerCase();
    final lower = suggestion.toLowerCase();
    final splitIndex = normalized.isNotEmpty && lower.startsWith(normalized)
        ? query.length.clamp(0, suggestion.length)
        : 0;

    if (splitIndex == 0) {
      return Text(
        suggestion,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: suggestion.substring(0, splitIndex),
            style: const TextStyle(
              color: Color(0xFF8F8F8F),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: suggestion.substring(splitIndex),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      style: const TextStyle(fontSize: 25, height: 1.4),
    );
  }
}
