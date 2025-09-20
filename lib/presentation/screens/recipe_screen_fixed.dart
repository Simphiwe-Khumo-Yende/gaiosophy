import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black87),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
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
                  _buildSaveButton(),
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
    // Parse the content to extract list items
    String content = block.data.content ?? '';
    
    // Split by common separators and clean up
    List<String> items = [];
    
    // Try to split by line breaks first
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
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  item.trim(),
                  style: context.secondaryBodyMedium.copyWith(
                    height: 1.5,
                    color: const Color(0xFF5A5A5A),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTextContent(BuildContext context, content_model.ContentBlock block) {
    String content = block.data.content ?? '';
    
    // Use RecipeHtmlRenderer for all content (handles both HTML and plain text)
    return RecipeHtmlRenderer(
      content: content,
      iconSize: 16,
      iconColor: const Color(0xFF8B6B47),
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: BookmarkButton(
        content: content,
        iconColor: Colors.black87,
        iconSize: 16,
      ),
    );
  }
}
