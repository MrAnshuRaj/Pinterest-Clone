import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/profile/presentation/settings/settings_widgets.dart';
import '../../../../features/saved/application/saved_providers.dart';
import '../../../../features/saved/data/models/board_model.dart';
import '../create_debug_error.dart';

class CreateBoardScreen extends ConsumerStatefulWidget {
  const CreateBoardScreen({super.key});

  @override
  ConsumerState<CreateBoardScreen> createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends ConsumerState<CreateBoardScreen> {
  final _nameController = TextEditingController();
  bool _isSecret = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = _nameController.text.trim().isNotEmpty && !_isSubmitting;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            PinterestBackHeader(
              title: 'Create board',
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                child: Column(
                  children: [
                    const _BoardPlaceholder(),
                    const SizedBox(height: 44),
                    TextField(
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        labelText: 'Board name',
                        hintText: 'Name your board',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    _CreateBoardRow(
                      title: 'Make this board secret',
                      subtitle:
                          'Only you and collaborators will see this board',
                      trailing: Switch(
                        value: _isSecret,
                        activeThumbColor: Colors.white,
                        activeTrackColor: const Color(0xFF6265F6),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: pinterestGrey,
                        onChanged: (value) => setState(() => _isSecret = value),
                      ),
                    ),
                    const SizedBox(height: 26),
                    _CreateBoardRow(
                      title: 'Group board',
                      subtitle: 'Invite collaborators to join this board',
                      trailing: FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Collaborators can be invited later',
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: pinterestGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size(52, 52),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
              child: SizedBox(
                width: double.infinity,
                height: 66,
                child: FilledButton(
                  onPressed: canCreate ? _createBoard : null,
                  style: pinterestButtonStyle(
                    color: canCreate ? pinterestRed : pinterestGrey,
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
                      : const Text('Create Board'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createBoard() async {
    if (_isSubmitting) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    final now = DateTime.now();
    final boardId = now.millisecondsSinceEpoch.toString();
    try {
      ref
          .read(localSavedStoreProvider.notifier)
          .createBoard(
            BoardModel(
              id: boardId,
              name: _nameController.text.trim(),
              coverImageUrls: const [],
              pinIds: const [],
              isSecret: _isSecret,
              isGroupBoard: false,
              createdAt: now,
              updatedAt: now,
            ),
          );

      if (!mounted) return;

      context.go('/create/board/$boardId/save-pins');
    } catch (error) {
      if (!mounted) return;
      final path = 'local/in-memory/boards/$boardId';
      debugPrint('[create-board] error path=$path error=$error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          content: Text(
            formatCreateDebugError(
              error,
              operation: 'Create Board',
              path: path,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class _BoardPlaceholder extends StatelessWidget {
  const _BoardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 296,
        height: 166,
        child: Row(
          children: [
            Expanded(child: Container(color: const Color(0xFF4B4D47))),
            Container(width: 1, color: Colors.black),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: Container(color: const Color(0xFF4B4D47))),
                  Container(height: 1, color: Colors.black),
                  Expanded(child: Container(color: const Color(0xFF4B4D47))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateBoardRow extends StatelessWidget {
  const _CreateBoardRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: pinterestTextGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        trailing,
      ],
    );
  }
}
