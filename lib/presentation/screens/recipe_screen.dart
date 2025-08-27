import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
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
      backgroundColor: const Color(0xFFF5F0E8),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with illustration
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    // Featured Image
                    _buildFeaturedImage(),
                    const SizedBox(height: 20),
                    Text(
                      content.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.2,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Time indicators
                    _buildTimeIndicators(),
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
                    _buildRecipeIntroduction(),
                    const SizedBox(height: 30),
                    
                    // Dynamic content blocks (ingredients, equipment, method, etc.)
                    ...content.contentBlocks
                        .where((block) => block.order > 0) // Skip intro block
                        .map((block) => _buildContentBlock(block))
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
      ),
    );
  }

  Widget _buildFeaturedImage() {
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

  Widget _buildTimeIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (content.prepTime != null) ...[
          _buildTimeIndicator('Prep Time', content.prepTime!),
          const SizedBox(width: 30),
        ],
        if (content.infusionTime != null) ...[
          _buildTimeIndicator('Infusion', content.infusionTime!),
          const SizedBox(width: 30),
        ],
        if (content.difficulty != null) ...[
          _buildTimeIndicator('Difficulty', content.difficulty!),
          const SizedBox(width: 30),
        ],
        // You can add season if you have it in your data model
        _buildTimeIndicator('Season', 'All'),
      ],
    );
  }

  Widget _buildTimeIndicator(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeIntroduction() {
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
          fontSize: 13,
          height: 1.5,
          color: Color(0xFF5A5A5A),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildContentBlock(content_model.ContentBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          block.data.title ?? '',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        
        if (block.type == 'list') 
          _buildListContent(block)
        else 
          _buildTextContent(block),
        
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildListContent(content_model.ContentBlock block) {
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
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF5A5A5A),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTextContent(content_model.ContentBlock block) {
    String content = block.data.content ?? '';
    
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
        },
      );
    } else {
      // Plain text
      return Text(
        content,
        style: const TextStyle(
          fontSize: 13,
          height: 1.5,
          color: Color(0xFF5A5A5A),
        ),
      );
    }
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
