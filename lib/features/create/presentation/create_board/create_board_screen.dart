import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/profile/presentation/settings/settings_widgets.dart';
import '../../../../features/saved/application/saved_providers.dart';

class CreateBoardScreen extends ConsumerStatefulWidget {
  const CreateBoardScreen({super.key});

  @override
  ConsumerState<CreateBoardScreen> createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends ConsumerState<CreateBoardScreen> {
  final _nameController = TextEditingController();
  bool _isSecret = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = _nameController.text.trim().isNotEmpty;

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
                  child: const Text('Create Board'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createBoard() {
    final board = ref
        .read(boardsProvider.notifier)
        .create(name: _nameController.text, isSecret: _isSecret);
    context.go('/create/board/${board.id}/save-pins');
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
