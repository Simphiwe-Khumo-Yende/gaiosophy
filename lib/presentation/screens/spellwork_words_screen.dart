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
                        child: _buildContentWithIconsAndBoxes(contentBlock.data.content ?? ''),
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
