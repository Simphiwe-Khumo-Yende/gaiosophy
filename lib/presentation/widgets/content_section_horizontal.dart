import 'package:flutter/material.dart';
import '../../application/providers/home_sections_provider.dart';
import '../theme/typography.dart';
import 'content_card.dart';

class ContentSectionHorizontal extends StatelessWidget {
  const ContentSectionHorizontal({super.key, required this.section});
  final HomeSection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title, 
                  style: context.primaryTitleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1612),
                  ),
                ),
                if (section.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      section.subtitle!,
                      style: context.secondaryBodySmall.copyWith(
                        color: const Color(0xFF1A1612).withValues(alpha: 0.7),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 170,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = section.items[index];
                return ContentCard(content: item);
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: section.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
