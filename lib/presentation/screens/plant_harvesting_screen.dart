import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;

class PlantHarvestingScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const PlantHarvestingScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFFFCF9F2),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF5A4E3C),
                ),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home, color: Color(0xFF5A4E3C)),
                  onPressed: () => context.go('/'),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Harvesting Guide',
                  style: const TextStyle(
                    color: Color(0xFF5A4E3C),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF8B6B47).withOpacity(0.3),
                        const Color(0xFFFCF9F2),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.agriculture,
                      size: 60,
                      color: Color(0xFF5A4E3C),
                    ),
                  ),
                ),
              ),
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Main Content
                    if (contentBlock.data.content != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5A4E3C).withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Html(
                          data: contentBlock.data.content,
                          style: {
                            "body": Style(
                              color: const Color(0xFF5A4E3C),
                              fontSize: FontSize(16),
                              lineHeight: const LineHeight(1.8),
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                            ),
                          },
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Harvesting Sections
                    _buildHarvestSection(
                      title: 'Best Times to Harvest',
                      icon: Icons.schedule,
                      items: [
                        HarvestInfo('Flowers/Berries', 'Peak growing season', 'When fully mature and at peak potency'),
                        HarvestInfo('Young Leaves', 'Spring (March-May)', 'Tender new growth for teas and preparations'),
                        HarvestInfo('Root Material', 'Autumn or early spring', 'When plant energy is concentrated in roots'),
                        HarvestInfo('Stems/Bark', 'Dormant season', 'For various traditional preparations'),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildHarvestSection(
                      title: 'Harvesting Tools & Safety',
                      icon: Icons.construction,
                      items: [
                        HarvestInfo('Protective gear', 'Essential protection', 'Gloves and appropriate clothing for safety'),
                        HarvestInfo('Long sleeves', 'Skin protection', 'Dense fabric to prevent scratches and irritation'),
                        HarvestInfo('Clean tools', 'Sterile harvesting', 'Sharp, clean tools for proper cuts'),
                        HarvestInfo('Collection containers', 'Gentle handling', 'Appropriate vessels for different plant parts'),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildHarvestSection(
                      title: 'Sustainable Practices',
                      icon: Icons.eco,
                      items: [
                        HarvestInfo('Leave plenty behind', 'Rule of thirds', 'Take only 1/3, leave 2/3 for wildlife'),
                        HarvestInfo('Rotate locations', 'Give plants rest', 'Don\'t harvest from same spot repeatedly'),
                        HarvestInfo('Thank the plant', 'Respectful practice', 'Acknowledge the gift you\'re receiving'),
                        HarvestInfo('Give back', 'Reciprocity', 'Leave water, compost, or other gifts'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHarvestSection({
    required String title,
    required IconData icon,
    required List<HarvestInfo> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF8B6B47).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B6B47).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A4E3C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF5A4E3C),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF5A4E3C),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...items.map((item) => _buildHarvestItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildHarvestItem(HarvestInfo info) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5A4E3C).withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF8B6B47).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.nature,
              color: Color(0xFF5A4E3C),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.item,
                  style: const TextStyle(
                    color: Color(0xFF5A4E3C),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info.timing,
                  style: TextStyle(
                    color: const Color(0xFF5A4E3C).withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  info.description,
                  style: TextStyle(
                    color: const Color(0xFF5A4E3C).withOpacity(0.7),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HarvestInfo {
  final String item;
  final String timing;
  final String description;

  HarvestInfo(this.item, this.timing, this.description);
}
