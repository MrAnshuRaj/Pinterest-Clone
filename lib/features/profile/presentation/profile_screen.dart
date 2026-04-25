import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/clerk_config.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/data/services/clerk_auth_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _loggingOut = false;

  Future<void> _logout() async {
    if (_loggingOut) return;

    setState(() {
      _loggingOut = true;
    });

    try {
      if (!isClerkConfigured) {
        throw StateError(
          'Clerk is not configured. Run with --dart-define=CLERK_PUBLISHABLE_KEY=your_key_here.',
        );
      }

      final authState = ClerkAuth.of(context, listen: false);
      final service = ref.read(clerkAuthServiceProvider(authState));
      await service.signOut();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyClerkError(error))));
    } finally {
      if (mounted) {
        setState(() {
          _loggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isClerkConfigured) {
      return const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: Color(0xFF2A2A2A),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 46,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your Pinterest',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Clerk is not configured',
                style: TextStyle(
                  color: Color(0xFFB8B8B8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final authState = ClerkAuth.of(context);
    final user = ref.watch(currentUserProvider(authState));
    final email = user?.email ?? 'Signed in';
    final name = [
      user?.firstName,
      user?.lastName,
    ].whereType<String>().where((part) => part.trim().isNotEmpty).join(' ');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: const Color(0xFF2A2A2A),
              backgroundImage: user?.profileImageUrl == null
                  ? null
                  : NetworkImage(user!.profileImageUrl!),
              child: user?.profileImageUrl == null
                  ? const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 46,
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              name.isEmpty ? 'Your Pinterest' : name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              email,
              style: const TextStyle(
                color: Color(0xFFB8B8B8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _loggingOut ? null : _logout,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4C4E49),
                  disabledBackgroundColor: const Color(0xFF353535),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  _loggingOut ? 'Signing out...' : 'Log out',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
