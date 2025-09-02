import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';

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
    print('=== FOLK MEDICINE SCREEN BUILD ===');
    print('ContentBlock ID: ${contentBlock.id}');
    print('ContentBlock Type: ${contentBlock.type}');
    print('ContentBlock Order: ${contentBlock.order}');
    print('Has subBlocks: ${contentBlock.data.subBlocks.isNotEmpty}');
    print('SubBlocks count: ${contentBlock.data.subBlocks.length}');
    print('Has HTML content: ${contentBlock.data.content != null && contentBlock.data.content!.isNotEmpty}');
    print('HTML content preview: ${contentBlock.data.content?.substring(0, min(100, contentBlock.data.content?.length ?? 0)) ?? "null"}');
    print('Has featuredImageId: ${contentBlock.data.featuredImageId != null && contentBlock.data.featuredImageId!.isNotEmpty}');
    print('=====================================');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0E8),
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
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF3C3C3C),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Image if available
              if (contentBlock.data.featuredImageId != null && contentBlock.data.featuredImageId!.isNotEmpty) ...[
                Center(
                  child: FirebaseStorageImage(
                    imageId: contentBlock.data.featuredImageId!,
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                      ),
                      child: const Icon(
                        Icons.spa_outlined,
                        size: 48,
                        color: Color(0xFF8B6B47),
                      ),
                    ),
                    errorWidget: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                      ),
                      child: const Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: Color(0xFF8B6B47),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Content
              _buildFolkMedicineContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFolkMedicineContent() {
    // Debug logging
    print('=== FOLK MEDICINE CONTENT DEBUG ===');
    print('ContentBlock ID: ${contentBlock.id}');
    print('ContentBlock Type: ${contentBlock.type}');
    print('ContentBlock Order: ${contentBlock.order}');
    print('Has subBlocks: ${contentBlock.data.subBlocks.isNotEmpty}');
    print('SubBlocks count: ${contentBlock.data.subBlocks.length}');
    print('Has HTML content: ${contentBlock.data.content != null && contentBlock.data.content!.isNotEmpty}');
    print('HTML content length: ${contentBlock.data.content?.length ?? 0}');
    print('=====================================');

    // Check if we have sub-blocks (specific plant parts)
    if (contentBlock.data.subBlocks.isNotEmpty) {
      return _buildSubBlocksContent();
    }

    // Fall back to HTML content if no sub-blocks
    String? htmlContent = contentBlock.data.content;

    if (htmlContent == null || htmlContent.isEmpty) {
      print('No content available, showing default content');
      return _buildDefaultContent();
    }

    print('Rendering HTML content');
    return Container(
      constraints: const BoxConstraints(minHeight: 200), // Ensure minimum height
      child: Html(
        data: htmlContent,
        style: {
          "body": Style(
            fontSize: FontSize(15),
            color: const Color(0xFF3C3C3C),
            lineHeight: LineHeight(1.6),
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
          "p": Style(
            fontSize: FontSize(15),
            color: const Color(0xFF3C3C3C),
            lineHeight: LineHeight(1.6),
            margin: Margins.only(bottom: 16),
          ),
          "h1": Style(
            fontSize: FontSize(18),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3C3C3C),
            margin: Margins.only(bottom: 16, top: 24),
          ),
          "h2": Style(
            fontSize: FontSize(16),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3C3C3C),
            margin: Margins.only(bottom: 12, top: 24),
          ),
          "h3": Style(
            fontSize: FontSize(15),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF3C3C3C),
            margin: Margins.only(bottom: 12, top: 20),
          ),
          "ul": Style(
            margin: Margins.only(left: 20, bottom: 16),
            padding: HtmlPaddings.zero,
          ),
          "ol": Style(
            margin: Margins.only(left: 20, bottom: 16),
            padding: HtmlPaddings.zero,
          ),
          "li": Style(
            fontSize: FontSize(15),
            color: const Color(0xFF3C3C3C),
            lineHeight: LineHeight(1.6),
            margin: Margins.only(bottom: 8),
          ),
          "strong": Style(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3C3C3C),
          ),
          "b": Style(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3C3C3C),
          ),
          "em": Style(
            fontStyle: FontStyle.italic,
            color: const Color(0xFF3C3C3C),
          ),
          "i": Style(
            fontStyle: FontStyle.italic,
            color: const Color(0xFF3C3C3C),
          ),
        },
        onLinkTap: (url, _, __) {
          // Handle link taps if needed
          print('Link tapped: $url');
        },
        extensions: [
          TagExtension(
            tagsToExtend: {"li"},
            builder: (extensionContext) {
              final element = extensionContext.element;
              if (element == null) return const SizedBox.shrink();

              // Simple list item rendering without complex icons for now
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF3C3C3C),
                        height: 1.6,
                      ),
                    ),
                    Expanded(
                      child: Html(
                        data: element.innerHtml,
                        style: {
                          "body": Style(
                            fontSize: FontSize(15),
                            color: const Color(0xFF3C3C3C),
                            lineHeight: LineHeight(1.6),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          "p": Style(
                            fontSize: FontSize(15),
                            color: const Color(0xFF3C3C3C),
                            lineHeight: LineHeight(1.6),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubBlocksContent() {
    print('=== BUILDING SUB BLOCKS CONTENT ===');
    print('Number of sub-blocks: ${contentBlock.data.subBlocks.length}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentBlock.data.subBlocks.map((subBlock) {
        print('Processing sub-block: ${subBlock.plantPartName}');
        print('Medicinal uses: ${subBlock.medicinalUses.length}');
        print('Skincare uses: ${subBlock.skincareUses.length}');
        print('Energetic uses: ${subBlock.energeticUses.length}');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicinal uses
            if (subBlock.medicinalUses.isNotEmpty) ...[
              const Text(
                'Medicinal Uses',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C3C3C),
                ),
              ),
              const SizedBox(height: 12),
              _buildSimpleUsesList(subBlock.medicinalUses),
              const SizedBox(height: 24),
            ],

            // Skincare uses
            if (subBlock.skincareUses.isNotEmpty) ...[
              const Text(
                'Skincare Uses',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C3C3C),
                ),
              ),
              const SizedBox(height: 12),
              _buildSimpleUsesList(subBlock.skincareUses),
              const SizedBox(height: 24),
            ],

            // Energetic uses (or Seed Oil as shown in design)
            if (subBlock.energeticUses.isNotEmpty) ...[
              Text(
                subBlock.plantPartName?.contains('Seed') == true ? 'Seed Oil' : 'Energetic Uses',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C3C3C),
                ),
              ),
              const SizedBox(height: 12),
              _buildSimpleUsesList(subBlock.energeticUses),
              const SizedBox(height: 24),
            ],
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSimpleUsesList(List<String> uses) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: uses.map((use) {
          // Clean the HTML content
          final cleanedUse = _stripHtml(use);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF3C3C3C),
                    height: 1.6,
                  ),
                ),
                Expanded(
                  child: Text(
                    cleanedUse,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF3C3C3C),
                      height: 1.6,
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
        .replaceAll('&rsquo;', "'");
    
    // Clean up extra whitespace
    stripped = stripped.trim().replaceAll(RegExp(r'\s+'), ' ');
    
    return stripped;
  }

  Widget _buildDefaultContent() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.spa_outlined,
              size: 48,
              color: Color(0xFF8B6B47),
            ),
            SizedBox(height: 16),
            Text(
              'Folk medicine content is being prepared.\nPlease check back later.',
              style: TextStyle(
                color: Color(0xFF3C3C3C),
                fontSize: 15,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'If you continue to see this message,\nthe content may not be available yet.',
              style: TextStyle(
                color: Color(0xFF8B6B47),
                fontSize: 13,
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