import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/inbox_providers.dart';
import '../data/models/inbox_update_model.dart';
import '../../profile/presentation/settings/settings_widgets.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key, required this.onBrowseHome});

  final VoidCallback onBrowseHome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatesAsync = ref.watch(inboxUpdatesProvider);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 30, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Inbox',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showCompose(context),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Messages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A4B45),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Invite your friends',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 44),
            const Text(
              'Updates',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: updatesAsync.when(
                data: (updates) {
                  if (updates.isEmpty) {
                    return _InboxEmptyState(
                      onBrowseHome: onBrowseHome,
                    );
                  }
                  return ListView(
                    children: [
                      for (final update in updates)
                        _UpdateRow(
                          update: update,
                          onTap: () async {
                            await ref
                                .read(inboxControllerProvider)
                                .markRead(update.id);
                            if (!context.mounted) return;
                            if (update.type == 'search') {
                              context.push('/search');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Update opened')),
                              );
                            }
                          },
                        ),
                    ],
                  );
                },
                loading: () => const PinterestStatusView(
                  message: 'Loading your inbox...',
                  showSpinner: true,
                ),
                error: (error, stackTrace) => _InboxEmptyState(
                  onBrowseHome: onBrowseHome,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompose(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ComposeSheet(),
    );
  }
}

class _InboxEmptyState extends StatelessWidget {
  const _InboxEmptyState({required this.onBrowseHome});

  final VoidCallback onBrowseHome;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _InboxEmptyIllustration(),
            const SizedBox(height: 26),
            const Text(
              'Updates are on their way',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: const Text(
                'Use updates to see activity on your Pins and boards and get tips on topics to explore. They\'ll be here soon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onBrowseHome,
              style: pinterestButtonStyle(),
              child: const Text('Browse home feed'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InboxEmptyIllustration extends StatelessWidget {
  const _InboxEmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFB8338D),
                  Color(0xFF6F1E63),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            child: Container(
              width: 100,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFEA3B55),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 14),
                  width: 52,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC74A9B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 72,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LensShell(
                  mirror: false,
                  colors: const [Color(0xFFFFC76B), Color(0xFFF65D44)],
                ),
                Container(
                  width: 22,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8F57),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                _LensShell(
                  mirror: true,
                  colors: const [Color(0xFFFFC76B), Color(0xFFF65D44)],
                ),
              ],
            ),
          ),
          Positioned(
            top: 126,
            child: Container(
              width: 126,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF8D2E71),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LensShell extends StatelessWidget {
  const _LensShell({required this.mirror, required this.colors});

  final bool mirror;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(26),
      topRight: const Radius.circular(26),
      bottomLeft: Radius.circular(mirror ? 26 : 18),
      bottomRight: Radius.circular(mirror ? 18 : 26),
    );

    return Container(
      width: 74,
      height: 62,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7B45),
        borderRadius: radius,
        border: Border.all(
          color: const Color(0xFFFFA84A),
          width: 2.5,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 6,
              right: 6,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdateRow extends ConsumerWidget {
  const _UpdateRow({required this.update, required this.onTap});

  final InboxUpdateModel update;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDE8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: update.type == 'search'
                  ? const Icon(
                      Icons.search_rounded,
                      color: Colors.black,
                      size: 42,
                    )
                  : const Center(
                      child: Text(
                        'UPDATE',
                        style: TextStyle(
                          color: Color(0xFF777777),
                          fontSize: 8,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      update.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        height: 1.12,
                      ),
                    ),
                    if (update.subtitle?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          update.subtitle!,
                          style: const TextStyle(
                            color: pinterestTextGrey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  formatRelativeDate(update.createdAt),
                  style: const TextStyle(
                    color: Color(0xFFB5B5B5),
                    fontSize: 15,
                  ),
                ),
                IconButton(
                  onPressed: () => _showUpdateOptions(context, ref),
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF20211D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () async {
                  await ref.read(inboxControllerProvider).hideUpdate(update.id);
                  if (context.mounted) Navigator.of(context).pop();
                },
                title: const Text(
                  'Hide update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () => Navigator.of(context).pop(),
                title: const Text(
                  'Turn off similar updates',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () => Navigator.of(context).pop(),
                title: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ComposeSheet extends StatefulWidget {
  const _ComposeSheet();

  @override
  State<_ComposeSheet> createState() => _ComposeSheetState();
}

class _ComposeSheetState extends State<_ComposeSheet> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    const contacts = ['Ananya', 'Meera', 'Rohan', 'Pinterest Study Group'];
    return Container(
      padding: EdgeInsets.fromLTRB(
        22,
        16,
        22,
        22 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF20211D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'New message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: _selected == null
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE60023),
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by name or email',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 14),
            for (final contact in contacts)
              ListTile(
                onTap: () => setState(() => _selected = contact),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF4A4B45),
                  child: Text(
                    contact[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  contact,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: _selected == contact
                    ? const Icon(Icons.check_rounded, color: Colors.white)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
