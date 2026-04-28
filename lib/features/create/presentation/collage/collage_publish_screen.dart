import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/pinterest_cached_image.dart';
import '../../data/models/created_collage_model.dart';
import '../../../saved/application/saved_providers.dart';

class CollagePublishScreen extends ConsumerStatefulWidget {
  const CollagePublishScreen({super.key, required this.collage});

  final CreatedCollageModel collage;

  @override
  ConsumerState<CollagePublishScreen> createState() =>
      _CollagePublishScreenState();
}

class _CollagePublishScreenState extends ConsumerState<CollagePublishScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _altController = TextEditingController();
  bool _remixing = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _altController.dispose();
    super.dispose();
  }

  CreatedCollageModel _collage({bool draft = false}) {
    return CreatedCollageModel(
      id: widget.collage.id,
      title: _titleController.text.trim().isEmpty
          ? (draft ? 'Draft collage' : 'My collage')
          : _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrls: widget.collage.imageUrls,
      previewImageUrl: widget.collage.previewImageUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDraft: draft,
    );
  }

  Future<void> _saveDraft() async {
    await ref
        .read(savedContentControllerProvider)
        .saveCollageDraft(_collage(draft: true));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Collage saved for later')));
    context.go('/saved');
  }

  Future<void> _create() async {
    await ref.read(savedContentControllerProvider).createCollage(_collage());
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Collage created')));
    context.go('/saved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 150),
          children: [
            SizedBox(
              height: 74,
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
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 150,
                height: 260,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 92,
                        height: 132,
                        child: PinterestCachedImage(
                          imageUrl: widget.collage.imageUrls.first,
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 104,
                        height: 120,
                        child: PinterestCachedImage(
                          imageUrl: widget.collage.imageUrls.length > 1
                              ? widget.collage.imageUrls[1]
                              : widget.collage.imageUrls.first,
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 42),
            _PublishField(
              controller: _titleController,
              label: 'Title',
              hint: 'Add a title',
            ),
            const SizedBox(height: 28),
            _PublishField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Add a description',
            ),
            const SizedBox(height: 38),
            const Text(
              'Publish to',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A4B45),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white),
              ),
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Enable remixing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Switch(
                  value: _remixing,
                  onChanged: (value) => setState(() => _remixing = value),
                  activeTrackColor: const Color(0xFF6C7DFF),
                  activeThumbColor: Colors.white,
                ),
              ],
            ),
            const Text(
              'Let people use your collage as a starting point to create their own',
              style: TextStyle(
                color: Color(0xFFB5B5B5),
                fontSize: 17,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 36),
            _PublishField(
              controller: _altController,
              label: 'Alt text',
              hint: 'Describe your Pin’s visual details',
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.black,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _saveDraft,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF4A4B45),
                        fixedSize: const Size.fromHeight(66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Save for later',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: _create,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE60023),
                        fixedSize: const Size.fromHeight(66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Create',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Once you create, you won’t be able to make edits',
                style: TextStyle(color: Color(0xFF9F9F9F), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PublishField extends StatelessWidget {
  const _PublishField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 10, 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                TextField(
                  controller: controller,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}
