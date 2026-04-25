import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../home/data/models/pin_model.dart';
import '../../../home/data/repositories/pin_repository.dart';
import 'widgets/collage_bottom_toolbar.dart';
import 'widgets/collage_canvas.dart';
import 'widgets/collage_options_sheet.dart';
import 'widgets/collage_tools_sheet.dart';

enum _CollageMode { normal, text, draw }

class CollageEditorScreen extends ConsumerStatefulWidget {
  const CollageEditorScreen({super.key});

  @override
  ConsumerState<CollageEditorScreen> createState() =>
      _CollageEditorScreenState();
}

class _CollageEditorScreenState extends ConsumerState<CollageEditorScreen> {
  final _textController = TextEditingController();
  final List<List<Offset>> _strokes = [];
  final List<Offset> _currentStroke = [];
  final List<CollageTextItem> _textItems = [];
  _CollageMode _mode = _CollageMode.normal;
  String? _selectedId;
  double _fontSize = 34;
  Color _textColor = const Color(0xFF777777);

  late List<CollageItem> _items = const [
    CollageItem(
      id: 'mountain',
      imageUrl:
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=900&q=85',
      dx: 36,
      dy: 50,
      width: 330,
      height: 280,
    ),
    CollageItem(
      id: 'person',
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=700&q=85',
      dx: 78,
      dy: 252,
      width: 210,
      height: 240,
    ),
    CollageItem(
      id: 'beach',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=900&q=85',
      dx: 190,
      dy: 404,
      width: 320,
      height: 250,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _moveItem(String id, Offset delta) {
    setState(() {
      _selectedId = id;
      _items = [
        for (final item in _items)
          if (item.id == id)
            item.copyWith(
              dx: (item.dx + delta.dx).clamp(0, 430),
              dy: (item.dy + delta.dy).clamp(0, 660),
            )
          else
            item,
      ];
    });
  }

  Future<void> _openPhotos() async {
    final photos = await context.push<List<String>>('/create/collage/photos');
    if (photos == null || photos.isEmpty) return;
    setState(() {
      for (final image in photos.take(10)) {
        _items = [
          ..._items,
          CollageItem(
            id: 'photo-${DateTime.now().microsecondsSinceEpoch}-$image',
            imageUrl: image,
            dx: 60 + (_items.length * 18) % 180,
            dy: 80 + (_items.length * 28) % 300,
            width: 190,
            height: 210,
          ),
        ];
      }
    });
  }

  void _showTools() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CollageToolsSheet(
        onDraw: () => setState(() => _mode = _CollageMode.draw),
        onText: () => setState(() => _mode = _CollageMode.text),
        onPhotos: _openPhotos,
        onLayers: _showLayers,
        onLayouts: _applyLayout,
      ),
    );
  }

