import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;

class PlantFolkloreScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const PlantFolkloreScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Container(
                height: 150,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_stories,
                      size: 50,
                      color: Color(0xFF5A4E3C),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      contentBlock.data.title ?? 'Folklore & Legends',
                      style: const TextStyle(
                        color: Color(0xFF5A4E3C),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content with actual data or fallback stories
              if (contentBlock.data.content != null) ...[
                _buildContentCard(
                  title: 'Traditional Knowledge',
                  icon: Icons.history_edu,
                  content: contentBlock.data.content!,
                  isHtml: true,
                ),
              ] else ...[
                // Ancient Stories Card
                _buildStoryCard(
                  title: 'Ancient Celtic Beliefs',
                  icon: Icons.history_edu,
                  content: 'In ancient traditions, plants were considered sacred beings that bridged the world of the living and the spirit realm. The unique characteristics of each plant were believed to hold special powers and wisdom, while their gifts represented the rewards that come after understanding their true nature.',
                ),
                
                const SizedBox(height: 20),
                
                // Protection Lore Card
                _buildStoryCard(
                  title: 'Protection & Boundaries',
                  icon: Icons.shield,
                  content: 'Plants have long been used to create natural barriers and sacred boundaries. Folk wisdom teaches that these natural guardians not only protect physical spaces but also create energetic shields against negative influences and unwanted energies.',
                ),
                
                const SizedBox(height: 20),
                
                // Seasonal Wisdom Card
                _buildStoryCard(
                  title: 'Seasonal Wisdom',
                  icon: Icons.calendar_today,
                  content: 'Traditional folklore connects plants to the cycles of nature - from the tender spring growth representing new beginnings, to the summer flowers symbolizing abundance, and the autumn fruits marking the time of harvest and gratitude.',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1612)),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.home, color: Color(0xFF1A1612)),
          onPressed: () => context.go('/'),
        ),
      ],
    );
  }

  Widget _buildContentCard({
    required String title,
    required IconData icon,
    required String content,
    bool isHtml = false,
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
          if (isHtml) ...[
            Html(
              data: content,
              style: {
                "body": Style(
                  color: const Color(0xFF5A4E3C),
                  fontSize: FontSize(16),
                  lineHeight: const LineHeight(1.8),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "p": Style(
                  color: const Color(0xFF5A4E3C),
                  fontSize: FontSize(16),
                  lineHeight: const LineHeight(1.8),
                  margin: Margins.only(bottom: 12),
                ),
              },
            ),
          ] else ...[
            Text(
              content,
              style: const TextStyle(
                color: Color(0xFF5A4E3C),
                fontSize: 16,
                height: 1.8,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStoryCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return _buildContentCard(
      title: title,
      icon: icon,
      content: content,
      isHtml: false,
    );
  }
}
