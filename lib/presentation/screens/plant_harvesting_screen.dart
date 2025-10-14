import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/enhanced_html_renderer.dart';
import '../theme/typography.dart';
import '../../application/providers/content_list_provider.dart';

class PlantHarvestingScreen extends ConsumerWidget {
  final content_model.ContentBlock contentBlock;
  final String parentContentId; // Content ID to watch for real-time updates
  final String parentTitle;
  final Color backgroundColor = const Color(0xFFFCF9F2);
  final Color boxColor = const Color(0xFFE9E2D5);
  final Color textColor = const Color(0xFF5A4E3C);

  const PlantHarvestingScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
    required this.parentContentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the real-time content provider for live updates
    final contentAsync = ref.watch(realTimeContentDetailProvider(parentContentId));
    
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
      body: contentAsync.when(
        data: (parentContent) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
                
                // Dynamic Harvest Timeline - now with real-time content
                _buildHarvestTimeline(context, parentContent),
                
                const SizedBox(height: 30),    
                // Main Content from Firestore
                if (contentBlock.data.content != null) ...[
                  _buildContentWithIconsAndBoxes(contentBlock.data.content!),
                  const SizedBox(height: 30),
                ],
              ],
            ),
          ),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(color: textColor),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: textColor, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading harvest data',
                  style: context.primaryFont(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: context.primaryFont(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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

  Widget _buildHarvestTimeline(BuildContext context, content_model.Content? parentContent) {
    // Use harvest periods from parent content (real-time), or fall back to content block
    final harvestPeriods = parentContent?.harvestPeriods ?? contentBlock.data.harvestPeriods;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: 12, // Height for the dots
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background line
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DCC6),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                // Dots positioned on the line based on harvest_periods
                if (harvestPeriods.isNotEmpty)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      
                      return Stack(
                        children: harvestPeriods.asMap().entries.map<Widget>((entry) {
                          final period = entry.value;
                          return _buildHarvestDot(
                            period.monthPosition,
                            width,
                          );
                        }).toList(),
                      );
                    },
                  )
                else
                  // Fallback if no harvest periods defined
                  Center(
                    child: Text(
                      '⚠️ No harvest periods defined',
                      style: TextStyle(
                        color: textColor.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
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
    );
  }

  Widget _buildHarvestDot(int month, double totalWidth) {
    // Position dot based on month (1-12 maps to 0-1 position along the bar)
    final clampedMonth = month.clamp(1, 12);
    final position = (clampedMonth - 0.5) / 12; // Center the dot in its month segment
    final leftPosition = (totalWidth * position) - 6; // 6 is half of dot width (12/2)
    final clampedLeftPosition = leftPosition.clamp(0.0, totalWidth - 12).toDouble();
    
    return Positioned(
      left: clampedLeftPosition,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: const Color(0xFF8B7355), // Static brown color
          shape: BoxShape.circle,
          border: Border.all(
            color: backgroundColor,
            width: 1.5,
          ),
        ),
      ),
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
