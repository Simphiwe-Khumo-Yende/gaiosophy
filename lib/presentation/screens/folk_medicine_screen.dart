import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';
import '../widgets/enhanced_html_renderer.dart';
import '../theme/typography.dart';

class FolkMedicineScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;
  final String? parentFeaturedImageId;

  const FolkMedicineScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
    this.parentFeaturedImageId,
  });

  Widget _getImageWidget() {
    // PRIORITY 1: Try to get image from the first sub-block (block-level image)
    if (contentBlock.data.subBlocks.isNotEmpty) {
      final subBlock = contentBlock.data.subBlocks.first;
      if (subBlock.imageUrl != null && subBlock.imageUrl!.isNotEmpty) {
        // Check if it's a direct URL that needs to be converted
        if (subBlock.imageUrl!.startsWith('http')) {
          try {
            final uri = Uri.parse(subBlock.imageUrl!);
            String pathSegment = uri.path;
            
            // Remove leading slash
            if (pathSegment.startsWith('/')) {
              pathSegment = pathSegment.substring(1);
            }
            
            // Extract filename from paths like media/folk-medicine/filename.png
            final pathParts = pathSegment.split('/');
            if (pathParts.length > 0) {
              final filename = pathParts.last;
              // Remove file extension to get the ID
              final filenameWithoutExt = filename.split('.').first;
              
              print('🔄 Converting URL to Firebase Storage ID: $filenameWithoutExt');
              
              return FirebaseStorageImage(
                imageId: filenameWithoutExt,
                width: 180,
                height: 180,
                fit: BoxFit.cover,
                placeholder: _buildImagePlaceholder(),
                errorWidget: _buildImageErrorWidget(),
              );
            }
          } catch (e) {
            print('❌ Failed to parse image URL: $e');
            // Failed to parse URL - continue to fallback
          }
        }
        
        // Fallback to direct network loading for non-URL strings
        return Image.network(
          subBlock.imageUrl!,
          width: 180,
          height: 180,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 180,
              height: 180,
              child: _buildImagePlaceholder(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('❌ Failed to load image from network: $error');
            return SizedBox(
              width: 180,
              height: 180,
              child: _buildImageErrorWidget(),
            );
          },
        );
      }
    }
    
    // PRIORITY 2: Try to get featuredImageId from the content block
    final blockImageId = contentBlock.data.featuredImageId;
    if (blockImageId != null && blockImageId.isNotEmpty) {
      return FirebaseStorageImage(
        imageId: blockImageId,
        width: 180,
        height: 180,
        fit: BoxFit.cover,
        placeholder: _buildImagePlaceholder(),
        errorWidget: _buildImageErrorWidget(),
      );
    }
    
    // PRIORITY 3: Fall back to parent's featuredImageId (global)
    if (parentFeaturedImageId != null && parentFeaturedImageId!.isNotEmpty) {
      print('⚠️ Using parent/global image as fallback');
      return FirebaseStorageImage(
        imageId: parentFeaturedImageId!,
        width: 180,
        height: 180,
        fit: BoxFit.cover,
        placeholder: _buildImagePlaceholder(),
        errorWidget: _buildImageErrorWidget(),
      );
    }
    
    // No image found
    return Container(
      width: 180,
      height: 180,
      color: Colors.grey.withOpacity(0.2),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              // Title - Show plant part name instead of plant name
              Center(
                child: Text(
                  _getPlantPartName(),
                  style: TextStyle(
                    fontFamily: 'Roboto Serif',
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B5D4D),
                    letterSpacing: -0.02 * 30, // -2% of font size
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Circular Image - always show
              Center(
                child: ClipOval(
                  child: _getImageWidget(),
                ),
              ),
              const SizedBox(height: 32),

              // Content
              _buildFolkMedicineContent(context),
            ],
          ),
        ),
      ),
    );
  }

  // Get plant part name from subBlocks
  String _getPlantPartName() {
    if (contentBlock.data.subBlocks.isNotEmpty) {
      final subBlock = contentBlock.data.subBlocks.first;
      if (subBlock.plantPartName != null && subBlock.plantPartName!.isNotEmpty) {
        return subBlock.plantPartName!;
      }
    }
    return parentTitle; // fallback to parent title
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 180,
      height: 180,
      color: const Color(0xFF8B6B47).withOpacity(0.1),
      child: const Icon(
        Icons.spa_outlined,
        size: 48,
        color: Color(0xFF8B6B47),
      ),
    );
  }

  Widget _buildImageErrorWidget() {
    return Container(
      width: 180,
      height: 180,
      color: const Color(0xFF8B6B47).withOpacity(0.1),
      child: const Icon(
        Icons.broken_image_outlined,
        size: 48,
        color: Color(0xFF8B6B47),
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

            // Medicinal uses - only show if has valid content
            if (_hasValidContent(subBlock.medicinalUses)) ...[
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

            // Skincare uses - only show if has valid content
            if (_hasValidContent(subBlock.skincareUses)) ...[
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

            // Energetic uses - only show if has valid content
            if (_hasValidContent(subBlock.energeticUses)) ...[
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
    // Filter out empty or whitespace-only items
    final validUses = uses.where((use) {
      final cleaned = _stripHtml(use).trim();
      return cleaned.isNotEmpty;
    }).toList();

    if (validUses.isEmpty) {
      return const SizedBox.shrink();
    }

    // Combine all uses into a single HTML string to preserve rich formatting
    final combinedHtml = validUses.join('\n');
    
    // Check if content contains HTML tags (like <ul>, <li>, <p>, etc.)
    final hasHtmlTags = combinedHtml.contains(RegExp(r'<[^>]+>'));
    
    if (hasHtmlTags) {
      // Use EnhancedHtmlRenderer for rich HTML content
      return EnhancedHtmlRenderer(
        content: combinedHtml,
        textStyle: context.secondaryFont(
          fontSize: 14,
          color: const Color(0xFF3C3C3C),
          height: 1.5,
        ),
        iconSize: 16,
        iconColor: const Color(0xFF8B6B47),
      );
    }
    
    // Fall back to simple bullet list for plain text
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: validUses.map((use) {
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

  // Updated helper method to check if a list has meaningful content
  bool _hasValidContent(List<String> items) {
    if (items.isEmpty) return false;
    
    // Check if any item has actual content after stripping HTML and trimming
    return items.any((item) {
      final cleaned = _stripHtml(item).trim();
      return cleaned.isNotEmpty;
    });
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