import 'package:flutter/material.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/content_box_parser.dart';
import '../theme/typography.dart';

class SpellworkWordsScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const SpellworkWordsScreen({
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
                  'Spellwork Words',
                  style: context.primaryFont(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF5A4E3C),
                  ),
                  textAlign: TextAlign.center,
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF8B6B47).withOpacity(0.4),
                        const Color(0xFFFCF9F2),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.menu_book,
                      size: 60,
                      color: Color(0xFF5A4E3C),
                    ),
                  ),
                ),
              ),
            ),
            
            // Spellwork Content
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
                        child: _buildContentWithIconsAndBoxes(contentBlock.data.content ?? ''),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Incantations Section
                    _buildSpellSection(
                      title: 'Protection Incantations',
                      icon: Icons.shield,
                      spells: [
                        SpellData(
                          name: 'Bramble Shield',
                          words: 'Thorns of protection, circle round,\nSafe within this sacred ground.\nBramble\'s power, strong and true,\nGuard me well in all I do.',
                          purpose: 'Personal protection and boundary setting',
                        ),
                        SpellData(
                          name: 'Guardian\'s Call',
                          words: 'Ancient bramble, hear my plea,\nProtect this space from harm to me.\nWith thorns of power, ward away,\nAll ill intent that comes this way.',
                          purpose: 'Space cleansing and protection',
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildSpellSection(
                      title: 'Abundance Chants',
                      icon: Icons.spa,
                      spells: [
                        SpellData(
                          name: 'Harvest Blessing',
                          words: 'Sweet bramble fruit, abundant grow,\nBlessing all with overflow.\nNature\'s bounty, rich and free,\nShare your gifts generously.',
                          purpose: 'Attracting abundance and prosperity',
                        ),
                        SpellData(
                          name: 'Growth Invocation',
                          words: 'From earth to sky, the bramble climbs,\nThrough seasons, weathers, changing times.\nLike bramble strong, may I grow too,\nIn wisdom, love, and purpose true.',
                          purpose: 'Personal growth and development',
                        ),
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

  Widget _buildSpellSection({
    required String title,
    required IconData icon,
    required List<SpellData> spells,
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
          ...spells.map((spell) => _buildSpellCard(spell)).toList(),
        ],
      ),
    );
  }

  Widget _buildSpellCard(SpellData spell) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spell.name,
            style: const TextStyle(
              color: Color(0xFF5A4E3C),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFCF9F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF8B6B47).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              spell.words,
              style: const TextStyle(
                color: Color(0xFF5A4E3C),
                fontSize: 16,
                height: 1.6,
                fontStyle: FontStyle.italic,
                fontFamily: 'serif',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Purpose: ${spell.purpose}',
            style: TextStyle(
              color: const Color(0xFF5A4E3C).withOpacity(0.7),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentWithIconsAndBoxes(String content) {
    return BoxedContentText(
      content,
      textStyle: const TextStyle(
        color: Color(0xFF5A4E3C),
        fontSize: 16,
        height: 1.8,
      ),
    );
  }
}

class SpellData {
  final String name;
  final String words;
  final String purpose;

  SpellData({
    required this.name,
    required this.words,
    required this.purpose,
  });
}
