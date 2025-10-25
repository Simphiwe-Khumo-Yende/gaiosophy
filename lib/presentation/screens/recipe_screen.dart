import 'package:flutter/material.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';
import '../widgets/bookmark_button.dart';
import '../widgets/enhanced_html_renderer.dart';
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
        height: 285.78,
        width: 218.18,
        child: FirebaseStorageImage(
          imageId: content.featuredImageId!,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Container(
        height: 285.78,
        width: 218.18,
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
    // Get all blocks with order > 0 (order 0 is typically intro)
    final blocks = content.contentBlocks.where((block) => block.order > 0).toList();
    
    // Sort by order to maintain the sequence from Firestore
    blocks.sort((a, b) => a.order.compareTo(b.order));
    
    final List<Widget> widgets = [];
    
    // Process blocks and group consecutive ingredient/equipment blocks
    int i = 0;
    while (i < blocks.length) {
      final block = blocks[i];
      final String title = block.data.title?.toLowerCase() ?? '';
      
      // Check if this is an ingredient/equipment/you-will-need block
      final bool isIngredientType = title.contains('ingredient') || 
                                    title.contains('equipment') || 
                                    title.contains('you will need');
      
      if (isIngredientType) {
        // Find all consecutive ingredient/equipment blocks
        final List<content_model.ContentBlock> groupedBlocks = [block];
        int j = i + 1;
        while (j < blocks.length) {
          final nextBlock = blocks[j];
          final nextTitle = nextBlock.data.title?.toLowerCase() ?? '';
          final isNextIngredientType = nextTitle.contains('ingredient') || 
                                       nextTitle.contains('equipment') || 
                                       nextTitle.contains('you will need');
          
          if (isNextIngredientType) {
            groupedBlocks.add(nextBlock);
            j++;
          } else {
            break;
          }
        }
        
        // Build combined box for all grouped blocks
        widgets.add(_buildCombinedBox(context, groupedBlocks));
        i = j; // Skip the grouped blocks
      } else {
        // Regular block (method, traditional uses, etc.)
        widgets.add(_buildContentBlock(context, block));
        i++;
      }
    }
    
    return widgets;
  }

  Widget _buildCombinedBox(BuildContext context, List<content_model.ContentBlock> blocks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E2D5), // Ingredients/Equipment box color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < blocks.length; i++) ...[
            if (blocks[i].data.title != null && blocks[i].data.title!.isNotEmpty) ...[
              Text(
                blocks[i].data.title!,
                style: const TextStyle(
                  fontFamily: 'Roboto Serif',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3A3025),
                ),
              ),
              const SizedBox(height: 12),
            ],
            _buildBlockContent(context, blocks[i]),
            if (i < blocks.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildContentBlock(BuildContext context, content_model.ContentBlock block) {
    final String title = block.data.title?.toLowerCase() ?? '';
    
    // Check if this block should be in a colored box
    // Typically: ingredients, equipment, traditional uses, etc.
    final bool shouldBox = title.contains('ingredient') || 
                           title.contains('equipment') || 
                           title.contains('you will need') ||
                           title.contains('traditional') || 
                           title.contains('usage');
    
    if (shouldBox) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: title.contains('traditional') || title.contains('usage')
              ? const Color(0xFFF2E9D7) // Traditional uses box
              : const Color(0xFFE9E2D5), // Ingredients/Equipment box
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
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
              const SizedBox(height: 12),
            ],
            _buildBlockContent(context, block),
          ],
        ),
      );
    } else {
      // Other content - no box (including Method)
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
            const SizedBox(height: 12),
          ],
          _buildBlockContent(context, block),
          const SizedBox(height: 16),
        ],
      );
    }
  }

  Widget _buildBlockContent(BuildContext context, content_model.ContentBlock block) {
    String content = block.data.content ?? '';
    
    // If content is empty, return empty widget
    if (content.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Use EnhancedHtmlRenderer for ALL content - it handles everything properly
    return EnhancedHtmlRenderer(
      content: content,
      textStyle: context.secondaryFont(
        fontSize: 16,
        color: const Color(0xFF3A3025),
        height: 1.4,
      ),
      iconSize: 16,
      iconColor: const Color(0xFF8B6B47),
    );
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