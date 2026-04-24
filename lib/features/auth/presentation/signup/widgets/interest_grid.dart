import 'package:flutter/material.dart';

class InterestItem {
  const InterestItem({
    required this.title,
    required this.imageUrl,
    required this.accentColor,
  });

  final String title;
  final String imageUrl;
  final Color accentColor;
}

class InterestGrid extends StatelessWidget {
  const InterestGrid({
    super.key,
    required this.items,
    required this.selectedTitles,
    required this.onToggle,
  });

  final List<InterestItem> items;
  final Set<String> selectedTitles;
  final ValueChanged<InterestItem> onToggle;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedTitles.contains(item.title);

        return _InterestTile(
          item: item,
          isSelected: isSelected,
          onTap: () => onToggle(item),
        );
      },
    );
  }
}

class _InterestTile extends StatelessWidget {
  const _InterestTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final InterestItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 6,
                    right: -2,
                    top: 6,
                    bottom: -2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: item.accentColor.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFE60023)
                              : Colors.transparent,
                          width: 2.2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Color(0xFF1A1A1A),
                              ),
                              child: Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }

                                      return const ColoredBox(
                                        color: Color(0xFF1A1A1A),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const ColoredBox(
                                    color: Color(0xFF2A2A2A),
                                  );
                                },
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              color: isSelected
                                  ? const Color(
                                      0xFFE60023,
                                    ).withValues(alpha: 0.18)
                                  : Colors.transparent,
                            ),
                            if (isSelected)
                              const Positioned(
                                top: 10,
                                right: 10,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Color(0xFFE60023),
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.08,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
