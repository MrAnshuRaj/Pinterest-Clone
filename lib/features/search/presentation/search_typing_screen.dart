import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/search_providers.dart';

class SearchTypingScreen extends ConsumerStatefulWidget {
  const SearchTypingScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  ConsumerState<SearchTypingScreen> createState() => _SearchTypingScreenState();
}

class _SearchTypingScreenState extends ConsumerState<SearchTypingScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    ref.read(searchHistoryProvider.notifier).record(query);
    context.go('/search/results/${Uri.encodeComponent(query)}');
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();
    final suggestions = ref.watch(searchSuggestionsProvider(query));

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
                itemCount: suggestions.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final label = query.isEmpty
                        ? 'Recommended for you'
                        : 'Suggestions';
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(26, 6, 26, 8),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Color(0xFF8F8F8F),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }

                  final suggestion = suggestions[index - 1];
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
