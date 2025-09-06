import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';
import '../widgets/bookmark_button.dart';
import '../widgets/rich_content_text.dart';
import '../widgets/content_icon_mapper.dart';
import '../theme/typography.dart';

class RecipeScreen extends StatelessWidget {
  final content_model.Content content;

  const RecipeScreen({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with illustration
            Container(
              color: const Color(0xFFFCF9F2),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  // Recipe Title
                  Text(
                    content.title,
                    textAlign: TextAlign.center,
                    style: context.primaryHeadlineMedium.copyWith(
                      color: const Color(0xFF1A1612),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Featured Image
                  _buildFeaturedImage(context),
                  const SizedBox(height: 20),
                  // Time indicators
                  _buildTimeIndicators(context),
                ],
              ),
            ),
            // Content
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe introduction (from first content block)
                  _buildRecipeIntroduction(context),
                  const SizedBox(height: 30),
                  
                  // Dynamic content blocks (ingredients, equipment, method, etc.)
                  ...content.contentBlocks
                      .where((block) => block.order > 0) // Skip intro block
                      .map((block) => _buildContentBlock(context, block))
                      .toList(),
                  
                  const SizedBox(height: 40),
                  // Save button
                  _buildSaveButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedImage(BuildContext context) {
    if (content.featuredImageId != null) {
      return Container(
        height: 200,
        width: 300,
        child: FirebaseStorageImage(
          imageId: content.featuredImageId!,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.restaurant,
          size: 80,
          color: Colors.grey,
        ),
      );
    }
  }

  Widget _buildTimeIndicators(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E2D5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (content.prepTime != null) ...[
            _buildTimeIndicator(context, 'Prep Time', content.prepTime!),
            const SizedBox(width: 30),
          ],
          if (content.infusionTime != null) ...[
            _buildTimeIndicator(context, 'Infusion', content.infusionTime!),
            const SizedBox(width: 30),
          ],
          if (content.difficulty != null) ...[
            _buildTimeIndicator(context, 'Difficulty', content.difficulty!),
            const SizedBox(width: 30),
          ],
          // You can add season if you have it in your data model
          _buildTimeIndicator(context, 'Season', 'All'),
        ],
      ),
    );
  }

  Widget _buildTimeIndicator(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: context.secondaryLabelSmall.copyWith(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.secondaryBodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeIntroduction(BuildContext context) {
    // Get the first content block (intro)
    final introBlock = content.contentBlocks.isNotEmpty 
        ? content.contentBlocks.first 
        : null;
    
    if (introBlock?.data.content != null) {
      // Extract plain text from HTML content
      String plainText = introBlock!.data.content!.replaceAll(RegExp(r'<[^>]*>'), '');
      
      return Text(
        plainText,
        style: context.secondaryBodyMedium.copyWith(
          height: 1.5,
          color: const Color(0xFF5A5A5A),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildContentBlock(BuildContext context, content_model.ContentBlock block) {
    final String title = block.data.title?.toLowerCase() ?? '';
    final bool isIngredients = title.contains('ingredient');
    final bool isUsage = title.contains('usage') || title.contains('use') || title.contains('method');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isIngredients || isUsage)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE9E2D5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  block.data.title ?? '',
                  style: context.primaryTitleLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                block.type == 'list' 
                    ? _buildListContent(context, block)
                    : _buildTextContent(context, block),
              ],
            ),
          )
        else ...[
          Text(
            block.data.title ?? '',
            style: context.primaryTitleLarge.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          if (block.type == 'list') 
            _buildListContent(context, block)
          else 
            _buildTextContent(context, block),
        ],
        
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildListContent(BuildContext context, content_model.ContentBlock block) {
    List<String> items = [];
    
    // Check if we have structured list items first
    if (block.data.listItems.isNotEmpty) {
      items = block.data.listItems;
    } else if (block.data.content != null && block.data.content!.isNotEmpty) {
      // Fallback to parsing HTML content
      String content = block.data.content!;
      
      // Split by common separators and clean up
      List<String> lines = content.split('\n').where((line) => line.trim().isNotEmpty).toList();
      
      if (lines.length > 1) {
        items = lines;
      } else {
        // If no line breaks, try splitting by numbers (1., 2., etc.) or other patterns
        if (content.contains(RegExp(r'\d+\.'))) {
          items = content.split(RegExp(r'\d+\.')).where((item) => item.trim().isNotEmpty).toList();
        } else {
          // Fallback: split by periods or other punctuation
          items = [content];
        }
      }
    }
    
    // Determine list style
    final bool isNumbered = block.data.listStyle == 'numbered' || block.data.listStyle == 'number';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries
          .map((entry) {
            final int index = entry.key;
            final String item = entry.value;
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // List marker (bullet or number)
                  if (isNumbered)
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: Text(
                        '${index + 1}.',
                        style: context.secondaryBodyMedium.copyWith(
                          color: const Color(0xFF5A5A5A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5A5A5A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      _cleanText(item.trim()),
                      style: context.secondaryBodyMedium.copyWith(
                        height: 1.5,
                        color: const Color(0xFF5A5A5A),
                      ),
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(),
    );
  }

  Widget _buildTextContent(BuildContext context, content_model.ContentBlock block) {
    String content = block.data.content ?? '';
    
    // Check if content contains icon keys [key]
    final RegExp iconRegex = RegExp(r'\[([^\]]+)\]');
    final hasIcons = iconRegex.hasMatch(content);
    
    if (hasIcons) {
      // If it looks like HTML content (contains tags), we need special handling
      if (content.contains('<') && content.contains('>')) {
        return _buildHtmlContentWithIcons(content);
      } else {
        // Use rich content text for plain text with icon parsing
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: RichContentText(
            content,
            textStyle: context.secondaryBodyMedium.copyWith(
              height: 1.5,
              color: const Color(0xFF5A5A5A),
            ),
            iconSize: 16,
            iconColor: const Color(0xFF8B6B47),
          ),
        );
      }
    } else {
      // If it's HTML content, render as HTML
      if (content.contains('<') && content.contains('>')) {
        return Html(
          data: content,
          style: {
            "body": Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              color: const Color(0xFF5A5A5A),
              fontSize: FontSize(13),
              lineHeight: LineHeight(1.5),
            ),
            "p": Style(
              margin: Margins.only(bottom: 8),
            ),
            "h1, h2, h3": Style(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            "ul": Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
            ),
            "li": Style(
              margin: Margins.only(bottom: 4),
              listStyleType: ListStyleType.disc,
            ),
          },
        );
      } else {
        // Plain text
        return Text(
          _cleanText(content),
          style: context.secondaryBodyMedium.copyWith(
            height: 1.5,
            color: const Color(0xFF5A5A5A),
          ),
        );
      }
    }
  }

  // Special method to handle HTML content that contains icon keys
  Widget _buildHtmlContentWithIcons(String htmlContent) {
    // Preprocess the HTML to replace icon keys with placeholder text that we can style
    String processedHtml = _replaceIconKeysInHtml(htmlContent);
    
    return Html(
      data: processedHtml,
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: const Color(0xFF5A5A5A),
          fontSize: FontSize(13),
          lineHeight: LineHeight(1.5),
        ),
        "p": Style(
          margin: Margins.only(bottom: 8),
        ),
        "h1, h2, h3": Style(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        "ul": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        "li": Style(
          margin: Margins.only(bottom: 4),
          listStyleType: ListStyleType.disc,
        ),
        ".icon": Style(
          color: const Color(0xFF8B6B47),
          fontWeight: FontWeight.bold,
        ),
      },
    );
  }

  // Helper method to replace icon keys with styled spans in HTML
  String _replaceIconKeysInHtml(String htmlContent) {
    final RegExp iconRegex = RegExp(r'\[([^\]]+)\]');
    return htmlContent.replaceAllMapped(iconRegex, (match) {
      final iconKey = match.group(1)!.toLowerCase();
      if (ContentIconMapper.hasIcon(iconKey)) {
        // Replace with a styled span that includes an icon symbol
        // Using Unicode symbols as a fallback since we can't embed Flutter icons in HTML
        final iconSymbol = _getIconSymbol(iconKey);
        return '<span class="icon">$iconSymbol</span>';
      } else {
        // Keep original text if icon not found
        return match.group(0)!;
      }
    });
  }

  // Helper method to get Unicode symbols for icons (fallback for HTML rendering)
  String _getIconSymbol(String iconKey) {
    const Map<String, String> iconSymbols = {
      'mountain': '⛰️',
      'tree': '🌲',
      'flower': '🌸',
      'herb': '🌿',
      'leaf': '🍃',
      'sun': '☀️',
      'morning': '🌅',
      'evening': '🌆',
      'night': '🌙',
      'water': '💧',
      'tea': '🍵',
      'healing': '💚',
      'safe': '✅',
      'caution': '⚠️',
      'danger': '⚠️',
      'toxic': '☠️',
      'medicine': '💊',
      'forest': '🌲',
      'meadow': '🌾',
      'garden': '🏡',
      'harvest': '🌾',
      'fresh': '🌱',
      'dried': '🍂',
      'oil': '🫗',
      'powder': '🥄',
      'compress': '🩹',
      'massage': '💆',
      'scalp': '👤',
      'hair': '💇',
      'wash': '🚿',
      'rinse': '💧',
      'store': '📦',
      'fridge': '🧊',
      'days': '📅',
      'time': '⏰',
      'best': '⭐',
      'results': '✅',
      'traditional': '📜',
      'usage': 'ℹ️',
    };
    
    return iconSymbols[iconKey] ?? '🔹';
  }

  Widget _buildSaveButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BookmarkButton(
              content: content,
              iconColor: Colors.black87,
              iconSize: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Save',
              style: context.secondaryBodyMedium.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to clean text from HTML tags and extra formatting
  String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .trim();
  }
}
