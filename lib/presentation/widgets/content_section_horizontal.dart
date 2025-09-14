import 'package:flutter/material.dart';
import '../../application/providers/home_sections_provider.dart';
import '../../data/models/content.dart';
import '../theme/typography.dart';
import 'content_card.dart';
import 'plant_ally_card.dart';

class ContentSectionHorizontal extends StatelessWidget {
  const ContentSectionHorizontal({super.key, required this.section});
  final HomeSection section;

  @override
  Widget build(BuildContext context) {
    // Check if this is a plant allies section
    final isPlantSection = section.title.toLowerCase().contains('plant allies') ||
        section.items.every((item) => item.type == ContentType.plant);
    
    // Dynamic height based on section type
    // Plant cards have fixed height of 280px
    final sectionHeight = isPlantSection ? 290.0 : 200.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
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
                    fontSize: 18,
                  ),
                ),
                if (section.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      section.subtitle!,
                      style: context.secondaryBodySmall.copyWith(
                        color: const Color(0xFF5A5A5A),
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Horizontal scrolling list
          SizedBox(
            height: sectionHeight,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = section.items[index];
                // Use PlantAllyCard for plant sections
                if (isPlantSection) {
                  return PlantAllyCard(content: item);
                }
                return ContentCard(content: item);
              },
              separatorBuilder: (_, __) => SizedBox(
                width: isPlantSection ? 24 : 12,
              ),
              itemCount: section.items.length,
            ),
          ),
        ],
      ),
    );
  }
}