import 'package:flutter/material.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';
import '../widgets/bookmark_button.dart';

class RecipeScreen extends StatelessWidget {
  final content_model.Content content;

  const RecipeScreen({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2), // Main app background
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
                    style: const TextStyle(
                      fontFamily: 'Roboto Serif',
                      fontSize: 24,
                      fontWeight: FontWeight.w600, // Semi-bold to match Figma
                      color: Color(0xFF3A3025),
                      letterSpacing: 0.5,
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
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe introduction (from first content block)
                  _buildRecipeIntroduction(context),
                  const SizedBox(height: 20), // Reduced spacing
                  
                  // Dynamic content blocks (ingredients, method, etc.)
                  ..._buildGroupedContentBlocks(context),
                  
                  const SizedBox(height: 30), // Reduced spacing
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
    List<Widget> indicators = [];
    
    if (content.prepTime != null) {
      indicators.add(_buildTimeIndicator('Prep Time', content.prepTime!));
    }
    if (content.infusionTime != null) {
      indicators.add(_buildTimeIndicator('Infusion', content.infusionTime!));
    }
    if (content.difficulty != null) {
      indicators.add(_buildTimeIndicator('Difficulty', content.difficulty!));
    }
    indicators.add(_buildTimeIndicator('Season', 'As needed'));
    
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1ECE1), // Prep time box color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: indicators.map((indicator) => 
          Expanded(
            child: Center(child: indicator),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildTimeIndicator(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto Serif',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Color(0xFF5B5D4D), // 1st line color
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Roboto Serif',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Color(0xFF5B5D4D), // 2nd line color
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
        style: const TextStyle(
          fontFamily: 'Roboto Serif',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0xFF28231B), // Intro text color
          height: 1.5,
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  List<Widget> _buildGroupedContentBlocks(BuildContext context) {
    final blocks = content.contentBlocks.where((block) => block.order > 0).toList();
    final List<Widget> widgets = [];
    
    // Group ingredients and equipment together
    final ingredientBlocks = blocks.where((block) {
      final title = block.data.title?.toLowerCase() ?? '';
      return title.contains('ingredient');
    }).toList();
    
    final equipmentBlocks = blocks.where((block) {
      final title = block.data.title?.toLowerCase() ?? '';
      return title.contains('equipment');
    }).toList();
    
    // Create combined ingredients/equipment box if either exists
    if (ingredientBlocks.isNotEmpty || equipmentBlocks.isNotEmpty) {
      widgets.add(_buildCombinedIngredientsEquipmentBox(context, ingredientBlocks, equipmentBlocks));
    }
    
    // Process other blocks individually
    final otherBlocks = blocks.where((block) {
      final title = block.data.title?.toLowerCase() ?? '';
      return !title.contains('ingredient') && !title.contains('equipment');
    }).toList();
    
    for (final block in otherBlocks) {
      widgets.add(_buildContentBlock(context, block));
    }
    
    return widgets;
  }

  Widget _buildCombinedIngredientsEquipmentBox(BuildContext context, 
      List<content_model.ContentBlock> ingredientBlocks, 
      List<content_model.ContentBlock> equipmentBlocks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E2D5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Render ingredient blocks
          ...ingredientBlocks.map((block) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (block.data.title != null && block.data.title!.isNotEmpty) ...[
                Text(
                  block.data.title!,
                  style: const TextStyle(
                    fontFamily: 'Roboto Serif',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A3025),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              _buildBlockContent(context, block, isBoxed: true),
              if (equipmentBlocks.isNotEmpty) const SizedBox(height: 16),
            ],
          )).toList(),
          
          // Render equipment blocks
          ...equipmentBlocks.map((block) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (block.data.title != null && block.data.title!.isNotEmpty) ...[
                Text(
                  block.data.title!,
                  style: const TextStyle(
                    fontFamily: 'Roboto Serif',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A3025),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              _buildBlockContent(context, block, isBoxed: true),
            ],
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildContentBlock(BuildContext context, content_model.ContentBlock block) {
    final String title = block.data.title?.toLowerCase() ?? '';
    
    // Traditional Uses gets its own box
    final bool isTraditionalUses = title.contains('traditional') || title.contains('uses') || title.contains('usage');
    
    if (isTraditionalUses) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(bottom: 16), // Reduced margin between boxes
        decoration: BoxDecoration(
          color: const Color(0xFFF2E9D7), // Bottom box color - matches Figma
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              block.data.title ?? '',
              style: const TextStyle(
                fontFamily: 'Roboto Serif',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3025),
              ),
            ),
            const SizedBox(height: 12), // Decreased but reasonable spacing inside boxes
            _buildBlockContent(context, block, isBoxed: true),
          ],
        ),
      );
    }
    
    // Other content - no box (including Method)
    else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.data.title != null && block.data.title!.isNotEmpty) ...[
            Text(
              block.data.title!,
              style: const TextStyle(
                fontFamily: 'Roboto Serif',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3025),
              ),
            ),
            const SizedBox(height: 12), // Decreased but reasonable spacing for unboxed content
          ],
          _buildBlockContent(context, block, isBoxed: false),
          const SizedBox(height: 16), // Reduced spacing between unboxed content
        ],
      );
    }
  }

  Widget _buildBlockContent(BuildContext context, content_model.ContentBlock block, {required bool isBoxed}) {
    // Always try to parse as structured content first
    String content = block.data.content ?? '';
    
    // Check if we have list items directly
    if (block.data.listItems.isNotEmpty) {
      return _buildListContent(context, block);
    }
    
    // If content is empty, return empty widget
    if (content.isEmpty) return const SizedBox.shrink();
    
    // Check if content has list-like structure or multiple paragraphs
    // Also check if this is an ingredients block (which should always be bulleted)
    final String title = block.data.title?.toLowerCase() ?? '';
    final bool isIngredients = title.contains('ingredient');
    
    if (_hasStructuredContent(content) || isIngredients) {
      return _buildListContent(context, block, forceBullets: isIngredients);
    } else {
      // Use simple text rendering for basic content
      return Text(
        content.replaceAll(RegExp(r'<[^>]*>'), '').trim(),
        style: const TextStyle(
          fontFamily: 'Roboto Serif',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0xFF3A3025),
          height: 1.4,
        ),
      );
    }
  }

  bool _hasStructuredContent(String content) {
    // Check specifically for bullet point indicators
    return content.contains('<li') || 
           content.contains('<ul') ||
           content.contains('<ol');
  }

  Widget _buildListContent(BuildContext context, content_model.ContentBlock block, {bool forceBullets = false}) {
    List<_ListItem> items = _parseListItems(block, forceBullets: forceBullets);
    
    if (items.isEmpty) return const SizedBox.shrink();
    
    List<Widget> widgets = [];
    
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      
      if (item.isHeader) {
        // Section header
        widgets.add(
          Padding(
            padding: EdgeInsets.only(
              top: i > 0 ? 12.0 : 0.0,
              bottom: 6.0,
            ),
            child: Text(
              item.text,
              style: const TextStyle(
                fontFamily: 'Roboto Serif',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3025),
                height: 1.3,
              ),
            ),
          ),
        );
      } else if (item.isBullet) {
        // Bullet point item
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(
                    left: 24,
                    top: 8,
                    right: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF3A3025),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Text(
                      item.text,
                      style: const TextStyle(
                        fontFamily: 'Roboto Serif',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF3A3025),
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Regular text (no bullet)
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, left: 24, right: 24),
            child: Text(
              item.text,
              style: const TextStyle(
                fontFamily: 'Roboto Serif',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Color(0xFF3A3025),
                height: 1.4,
              ),
            ),
          ),
        );
      }
    }

        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  List<_ListItem> _parseListItems(content_model.ContentBlock block, {bool forceBullets = false}) {
    List<String> rawItems = [];
    
    // Extract items from various sources
    if (block.data.listItems.isNotEmpty) {
      rawItems = block.data.listItems.where((item) => item.trim().isNotEmpty).toList();
    } else if (block.data.content != null && block.data.content!.isNotEmpty) {
      // Clean and parse HTML content from rich text editor
      String cleanContent = _cleanHtmlContent(block.data.content!);
      
      // Split by lines and filter meaningful content
      rawItems = cleanContent
          .split('\n')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty && item.length > 1)
          .toList();
    }
    
    // Parse items based on what's actually in the rich text editor
    List<_ListItem> parsedItems = [];
    
    for (String item in rawItems) {
      String cleanItem = item.trim();
      if (cleanItem.isEmpty) continue;
      
      // Check if this item has a bullet point from the rich text editor
      bool hasBullet = cleanItem.startsWith('•') || 
                      cleanItem.startsWith('·') || 
                      cleanItem.startsWith('-') ||
                      cleanItem.startsWith('*');
      
      // Remove the bullet character for display
      if (hasBullet) {
        cleanItem = cleanItem.replaceAll(RegExp(r'^[•·\-*]\s*'), '');
      }
      
      // Simple header detection - just look for colons or very short lines
      bool isHeader = cleanItem.endsWith(':') && cleanItem.split(' ').length <= 4;
      
      // Force bullets for ingredient lists (unless it's a header)
      bool shouldHaveBullet = (hasBullet || forceBullets) && !isHeader;
      
      parsedItems.add(_ListItem(
        text: cleanItem,
        isHeader: isHeader,
        isBullet: shouldHaveBullet,
      ));
    }
    
    return parsedItems;
  }

  String _cleanHtmlContent(String html) {
    return html
        // First, normalize line breaks and spaces
        .replaceAll(RegExp(r'\r\n|\r'), '\n')
        
        // Handle list structures - preserve as bullet points
        .replaceAll(RegExp(r'<ul[^>]*>'), '')
        .replaceAll(RegExp(r'</ul>'), '')
        .replaceAll(RegExp(r'<ol[^>]*>'), '')
        .replaceAll(RegExp(r'</ol>'), '')
        .replaceAll(RegExp(r'<li[^>]*>'), '\n• ')
        .replaceAll(RegExp(r'</li>'), '')
        
        // Handle paragraphs - each becomes a new line
        .replaceAll(RegExp(r'<p[^>]*>'), '\n')
        .replaceAll(RegExp(r'</p>'), '\n')
        
        // Handle line breaks
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        
        // Handle divs as line breaks
        .replaceAll(RegExp(r'<div[^>]*>'), '\n')
        .replaceAll(RegExp(r'</div>'), '\n')
        
        // Remove formatting tags but preserve content
        .replaceAll(RegExp(r'<span[^>]*>'), '')
        .replaceAll(RegExp(r'</span>'), '')
        .replaceAll(RegExp(r'<strong[^>]*>'), '')
        .replaceAll(RegExp(r'</strong>'), '')
        .replaceAll(RegExp(r'<b[^>]*>'), '')
        .replaceAll(RegExp(r'</b>'), '')
        .replaceAll(RegExp(r'<i[^>]*>'), '')
        .replaceAll(RegExp(r'</i>'), '')
        .replaceAll(RegExp(r'<u[^>]*>'), '')
        .replaceAll(RegExp(r'</u>'), '')
        
        // Remove any remaining HTML tags
        .replaceAll(RegExp(r'<[^>]*>'), '')
        
        // Clean up whitespace but preserve structure
        .replaceAll(RegExp(r'&nbsp;'), ' ')
        .replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n')  // Max 2 consecutive newlines
        .replaceAll(RegExp(r'^\n+'), '')  // Remove leading newlines
        .replaceAll(RegExp(r'\n+$'), '')  // Remove trailing newlines
        .trim();
  }

  Widget _buildSaveButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              iconSize: 14,
            ),
            const SizedBox(width: 8),
            const Text(
              'Save',
              style: TextStyle(
                fontFamily: 'Roboto Serif',
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for list items
class _ListItem {
  final String text;
  final bool isHeader;
  final bool isBullet;
  
  _ListItem({
    required this.text,
    required this.isHeader,
    required this.isBullet,
  });
}