  void _showOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CollageOptionsSheet(
        onSaveDraft: _saveDraft,
        onStartNew: () => setState(() {
          _items = [];
          _textItems.clear();
          _strokes.clear();
        }),
        onDuplicate: () => setState(() {
          _items = [
            ..._items,
            for (final item in _items)
              item.copyWith(dx: item.dx + 18, dy: item.dy + 18),
          ];
        }),
      ),
    );
  }

  void _saveDraft() {
    ref.read(draftCollagesProvider.notifier).add(_collage(isDraft: true));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved as draft')));
  }

  CreatedCollage _collage({
    bool isDraft = false,
    String title = 'Untitled collage',
  }) {
    return CreatedCollage(
      id: 'collage-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      description: '',
      imageUrls: _items.isEmpty
          ? const [
              'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=900&q=85',
            ]
          : _items.map((item) => item.imageUrl).toList(),
      createdAt: DateTime.now(),
      isDraft: isDraft,
    );
  }

  void _showLayers() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF20211D),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in _items)
              ListTile(
                leading: const Icon(Icons.layers_outlined, color: Colors.white),
                title: Text(
                  item.id,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _applyLayout() {
    setState(() {
      _items = [
        for (var i = 0; i < _items.length; i++)
          _items[i].copyWith(
            dx: 40.0 + (i % 2) * 210,
            dy: 50.0 + (i ~/ 2) * 230,
            width: 190,
            height: 210,
          ),
      ];
    });
  }

  void _finishText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _textItems.add(
        CollageTextItem(
          text: text,
          offset: const Offset(96, 300),
          fontSize: _fontSize,
          color: _textColor == const Color(0xFF777777)
              ? Colors.black
              : _textColor,
        ),
      );
      _textController.clear();
      _mode = _CollageMode.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isText = _mode == _CollageMode.text;
    final isDraw = _mode == _CollageMode.draw;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 12, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => isText || isDraw
                        ? setState(() => _mode = _CollageMode.normal)
                        : context.pop(),
                    icon: Icon(
                      isText ? Icons.close_rounded : Icons.close_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  if (!isText) ...[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.undo_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.redo_rounded,
                        color: Color(0xFF555555),
                        size: 34,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _showOptions,
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => context.push(
                        '/create/collage/publish',
                        extra: _collage(),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE60023),
                        fixedSize: const Size(94, 62),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ] else ...[
                    const Spacer(),
                    FilledButton(
                      onPressed: _textController.text.trim().isEmpty
                          ? null
                          : _finishText,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF4A4B45),
                        disabledBackgroundColor: const Color(0xFF4A4B45),
                      ),
                      child: const Text('Done'),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: GestureDetector(
                  onPanStart: isDraw
                      ? (details) => setState(
                          () => _currentStroke.add(details.localPosition),
                        )
                      : null,
                  onPanUpdate: isDraw
                      ? (details) => setState(
                          () => _currentStroke.add(details.localPosition),
                        )
                      : null,
                  onPanEnd: isDraw
                      ? (_) => setState(() {
                          _strokes.add([..._currentStroke]);
                          _currentStroke.clear();
                        })
                      : null,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CollageCanvas(
                          items: _items,
                          selectedId: _selectedId,
                          onSelect: (id) => setState(() => _selectedId = id),
                          onMove: _moveItem,
                          strokes: _strokes,
                          currentStroke: _currentStroke,
                          textItems: _textItems,
                          previewText: isText
                              ? CollageTextItem(
                                  text: _textController.text,
                                  offset: Offset.zero,
                                  fontSize: _fontSize,
                                  color: _textColor,
                                )
                              : null,
                        ),
                      ),
                      if (isText)
                        Positioned(
                          right: -8,
                          top: 100,
                          bottom: 100,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                              value: _fontSize,
                              min: 24,
                              max: 72,
                              activeColor: Colors.white,
                              inactiveColor: const Color(0xFF4A4B45),
                              onChanged: (value) =>
                                  setState(() => _fontSize = value),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (isText)
              _TextModeBar(
                controller: _textController,
                onColor: _cycleTextColor,
              )
            else if (isDraw)
              _DrawModeBar(
                onDone: () => setState(() => _mode = _CollageMode.normal),
              )
            else
              CollageBottomToolbar(
                onDraw: () => setState(() => _mode = _CollageMode.draw),
                onText: () => setState(() => _mode = _CollageMode.text),
                onAdd: _showTools,
                onPhotos: _openPhotos,
                onTools: _showTools,
              ),
          ],
        ),
      ),
    );
  }

  void _cycleTextColor() {
    const colors = [
      Color(0xFF777777),
      Colors.black,
      Color(0xFFE60023),
      Color(0xFF1A73E8),
    ];
    final index = colors.indexOf(_textColor);
    setState(() => _textColor = colors[(index + 1) % colors.length]);
  }
}

class _TextModeBar extends StatelessWidget {
  const _TextModeBar({required this.controller, required this.onColor});

  final TextEditingController controller;
  final VoidCallback onColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              InkWell(
                onTap: onColor,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const Icon(
                Icons.crop_square_rounded,
                color: Colors.white,
                size: 32,
              ),
              const Icon(
                Icons.format_align_center_rounded,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 1,
          child: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.transparent),
            cursorColor: Colors.transparent,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}

class _DrawModeBar extends StatelessWidget {
  const _DrawModeBar({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      color: const Color(0xFF181818),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final icon in const [
              Icons.edit_rounded,
              Icons.border_color_rounded,
              Icons.highlight_rounded,
              Icons.cleaning_services_rounded,
              Icons.brush_rounded,
              Icons.straighten_rounded,
              Icons.color_lens_rounded,
            ])
              Icon(icon, color: Colors.white, size: 34),
            TextButton(onPressed: onDone, child: const Text('Done')),
          ],
        ),
      ),
    );
  }
}
