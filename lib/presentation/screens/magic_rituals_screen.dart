import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/enhanced_html_renderer.dart';

class MagicRitualsScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;
  final Color backgroundColor = const Color(0xFFFCF9F2);
  final Color boxColor = const Color(0xFFE9E2D5);
  final Color textColor = const Color(0xFF5A4E3C);

  const MagicRitualsScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    // Debug logging
    
    
    
    
    
    
    

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
                  contentBlock.data.title ?? 'Magic and Rituals',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Subtitle if available
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
              if (contentBlock.data.content != null && contentBlock.data.content!.isNotEmpty) ...[
                _buildContentWithIconsAndBoxes(contentBlock.data.content!),
                const SizedBox(height: 30),
              ] else ...[
                Center(
                  child: Text(
                    'No content available',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
              
              // Seasonal Wisdom Content
              _buildSeasonalWisdomContent(context),
            ],
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
    );
  }

  Widget _buildSeasonalWisdomContent(BuildContext context) {
    return Column(
      children: [
        // Section Title
        Text(
          'Seasonal Wisdom & Rituals',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        
        // Spring Wisdom
        _buildSeasonWisdomCard(
          context,
          'Spring Awakening',
          '🌸',
          'Time of renewal, new beginnings, and fresh energy. Plant seeds of intention, cleanse your space, and embrace growth.',
          [
            '• Plant blessing rituals',
            '• Spring cleaning ceremonies',
            '• New moon intention setting',
            '• Flower essence preparations',
          ],
        ),
        
        // Summer Wisdom
        _buildSeasonWisdomCard(
          context,
          'Summer Abundance',
          '☀️',
          'Season of peak energy, manifestation, and celebration. Harvest your intentions and bask in the light.',
          [
            '• Sun salutation rituals',
            '• Herb harvesting ceremonies',
            '• Fire magic and candle work',
            '• Crystal charging under sunlight',
          ],
        ),
        
        // Autumn Wisdom
        _buildSeasonWisdomCard(
          context,
          'Autumn Reflection',
          '🍂',
          'Time of harvest, gratitude, and preparation. Release what no longer serves and prepare for inner work.',
          [
            '• Gratitude ceremonies',
            '• Ancestor honoring rituals',
            '• Apple and pomegranate blessings',
            '• Shadow work and reflection',
          ],
        ),
        
        // Winter Wisdom
        _buildSeasonWisdomCard(
          context,
          'Winter Contemplation',
          '❄️',
          'Season of rest, inner wisdom, and deep magic. Turn inward, practice divination, and embrace stillness.',
          [
            '• Candlelit meditation',
            '• Dream work and journaling',
            '• Evergreen blessing rituals',
            '• Solstice celebrations',
          ],
        ),
      ],
    );
  }

  Widget _buildSeasonWisdomCard(BuildContext context, String title, String emoji, String description, List<String> practices) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ritual Practices:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...practices.map((practice) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              practice,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor,
                height: 1.4,
              ),
            ),
          )),
        ],
      ),
    );
  }
}