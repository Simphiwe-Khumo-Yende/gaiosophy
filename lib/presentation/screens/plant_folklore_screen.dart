import 'package:flutter/material.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';
import '../widgets/enhanced_html_renderer.dart';
import '../widgets/bookmark_button.dart';
import '../theme/typography.dart';
import '../theme/app_theme.dart';
import 'audio_player_screen.dart';

class PlantFolkloreScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;
  final String? parentFeaturedImageId;

  const PlantFolkloreScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
    this.parentFeaturedImageId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          const SizedBox(height: 40),
          // Title on top of featured image
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              contentBlock.data.title ?? 'Folklore & Legends',
              textAlign: TextAlign.center,
              style: AppTheme.screenHeadingStyle,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Large Featured Image (Figma design style)
          _buildFeaturedImage(),
          
          // Content Preview Text
          _buildContentPreview(context),
          
          // Action Buttons closer to content
          _buildActionButtons(context, theme),
          
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
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.home, color: Color(0xFF1A1612)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  // Large featured image matching Figma design
  Widget _buildFeaturedImage() {
    // Use content block's featured image if available, otherwise fall back to parent's
    final imageId = contentBlock.data.featuredImageId ?? parentFeaturedImageId;
    
    return Container(
      height: 345,
      width: 247,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: imageId != null
          ? FirebaseStorageImage(
              imageId: imageId,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: Container(
                  color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B6B47)),
                    ),
                  ),
                ),
                errorWidget: Container(
                  color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                  child: const Center(
                    child: Icon(
                      Icons.auto_fix_high,
                      size: 64,
                      color: Color(0xFF8B6B47),
                    ),
                  ),
                ),
              )
          : Container(
              color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
              child: const Center(
                child: Icon(
                  Icons.auto_fix_high,
                  size: 64,
                  color: Color(0xFF8B6B47),
                ),
              ),
            ),
    );
  }

  // Content preview text matching Figma design
  Widget _buildContentPreview(BuildContext context) {
    String? fullText = contentBlock.data.content;
    
    // Extract first two lines and add "..."
    String previewText = 'Discover the magical folklore and legends surrounding this plant...';
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
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
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

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
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
          
          // Only show Listen to Audio button if audio is available
          if (contentBlock.audioId != null && contentBlock.audioId!.isNotEmpty) ...[
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
        ],
      ),
    );
  }

  void _navigateToDetailedReading(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PlantFolkloreDetailedView(
          contentBlock: contentBlock,
          parentTitle: parentTitle,
          parentFeaturedImageId: parentFeaturedImageId,
        ),
      ),
    );
  }

  void _playAudio(BuildContext context) {
    // Check if this content block has audio
    if (contentBlock.audioId == null || contentBlock.audioId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No audio available for this content.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Create a Content object from the ContentBlock data for the AudioPlayerScreen
    final content = content_model.Content(
      id: contentBlock.id,
      type: content_model.ContentType.plant,
      title: contentBlock.data.title ?? parentTitle,
      slug: contentBlock.id,
      summary: contentBlock.data.content != null 
          ? contentBlock.data.content!.replaceAll(RegExp(r'<[^>]*>'), '').substring(0, 
              contentBlock.data.content!.length > 100 ? 100 : contentBlock.data.content!.length)
          : null,
      body: contentBlock.data.content,
      featuredImageId: contentBlock.data.featuredImageId ?? parentFeaturedImageId,
      audioId: null, // Set to null so it's different from audioUrl
      published: true,
      contentBlocks: [contentBlock],
    );

    // Navigate to audio player screen with block audio
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => AudioPlayerScreen(
          content: content,
          audioUrl: contentBlock.audioId, // Pass block audioId as audioUrl for block audio detection
        ),
      ),
    );
  }
}

// Detailed reading view for plant folklore
class PlantFolkloreDetailedView extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;
  final String? parentFeaturedImageId;

  const PlantFolkloreDetailedView({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
    this.parentFeaturedImageId,
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
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (contentBlock.data.title != null) ...[
              Text(
                contentBlock.data.title!,
                textAlign: TextAlign.center,
                style: AppTheme.screenHeadingStyle,
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

            if (contentBlock.data.content != null) _buildDetailedHtmlContent(contentBlock.data.content!),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailedHtmlContent(String htmlContent) {
    return EnhancedHtmlRenderer(
      content: htmlContent,
      iconSize: 20,
      iconColor: const Color(0xFF8B6B47),
    );
  }

  // Helper method to create a Content object from ContentBlock for bookmark functionality
  content_model.Content _createContentFromBlock() {
    return content_model.Content(
      id: contentBlock.id,
      title: contentBlock.data.title ?? 'Plant Folklore',
      slug: 'plant-folklore-${contentBlock.id}',
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
