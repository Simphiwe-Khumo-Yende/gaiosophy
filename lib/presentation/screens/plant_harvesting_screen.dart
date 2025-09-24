import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/enhanced_html_renderer.dart';
import '../theme/typography.dart';

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
                  style: context.primaryFont(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
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
// Replace the Timeline section with this:

// Timeline
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background line
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8DCC6), // Light beige color for the line
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        // Dots positioned on the line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Spring dot (around March)
                            Expanded(
                              flex: 3,
                              child: Container(),
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B7355), // Brown color for dots
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Summer dot (around June)
                            Expanded(
                              flex: 3,
                              child: Container(),
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B7355),
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Autumn dot (around September)
                            Expanded(
                              flex: 3,
                              child: Container(),
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B7355),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Month labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jan',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Dec',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
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
    // Get season-specific circle color based on label
    Color circleColor;
    switch (label.toLowerCase()) {
      case 'spring':
        circleColor = const Color(0xFFF2E9D7); // Spring color
        break;
      case 'summer':
        circleColor = const Color(0xFFE6DFD0); // Summer color
        break;
      case 'autumn':
        circleColor = const Color(0xFFF2E9D7); // Autumn color
        break;
      case 'winter':
        circleColor = const Color(0xFFE6DFD0); // Winter color
        break;
      default:
        circleColor = boxColor; // Fallback to original color
    }

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE5E7EB), // Light border as shown in Figma
              width: 1,
            ),
          ),
          child: Icon(icon, color: textColor, size: 24),
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
      textStyle: TextStyle(
        color: textColor,
        fontSize: 16,
        height: 1.6,
      ),
    );
  }
}
