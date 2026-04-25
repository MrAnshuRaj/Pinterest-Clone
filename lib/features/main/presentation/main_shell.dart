import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../create/presentation/create_entry_sheet.dart';
import '../../home/presentation/home_screen.dart';
import '../../inbox/presentation/inbox_screen.dart';
import '../../saved/presentation/saved_screen.dart';
import '../../search/presentation/search_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0, this.searchChild});

  final int initialIndex;
  final Widget? searchChild;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant MainShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _index = widget.initialIndex;
    }
  }

  void _selectTab(int value) {
    if (value == 2) {
      CreateEntrySheet.show(context);
      return;
    }
    if (widget.searchChild != null && value == 1) {
      context.go('/search');
      return;
    }
    if (widget.searchChild != null && value == 0) {
      context.go('/home');
      return;
    }
    setState(() {
      _index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      widget.searchChild ?? const SearchScreen(),
      const SizedBox.shrink(),
      InboxScreen(onBrowseHome: () => setState(() => _index = 0)),
      const SavedScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 72,
          decoration: const BoxDecoration(color: Colors.black),
          child: Row(
            children: [
              _NavItem(
                label: 'Home',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                selected: _index == 0,
                onTap: () => _selectTab(0),
              ),
              _NavItem(
                label: 'Search',
                icon: Icons.search_rounded,
                selectedIcon: Icons.search_rounded,
                selected: _index == 1,
                onTap: () => _selectTab(1),
              ),
              _NavItem(
                label: 'Create',
                icon: Icons.add_rounded,
                selectedIcon: Icons.add_rounded,
                selected: false,
                onTap: () => _selectTab(2),
              ),
              _NavItem(
                label: 'Inbox',
                icon: Icons.chat_bubble_outline_rounded,
                selectedIcon: Icons.mark_chat_unread_rounded,
                selected: _index == 3,
                onTap: () => _selectTab(3),
              ),
              _NavItem(
                label: 'Saved',
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                selected: _index == 4,
                onTap: () => _selectTab(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 68,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? selectedIcon : icon,
                size: selected ? 31 : 30,
                color: Colors.white,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
