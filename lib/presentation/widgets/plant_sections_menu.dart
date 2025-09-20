import 'package:flutter/material.dart';
import '../../data/models/content.dart';
import '../theme/typography.dart';
import '../theme/app_theme.dart';

class PlantSectionsMenu extends StatelessWidget {
  const PlantSectionsMenu({
    super.key,
    required this.content,
    required this.onSectionSelected,
  });

  final Content content;
  final Function(String section) onSectionSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content.title),
        backgroundColor: const Color(0xFF228B22),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFCF9F2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant overview card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plant Guide',
                      style: context.primaryTitleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1612),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content.summary ?? 'Explore this plant\'s characteristics and uses.',
                      style: context.secondaryBodyMedium.copyWith(
                        color: const Color(0xFF1A1612).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Section cards
            _buildSectionCard(
              context,
              'overview',
              'Overview',
              'Learn about this plant\'s characteristics, habitat, and traditional uses.',
              Icons.info_outline,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              'parts',
              'Plant Parts',
              'Explore different parts: roots, leaves, flowers, and berries.',
              Icons.eco,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              'harvest',
              'Harvest',
              'Best times and methods for sustainable harvesting.',
              Icons.agriculture,
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              'folklore',
              'Folklore',
              'Stories and cultural significance of this plant.',
              Icons.menu_book,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    String section,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onSectionSelected(section),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6B47).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF8B6B47),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.plantProfileHeadingStyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTheme.plantProfileSubheadingStyle,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF8B6B47),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
