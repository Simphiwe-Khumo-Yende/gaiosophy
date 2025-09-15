import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';
import '../widgets/enhanced_html_renderer.dart';
import '../theme/typography.dart';

class FolkMedicineScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const FolkMedicineScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    // Add comprehensive debugging
    
    
    
    
    
    
    
    
    
    

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3C3C3C)),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Color(0xFF3C3C3C)),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  contentBlock.data.title ?? parentTitle,
                  style: context.primaryFont(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3C3C3C),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Circular Image if available
              if (contentBlock.data.featuredImageId != null && contentBlock.data.featuredImageId!.isNotEmpty) ...[
                Center(
                  child: ClipOval(
                    child: FirebaseStorageImage(
                      imageId: contentBlock.data.featuredImageId!,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: Container(
                        width: 180,
                        height: 180,
                        color: const Color(0xFF8B6B47).withOpacity(0.1),
                        child: const Icon(
                          Icons.spa_outlined,
                          size: 48,
                          color: Color(0xFF8B6B47),
                        ),
                      ),
                      errorWidget: Container(
                        width: 180,
                        height: 180,
                        color: const Color(0xFF8B6B47).withOpacity(0.1),
                        child: const Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: Color(0xFF8B6B47),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Content
              _buildFolkMedicineContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFolkMedicineContent(BuildContext context) {
    // Check if we have sub-blocks (specific plant parts)
    if (contentBlock.data.subBlocks.isNotEmpty) {
      return _buildSubBlocksContent(context);
    }

    // Fall back to HTML content if no sub-blocks
    String? htmlContent = contentBlock.data.content;

    if (htmlContent == null || htmlContent.isEmpty) {
      
      return _buildDefaultContent(context);
    }

    
    
    // Use enhanced HTML renderer for all content
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      child: EnhancedHtmlRenderer(
        content: htmlContent,
        textStyle: context.secondaryFont(
          fontSize: 15,
          color: const Color(0xFF3C3C3C),
          height: 1.6,
        ),
        iconSize: 18,
        iconColor: const Color(0xFF8B6B47),
      ),
    );
  }

  Widget _buildSubBlocksContent(BuildContext context) {
    
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentBlock.data.subBlocks.map((subBlock) {
        
        
        
        

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show plant part name if available (e.g., "Fruit")
            if (subBlock.plantPartName != null && subBlock.plantPartName!.isNotEmpty) ...[
              Text(
                subBlock.plantPartName!,
                style: context.primaryFont(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3C3C3C),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Medicinal uses
            if (subBlock.medicinalUses.isNotEmpty) ...[
              Text(
                'Medicinal Uses',
                style: context.primaryFont(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3C3C3C),
                ),
              ),
              const SizedBox(height: 12),
              _buildSimpleUsesList(context, subBlock.medicinalUses),
              const SizedBox(height: 24),
            ],

            // Skincare uses
            if (subBlock.skincareUses.isNotEmpty) ...[
              Text(
                'Skincare Uses',
                style: context.primaryFont(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3C3C3C),
                ),
              ),
              const SizedBox(height: 12),
              _buildSimpleUsesList(context, subBlock.skincareUses),
              const SizedBox(height: 24),
            ],

            // Energetic uses (or Seed Oil as shown in design)
            if (subBlock.energeticUses.isNotEmpty) ...[
                Text(
                subBlock.plantPartName?.contains('Seed') == true ? 'Seed Oil' : 'Energetic Uses',
                style: context.primaryFont(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3C3C3C),
                ),
              ),
              const SizedBox(height: 12),
              _buildSimpleUsesList(context, subBlock.energeticUses),
              const SizedBox(height: 24),
            ],
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSimpleUsesList(BuildContext context, List<String> uses) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: uses.map((use) {
          // Clean the HTML content
          final cleanedUse = _stripHtml(use);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '•',
                    style: context.primaryFont(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF3C3C3C),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                    cleanedUse,
                    style: context.secondaryFont(
                      fontSize: 14,
                      color: const Color(0xFF3C3C3C),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Helper method to strip HTML tags and decode entities
  String _stripHtml(String htmlString) {
    // Remove HTML tags
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String stripped = htmlString.replaceAll(exp, '');
    
    // Decode HTML entities
    stripped = stripped
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&ldquo;', '"')
        .replaceAll('&rdquo;', '"')
        .replaceAll('&lsquo;', "'")
        .replaceAll('&rsquo;', "'")
        .replaceAll('&ndash;', '–')
        .replaceAll('&mdash;', '—');
    
    // Clean up extra whitespace
    stripped = stripped.trim().replaceAll(RegExp(r'\s+'), ' ');
    
    return stripped;
  }

  Widget _buildDefaultContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.spa_outlined,
              size: 48,
              color: const Color(0xFF8B6B47),
            ),
            const SizedBox(height: 16),
            Text(
              'Folk medicine content is being prepared.\nPlease check back later.',
              style: context.secondaryFont(
                fontSize: 15,
                color: const Color(0xFF3C3C3C),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'If you continue to see this message,\nthe content may not be available yet.',
              style: context.secondaryFont(
                fontSize: 13,
                color: const Color(0xFF8B6B47),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}