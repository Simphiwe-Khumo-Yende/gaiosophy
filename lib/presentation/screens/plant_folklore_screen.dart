import 'package:flutter/material.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';
import '../widgets/enhanced_html_renderer.dart';
import 'audio_player_screen.dart';

class PlantFolkloreScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const PlantFolkloreScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
              contentBlock.data.title ?? 'Folklore & Legends',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF1A1612),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Large Featured Image (Figma design style)
          _buildFeaturedImage(),
          
          // Content Preview Text
          _buildContentPreview(theme),
          
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
            ? FirebaseStorageImage(
                imageId: contentBlock.data.featuredImageId!,
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
      ),
    );
  }

  // Content preview text matching Figma design
  Widget _buildContentPreview(ThemeData theme) {
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        previewText,
        style: theme.textTheme.bodyLarge?.copyWith(
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
                backgroundColor: const Color(0xFF8B6B47),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'Read More',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
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
                backgroundColor: const Color(0xFF8B6B47).withValues(alpha: 0.8),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'Listen to Audio',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
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
        builder: (context) => PlantFolkloreDetailedView(
          contentBlock: contentBlock,
          parentTitle: parentTitle,
        ),
      ),
    );
  }

  void _playAudio(BuildContext context) {
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
      featuredImageId: contentBlock.data.featuredImageId,
      audioId: 'plant_${contentBlock.id}_folklore_audio', // Construct audio ID for folklore content
      published: true,
      contentBlocks: [contentBlock],
    );

    // Navigate to audio player screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AudioPlayerScreen(
          content: content,
          audioUrl: content.audioId,
        ),
      ),
    );
  }
}

// Detailed reading view for plant folklore
class PlantFolkloreDetailedView extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const PlantFolkloreDetailedView({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: Color(0xFF1A1612)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bookmark functionality coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contentBlock.data.title != null) ...[
              Text(
                contentBlock.data.title!,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
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
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF1A1612).withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (contentBlock.data.featuredImageId != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FirebaseStorageImage(
                  imageId: contentBlock.data.featuredImageId!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    width: double.infinity,
                    height: 250,
                    color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                    child: const Center(
                      child: Icon(
                        Icons.auto_fix_high,
                        size: 64,
                        color: Color(0xFF8B6B47),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (contentBlock.data.content != null) _buildDetailedHtmlContent(contentBlock.data.content!, theme),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailedHtmlContent(String htmlContent, ThemeData theme) {
    return EnhancedHtmlRenderer(
      content: htmlContent,
      iconSize: 20,
      iconColor: const Color(0xFF8B6B47),
    );
  }
}
