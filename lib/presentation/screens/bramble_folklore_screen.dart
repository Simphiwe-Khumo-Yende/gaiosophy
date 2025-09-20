import 'package:flutter/material.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/enhanced_html_renderer.dart';

class BrambleFolkloreScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const BrambleFolkloreScreen({
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
              expandedHeight: 200,
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
                  'Folklore & Legends',
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
                        const Color(0xFF8B6B47).withOpacity(0.4),
                        const Color(0xFF5A4E3C).withOpacity(0.2),
                        const Color(0xFFFCF9F2),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_stories,
                      size: 60,
                      color: Color(0xFF5A4E3C),
                    ),
                  ),
                ),
              ),
            ),
            
            // Folklore Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Ancient Stories Card
                    _buildStoryCard(
                      title: 'Ancient Celtic Beliefs',
                      icon: Icons.history_edu,
                      content: contentBlock.data.content ?? 
                        'In Celtic tradition, brambles were considered sacred plants that bridged the world of the living and the spirit realm. The thorns were believed to protect against evil spirits, while the sweet berries represented the rewards that come after overcoming challenges.',
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Protection Lore Card
                    _buildStoryCard(
                      title: 'Protection & Boundaries',
                      icon: Icons.shield,
                      content: 'Brambles have long been planted around homes and sacred spaces as natural barriers. Folk wisdom teaches that these thorny guardians not only protect physical boundaries but also create energetic shields against negative influences.',
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Seasonal Wisdom Card
                    _buildStoryCard(
                      title: 'Seasonal Wisdom',
                      icon: Icons.calendar_today,
                      content: 'Traditional folklore connects brambles to the cycles of nature - from the tender spring growth representing new beginnings, to the summer flowers symbolizing abundance, and the autumn berries marking the time of harvest and gratitude.',
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

  Widget _buildStoryCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5A4E3C).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6B47).withOpacity(0.1),
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
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8B6B47).withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          EnhancedHtmlRenderer(
            content: content,
            iconSize: 20,
            iconColor: const Color(0xFF8B6B47),
            textStyle: const TextStyle(
              color: Color(0xFF5A4E3C),
              fontSize: 16,
              height: 1.8,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
