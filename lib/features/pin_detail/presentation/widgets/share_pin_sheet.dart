import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/widgets/pinterest_cached_image.dart';
import '../../../home/data/models/pin_model.dart';

class SharePinSheet extends StatelessWidget {
  const SharePinSheet({
    super.key,
    required this.pin,
    required this.relatedImages,
  });

  final PinModel pin;
  final List<String> relatedImages;

  void _share(BuildContext context, String label) {
    if (label == 'Copy link') {
      Clipboard.setData(
        ClipboardData(text: 'https://pinterest-clone.local/pin/${pin.id}'),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pin link copied')));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Sharing to $label')));
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      _ShareOption('Copy link', Icons.link_rounded, const Color(0xFF464742)),
      _ShareOption('WhatsApp', Icons.call_rounded, const Color(0xFF28D463)),
      _ShareOption(
        'Messages',
        Icons.chat_bubble_rounded,
        const Color(0xFF31D957),
      ),
      _ShareOption('Facebook', Icons.facebook_rounded, const Color(0xFF1877F2)),
      _ShareOption(
        'Email',
        Icons.mail_outline_rounded,
        Colors.white,
        darkIcon: true,
      ),
      _ShareOption('Telegram', Icons.send_rounded, const Color(0xFF2CA4DF)),
      _ShareOption(
        'Instagram',
        Icons.camera_alt_rounded,
        const Color(0xFFE1306C),
      ),
      _ShareOption(
        'More apps',
        Icons.more_horiz_rounded,
        const Color(0xFF464742),
      ),
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.74,
      minChildSize: 0.48,
      maxChildSize: 0.9,
      builder: (context, controller) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
            children: [
              Center(
                child: Container(
                  width: 58,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF777872),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                height: 520,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: -70,
                      top: 40,
                      bottom: 56,
                      child: SizedBox(
                        width: 180,
                        child: PinterestCachedImage(
                          imageUrl: relatedImages.isEmpty
                              ? pin.imageUrl
                              : relatedImages.first,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Container(
                      width: 355,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 1.4),
                      ),
                      child: PinterestCachedImage(
                        imageUrl: pin.imageUrl,
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                    Positioned(
                      right: 58,
                      bottom: 72,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C8CFF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.2),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 28,
                      child: Row(
                        children: List.generate(
                          5,
                          (index) => Container(
                            width: index == 0 ? 9 : 7,
                            height: index == 0 ? 9 : 7,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? Colors.white
                                  : const Color(0xFF5D5D5D),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFF292929)),
              const SizedBox(height: 18),
              const Text(
                'Share Pin link',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 22),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisExtent: 128,
                  crossAxisSpacing: 14,
                ),
                itemBuilder: (context, index) {
                  final option = options[index];
                  return InkWell(
                    onTap: () => _share(context, option.label),
                    borderRadius: BorderRadius.circular(18),
                    child: Column(
                      children: [
                        Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            color: option.color,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            option.icon,
                            color: option.darkIcon
                                ? Colors.black
                                : Colors.white,
                            size: 38,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          option.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShareOption {
  const _ShareOption(
    this.label,
    this.icon,
    this.color, {
    this.darkIcon = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool darkIcon;
}
