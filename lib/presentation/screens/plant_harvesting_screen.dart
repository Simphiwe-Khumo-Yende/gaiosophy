import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/enhanced_html_renderer.dart';

class PlantHarvestingScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;
  final Color backgroundColor = const Color(0xFFFCF9F2);
  final Color boxColor = const Color(0xFFE9E2D5);
  final Color textColor = const Color(0xFF5A4E3C);

  const PlantHarvestingScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    // Debug logging
    print('=== PLANT HARVESTING SCREEN ===');
    print('ContentBlock ID: ${contentBlock.id}');
    print('ContentBlock Type: ${contentBlock.type}');
    print('ContentBlock Order: ${contentBlock.order}');
    print('Has HTML content: ${contentBlock.data.content != null && contentBlock.data.content!.isNotEmpty}');
    print('HTML content length: ${contentBlock.data.content?.length ?? 0}');
    print('================================');

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home_outlined, color: textColor),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  contentBlock.data.title ?? 'Harvesting $parentTitle',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Seasonal Icons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSeasonIcon(context, Icons.local_florist, 'Spring'),
                  _buildSeasonIcon(context, Icons.wb_sunny, 'Summer'),
                  _buildSeasonIcon(context, Icons.eco, 'Autumn'),
                  _buildSeasonIcon(context, Icons.ac_unit, 'Winter'),
                ],
              ),
              const SizedBox(height: 20),
              
              // Timeline
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jan', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor)),
                    Expanded(
                      child: Slider(
                        value: 0.7,
                        onChanged: (value) {},
                        activeColor: Colors.brown[400],
                        inactiveColor: Colors.brown[200],
                      ),
                    ),
                    Text('Dec', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Subtitle if available (Ethical Foraging Practices)
              if (contentBlock.data.subtitle != null) ...[
                Text(
                  contentBlock.data.subtitle!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              // Main Content from Firestore
              if (contentBlock.data.content != null) ...[
                _buildContentWithIconsAndBoxes(contentBlock.data.content!),
                const SizedBox(height: 30),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeasonIcon(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: boxColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: textColor, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildContentWithIconsAndBoxes(String content) {
    return EnhancedHtmlRenderer(
      content: content,
      iconSize: 20,
      iconColor: textColor,
    );
  }
}
