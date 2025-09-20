import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/bookmark_button.dart';
import '../theme/typography.dart';
import '../theme/app_theme.dart';

class PlantOverviewScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const PlantOverviewScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          const Spacer(),
          
          const SizedBox(height: 24),
          // Title on top of featured image
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              contentBlock.data.title ?? 'Plant Overview',
              textAlign: TextAlign.center,
              style: AppTheme.screenHeadingStyle,
            ),
          ),
          
          // Large Featured Image (Figma design style)
          _buildFeaturedImage(),
          
          // Content Preview Text
          _buildContentPreview(context),
          
          // Action Buttons closer to content
          _buildActionButtons(context),
          
          // Spacer to fill remaining space
          const Spacer(),
          
          const SizedBox(height: 24), // Bottom padding
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1612)),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.home, color: Color(0xFF1A1612)),
          onPressed: () => context.go('/'),
        ),
      ],
    );
  }

  // Large featured image matching Figma design
  Widget _buildFeaturedImage() {
    return Container(
      height: 300, // Large height as shown in Figma
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: contentBlock.data.featuredImageId != null
            ? Image.network(
                contentBlock.data.featuredImageId!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B6B47)),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                    child: const Center(
                      child: Icon(
                        Icons.eco,
                        size: 64,
                        color: Color(0xFF8B6B47),
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                child: const Center(
                  child: Icon(
                    Icons.eco,
                    size: 64,
                    color: Color(0xFF8B6B47),
                  ),
                ),
              ),
      ),
    );
  }

  // Content preview text matching Figma design
  Widget _buildContentPreview(BuildContext context) {
    String? fullText = contentBlock.data.content;
    
    // Extract first two lines and add "..."
    String previewText = 'Discover the fascinating world of plants and their unique characteristics...';
    if (fullText != null && fullText.isNotEmpty) {
      // Remove HTML tags first
      final plainText = fullText.replaceAll(RegExp(r'<[^>]*>'), '');
      final lines = plainText.split('\n').where((line) => line.trim().isNotEmpty).toList();
      
      if (lines.isNotEmpty) {
        if (lines.length >= 2) {
          previewText = '${lines[0].trim()}\n${lines[1].trim()}...';
        } else {
          previewText = '${lines[0].trim()}...';
        }
      }
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        previewText,
        style: context.secondaryFont(
          fontSize: 16,
          height: 1.5,
          color: const Color(0xFF1A1612),
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 90),
      child: Column(
        children: [
          // Read More Button (Primary)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _navigateToDetailedReading(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.readMoreButtonColor,
                foregroundColor: AppTheme.buttonTextColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'Read More',
                style: AppTheme.buttonTextStyle,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Listen to Audio Button (Secondary)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _playAudio(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.listenToAudioButtonColor,
                foregroundColor: AppTheme.buttonTextColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'Listen to Audio',
                style: AppTheme.buttonTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailedReading(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlantOverviewDetailedView(
          contentBlock: contentBlock,
          parentTitle: parentTitle,
        ),
      ),
    );
  }

  void _playAudio(BuildContext context) {
    // TODO: Implement audio playback for plant overview
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Audio feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// Detailed reading view for plant overview
class PlantOverviewDetailedView extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const PlantOverviewDetailedView({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1612)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        actions: [
          BookmarkButton(
            content: _createContentFromBlock(),
            iconColor: const Color(0xFF1A1612),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (contentBlock.data.title != null) ...[
              Text(
                contentBlock.data.title!,
                textAlign: TextAlign.center,
                style: context.primaryFont(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1612),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (contentBlock.data.subtitle != null) ...[
              Text(
                contentBlock.data.subtitle!,
                textAlign: TextAlign.center,
                style: context.secondaryFont(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF1A1612).withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (contentBlock.data.featuredImageId != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  contentBlock.data.featuredImageId!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                      child: const Center(
                        child: Icon(
                          Icons.eco,
                          size: 64,
                          color: Color(0xFF8B6B47),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (contentBlock.data.content != null) _buildDetailedHtmlContent(contentBlock.data.content!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedHtmlContent(String htmlContent) {
    return Html(
      data: htmlContent,
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: const Color(0xFF1A1612),
          fontSize: FontSize(16),
          lineHeight: LineHeight(1.8),
        ),
        "h1": Style(
          color: const Color(0xFF1A1612),
          fontSize: FontSize(26),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 24, bottom: 16),
          textAlign: TextAlign.center,
        ),
        "h2": Style(
          color: const Color(0xFF1A1612),
          fontSize: FontSize(22),
          fontWeight: FontWeight.w500,
          margin: Margins.only(top: 20, bottom: 12),
          textAlign: TextAlign.center,
        ),
        "h3": Style(
          color: const Color(0xFF1A1612),
          fontSize: FontSize(18),
          fontWeight: FontWeight.w500,
          margin: Margins.only(top: 16, bottom: 8),
          textAlign: TextAlign.center,
        ),
        "p": Style(
          margin: Margins.only(bottom: 16),
          color: const Color(0xFF1A1612),
          fontSize: FontSize(16),
          lineHeight: LineHeight(1.8),
        ),
        "a": Style(
          color: const Color(0xFF8B6B47),
          textDecoration: TextDecoration.underline,
        ),
        "blockquote": Style(
          backgroundColor: const Color(0xFF8B6B47).withValues(alpha: 0.05),
          border: Border(
            left: BorderSide(color: const Color(0xFF8B6B47), width: 3),
          ),
          padding: HtmlPaddings.all(16),
          margin: Margins.symmetric(vertical: 16),
          fontStyle: FontStyle.italic,
        ),
      },
    );
  }

  // Helper method to create a Content object from ContentBlock for bookmark functionality
  content_model.Content _createContentFromBlock() {
    return content_model.Content(
      id: contentBlock.id,
      title: contentBlock.data.title ?? 'Plant Overview',
      slug: 'plant-overview-fixed-${contentBlock.id}',
      summary: contentBlock.data.subtitle ?? '',
      body: contentBlock.data.content ?? '',
      type: content_model.ContentType.plant,
      featuredImageId: contentBlock.data.featuredImageId,
      contentBlocks: [contentBlock],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
