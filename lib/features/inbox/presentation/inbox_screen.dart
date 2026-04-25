import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key, required this.onBrowseHome});

  final VoidCallback onBrowseHome;

  @override
  Widget build(BuildContext context) {
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
            const Spacer(),
            Center(
              child: Column(
                children: [
                  const _SunglassesIllustration(),
                  const SizedBox(height: 28),
                  const Text(
                    'Updates are on their way',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      'Use updates to see activity on your Pins and boards and get tips on topics to explore. They’ll be here soon.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: onBrowseHome,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF4A4B45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      'Browse home feed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),
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

class _SunglassesIllustration extends StatelessWidget {
  const _SunglassesIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFC23886), Color(0xFF8F185E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: 54,
            child: Container(
              width: 170,
              height: 68,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFF9345), width: 12),
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2B8F80), Color(0xFFFFC06C)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 38,
            child: Container(
              width: 116,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6EB1),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
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
