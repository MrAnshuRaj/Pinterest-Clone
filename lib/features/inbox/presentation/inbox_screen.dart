import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key, required this.onBrowseHome});

  final VoidCallback onBrowseHome;

  @override
  Widget build(BuildContext context) {
    const updates = [
      _InboxUpdate(
        title: 'A beautiful life is your calling',
        time: '5h',
        type: _InboxUpdateType.image,
      ),
      _InboxUpdate(
        title: 'Still searching? Explore ideas related to Travel',
        time: '1d',
        type: _InboxUpdateType.search,
      ),
    ];

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
            for (final update in updates)
              _UpdateRow(
                update: update,
                onTap: update.type == _InboxUpdateType.search
                    ? () => context.push('/search/results/Travel')
                    : () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Update opened')),
                        ),
              ),
            const Spacer(),
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

enum _InboxUpdateType { image, search }

class _InboxUpdate {
  const _InboxUpdate({
    required this.title,
    required this.time,
    required this.type,
  });

  final String title;
  final String time;
  final _InboxUpdateType type;
}

class _UpdateRow extends StatelessWidget {
  const _UpdateRow({required this.update, required this.onTap});

  final _InboxUpdate update;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
              child: update.type == _InboxUpdateType.search
                  ? const Icon(
                      Icons.search_rounded,
                      color: Colors.black,
                      size: 42,
                    )
                  : const Center(
                      child: Text(
                        'FAMILY',
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
                child: Text(
                  update.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    height: 1.12,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  update.time,
                  style: const TextStyle(
                    color: Color(0xFFB5B5B5),
                    fontSize: 15,
                  ),
                ),
                IconButton(
                  onPressed: () => _showUpdateOptions(context),
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

  void _showUpdateOptions(BuildContext context) {
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
                onTap: () => Navigator.of(context).pop(),
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
