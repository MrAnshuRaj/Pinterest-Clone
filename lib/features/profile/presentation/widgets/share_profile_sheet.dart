import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../saved/application/saved_providers.dart';
import '../../../../shared/widgets/pinterest_cached_image.dart';
import '../../application/profile_providers.dart';
import '../settings/settings_widgets.dart';

class ShareProfileSheet extends ConsumerWidget {
  const ShareProfileSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ShareProfileSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final boards = ref.watch(boardsProvider);
    final images = boards.isEmpty
        ? const [
            'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=600&q=85',
            'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?auto=format&fit=crop&w=600&q=85',
          ]
        : boards.first.coverImageUrls;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: pinterestGrey,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 240,
                height: 265,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 240,
                          height: 168,
                          child: Row(
                            children: [
                              Expanded(
                                child: PinterestCachedImage(
                                  imageUrl: images.isEmpty
                                      ? 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=600&q=85'
                                      : images.first,
                                ),
                              ),
                              Expanded(
                                child: PinterestCachedImage(
                                  imageUrl: images.length > 1
                                      ? images[1]
                                      : images.first,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 118,
                      child: PinterestAvatar(
                        initial: profile.avatarInitial,
                        radius: 44,
                        backgroundColor: const Color(0xFF2F49E8),
                      ),
                    ),
                    Positioned(
                      top: 174,
                      right: 60,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: pinterestGrey,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Text(
                        profile.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Color(0xFF303030)),
            const SizedBox(height: 18),
            const Text(
              'Share profile link',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.86,
              mainAxisSpacing: 14,
              crossAxisSpacing: 16,
              children: [
                _ShareOption(
                  label: 'Copy link',
                  icon: Icons.link_rounded,
                  color: pinterestGrey,
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(text: 'https://pinterest.clone/${profile.username}'),
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile link copied')),
                      );
                    }
                  },
                ),
                _ShareOption(label: 'WhatsApp', icon: Icons.chat_rounded, color: const Color(0xFF25D366), onTap: () => _snack(context)),
                _ShareOption(label: 'Messages', icon: Icons.chat_bubble_rounded, color: const Color(0xFF35D95D), onTap: () => _snack(context)),
                _ShareOption(label: 'Facebook', icon: Icons.facebook_rounded, color: const Color(0xFF1877F2), onTap: () => _snack(context)),
                _ShareOption(label: 'Email', icon: Icons.mail_outline_rounded, color: Colors.white, iconColor: Colors.black, onTap: () => _snack(context)),
                _ShareOption(label: 'Telegram', icon: Icons.send_rounded, color: const Color(0xFF2CA5E0), onTap: () => _snack(context)),
                _ShareOption(label: 'Instagram', icon: Icons.camera_alt_outlined, color: const Color(0xFFE1306C), onTap: () => _snack(context)),
                _ShareOption(label: 'More apps', icon: Icons.more_horiz_rounded, color: pinterestGrey, onTap: () => _snack(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing is a demo action')),
    );
  }
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: iconColor, size: 34),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
