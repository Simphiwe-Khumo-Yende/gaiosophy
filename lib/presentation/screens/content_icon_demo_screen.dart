import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/typography.dart';
import '../widgets/rich_content_text.dart';
import '../widgets/content_icon_mapper.dart';

class ContentIconDemoScreen extends StatelessWidget {
  const ContentIconDemoScreen({super.key});

  static const List<Map<String, String>> sampleContent = [
    {
      'title': 'Morning Herb Collection',
      'content': '[morning] Upon sunrise, venture into the [forest] to collect [herb] specimens. Look for [leaf] patterns that indicate [medicinal] properties. Always ensure plants are [safe] before harvesting.',
    },
    {
      'title': 'Seasonal Foraging Guide',
      'content': '[spring] brings fresh [growth] in [meadow] areas. [summer] offers abundant [fruit] and [berry] collection. [autumn] is perfect for [root] gathering, while [winter] requires careful [bark] harvesting.',
    },
    {
      'title': 'Box Section Demo - Recipe with Ingredients',
      'content': 'This recipe combines traditional wisdom with modern preparation methods.\n\n[box-start]\n[herb] Chamomile flowers - 2 tablespoons\n[leaf] Peppermint leaves - 1 tablespoon\n[water] Filtered water - 2 cups\n[honey] Raw honey - to taste (optional)\n[box-end]\n\n[tea] Steep the [herb] mixture in hot [water] for 5-8 minutes. This [healing] blend is perfect for [evening] relaxation and [digestive] support.',
    },
    {
      'title': 'Box Section Demo - Safety Instructions',
      'content': 'General foraging guidelines for [safe] plant collection.\n\n[box-start]\n[caution] Never consume unidentified plants\n[research] Always cross-reference multiple sources\n[guide] Bring a field identification guide\n[camera] Take photos for later verification\n[expert] Consult with experienced foragers\n[box-end]\n\nFollowing these [safety] protocols ensures [protection] during [wild] plant collection in [forest] and [meadow] environments.',
    },
    {
      'title': 'Plant Preparation Methods',
      'content': 'Create healing [tea] from dried [herb] materials. [fresh] plants can be used for [topical] applications. [oil] extractions require [scientific] methods for [medicine] preparation.',
    },
    {
      'title': 'Safety Guidelines',
      'content': '[caution] Always verify plant identification before use. [toxic] plants may look similar to [edible] ones. [pregnancy_warning] Some herbs are not suitable during pregnancy. When in doubt, consult [research] materials.',
    },
    {
      'title': 'Harvesting Times',
      'content': '[dawn] and [dusk] are optimal for [harvest]. [daily] collection should focus on [young] growth. [monthly] cycles affect [medicinal] potency of certain [root] systems.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        title: Text(
          'Content Icon Demo',
          style: context.primaryFont(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5A4E3C),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5A4E3C)),
          onPressed: () => context.pop(),
        ),
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header explanation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B4513).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF8B4513).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 24,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Icon Mapping Demo',
                          style: context.primaryFont(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5A4E3C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Content with [icon_key] tags will automatically display as icons inline with text. This demo shows how botanical and educational content can be enhanced with visual elements.',
                    style: context.secondaryFont(
                      fontSize: 14,
                      color: const Color(0xFF5A4E3C),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Sample content cards
            ...sampleContent.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ContentPreview(
                title: item['title']!,
                content: item['content']!,
                maxLines: 4,
              ),
            )),
            
            const SizedBox(height: 24),
            
            // Available icons section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Icon Keys',
                    style: context.primaryFont(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5A4E3C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Use any of these keys in your content by wrapping them in square brackets, e.g., [morning], [herb], [safe]',
                    style: context.secondaryFont(
                      fontSize: 14,
                      color: const Color(0xFF8B7355),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildIconGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconGrid() {
    final iconKeys = ContentIconMapper.getAllIconKeys();
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: iconKeys.take(20).map((key) { // Show first 20 icons
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFCF9F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF8B4513).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ContentIconMapper.buildIcon(
                key,
                size: 16,
                color: const Color(0xFF8B4513),
              ),
              const SizedBox(width: 6),
              Text(
                key,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5A4E3C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
