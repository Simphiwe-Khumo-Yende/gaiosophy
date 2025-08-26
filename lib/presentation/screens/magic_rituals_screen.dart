import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../data/models/content.dart' as content_model;

class MagicRitualsScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const MagicRitualsScreen({
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
            // Mystical Header
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFFFCF9F2),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF5A4E3C),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Magic & Rituals',
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
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        const Color(0xFF8B6B47).withOpacity(0.3),
                        const Color(0xFF5A4E3C).withOpacity(0.2),
                        const Color(0xFFFCF9F2),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_fix_high,
                      size: 70,
                      color: Color(0xFF5A4E3C),
                    ),
                  ),
                ),
              ),
            ),
            
            // Ritual Content
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
                    
                    // Ritual Categories
                    _buildRitualCategory(
                      title: 'Protection Rituals',
                      icon: Icons.security,
                      description: 'Use bramble thorns in protective spells and boundary work',
                      items: [
                        'Create protective circles with dried bramble canes',
                        'Burn bramble leaves for cleansing rituals',
                        'Carry a small bramble thorn for personal protection',
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildRitualCategory(
                      title: 'Abundance Magic',
                      icon: Icons.trending_up,
                      description: 'Harness the fertile energy of bramble for manifestation',
                      items: [
                        'Use bramble berries in prosperity spells',
                        'Plant brambles to attract abundance to your land',
                        'Create bramble berry ink for manifestation writing',
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildRitualCategory(
                      title: 'Seasonal Ceremonies',
                      icon: Icons.wb_sunny,
                      description: 'Connect with natural cycles through bramble rituals',
                      items: [
                        'Lammas berry blessing ceremonies',
                        'Autumn gratitude rituals with bramble fruit',
                        'Spring growth meditation with new bramble shoots',
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

  Widget _buildRitualCategory({
    required String title,
    required IconData icon,
    required String description,
    required List<String> items,
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
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: const Color(0xFF5A4E3C).withOpacity(0.8),
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A4E3C),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xFF5A4E3C),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
