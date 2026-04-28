import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/pinterest_cached_image.dart';
import '../../../auth/application/auth_providers.dart';
import '../../data/models/created_pin_model.dart';
import '../../../home/data/models/pin_model.dart';
import '../../../profile/application/profile_providers.dart';
import '../../../saved/application/saved_providers.dart';

class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({super.key});

  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();
  String? _boardId;
  String _boardLabel = 'Profile';
  String _imageUrl =
      'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=800&q=85';
  List<String> _topics = const [];
  bool _isSubmitting = false;

  static const _mockImages = [
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1523906834658-6e24ef2386f9?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=85',
    'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=800&q=85',
  ];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  bool get _canCreate =>
      _titleController.text.trim().isNotEmpty && !_isSubmitting;

  Future<void> _createPin() async {
    if (!_canCreate) return;

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be signed in before creating a Pin.'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    final profile = ref.read(profileProvider);
    final pinId = 'created-${DateTime.now().microsecondsSinceEpoch}';
    final createdPin = CreatedPinModel(
      id: pinId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      link: _linkController.text.trim(),
      imageUrl: _imageUrl,
      boardId: _boardId,
      topics: _topics,
      altText: '',
      allowComments: true,
      showSimilarProducts: true,
      createdAt: DateTime.now(),
    );
    final pin = PinModel(
      id: pinId,
      title: createdPin.title,
      imageUrl: _imageUrl,
      author: profile.name.isEmpty ? 'Profile' : profile.name,
      description: createdPin.description,
      likes: 0,
      comments: 0,
      category: _topics.isEmpty ? 'created' : _topics.first.toLowerCase(),
      isAiModified: false,
      heightRatio: 1.22,
    );

    try {
      final controller = ref.read(savedContentControllerProvider);
      await controller.createPin(createdPin);
      await controller.savePin(pin);
      if (_boardId != null) {
        await controller.addPinsToBoard(_boardId!, [pin]);
      }

      ref.read(savedTabProvider.notifier).state = 0;
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pin created')));
      context.go('/saved');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not create Pin right now. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _openTopics() async {
    final result = await context.push<List<String>>(
      '/create/pin/topics',
      extra: _topics,
    );
    if (result != null) {
      setState(() => _topics = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 72,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Create Pin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 120),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 220,
                          height: 124,
                          child: PinterestCachedImage(imageUrl: _imageUrl),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: IconButton.filled(
                            onPressed: _pickMockImage,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 72),
                  _LabeledField(
                    controller: _titleController,
                    label: 'Title',
                    hint: 'Tell everyone what your Pin is about',
                    maxLength: 100,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_titleController.text.length}/100',
                      style: const TextStyle(
                        color: Color(0xFF9F9F9F),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xFF262626), height: 28),
                  _LabeledField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint:
                        'Add a description, mention, or hashtags to your Pin.',
                    maxLines: 2,
                  ),
                  const Divider(color: Color(0xFF262626), height: 28),
                  _LabeledField(
                    controller: _linkController,
                    label: 'Link',
                    hint: '',
                  ),
                  const Divider(color: Color(0xFF262626), height: 30),
                  _CreateRow(
                    label: 'Pick a board',
                    value: _boardLabel,
                    onTap: _pickBoard,
                  ),
                  _CreateRow(
                    label: 'Tag related topics',
                    value: _topics.isEmpty
                        ? null
                        : _topics.take(2).join(', '),
                    onTap: _openTopics,
                  ),
                  _CreateRow(
                    label: 'Tag products',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product tagging is coming soon.'),
                      ),
                    ),
                  ),
                  _CreateRow(
                    label: 'Advanced settings',
                    onTap: () => context.push('/create/pin/advanced'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.black,
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              _SquareButton(icon: Icons.folder_outlined, onTap: _pickBoard),
              const SizedBox(width: 12),
              _SquareButton(
                icon: Icons.file_download_outlined,
                onTap: _pickMockImage,
              ),
              const Spacer(),
              FilledButton(
                onPressed: _canCreate ? _createPin : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE60023),
                  disabledBackgroundColor: const Color(0xFF4A4B45),
                  fixedSize: const Size(104, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.3,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickMockImage() {
    final currentIndex = _mockImages.indexOf(_imageUrl);
    setState(
      () => _imageUrl = _mockImages[(currentIndex + 1) % _mockImages.length],
    );
  }

  void _pickBoard() {
    final boards = ref.read(boardsListProvider);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF20211D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (boards.isEmpty)
                ListTile(
                  onTap: () {
                    setState(() {
                      _boardId = null;
                      _boardLabel = 'Profile';
                    });
                    Navigator.of(context).pop();
                  },
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  trailing: _boardId == null
                      ? const Icon(Icons.check_rounded, color: Colors.white)
                      : null,
                ),
              for (final board in boards)
                ListTile(
                  onTap: () {
                    setState(() {
                      _boardId = board.id;
                      _boardLabel = board.name;
                    });
                    Navigator.of(context).pop();
                  },
                  title: Text(
                    board.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  trailing: _boardId == board.id
                      ? const Icon(Icons.check_rounded, color: Colors.white)
                      : null,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLength,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int? maxLength;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          TextField(
            controller: controller,
            maxLength: maxLength,
            maxLines: maxLines,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            decoration: InputDecoration(
              hintText: hint,
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateRow extends StatelessWidget {
  const _CreateRow({required this.label, required this.onTap, this.value});

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          title: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null)
                Text(
                  value!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFF262626), height: 1),
      ],
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFF4A4B45),
        foregroundColor: Colors.white,
        fixedSize: const Size(66, 66),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      icon: Icon(icon, size: 32),
    );
  }
}
