import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';
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
        "ul": Style(
          color: const Color(0xFF1A1612),
          margin: Margins.only(left: 16, bottom: 12),
          padding: HtmlPaddings.zero,
        ),
        "ol": Style(
          color: const Color(0xFF1A1612),
          margin: Margins.only(left: 16, bottom: 12),
          padding: HtmlPaddings.zero,
        ),
        "li": Style(
          color: const Color(0xFF1A1612),
          margin: Margins.only(bottom: 8),
          padding: HtmlPaddings.zero,
        ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"li"},
          builder: (extensionContext) {
            final element = extensionContext.element;
            final text = element?.text ?? '';
            
            IconData icon = Icons.circle;
            if (text.toLowerCase().contains('magic') || 
                text.toLowerCase().contains('ritual') ||
                text.toLowerCase().contains('spell')) {
              icon = Icons.auto_fix_high;
            } else if (text.toLowerCase().contains('herb') || 
                       text.toLowerCase().contains('plant') ||
                       text.toLowerCase().contains('flower')) {
              icon = Icons.grass;
            } else if (text.toLowerCase().contains('moon') || 
                       text.toLowerCase().contains('night') ||
                       text.toLowerCase().contains('dark')) {
              icon = Icons.nightlight;
            } else if (text.toLowerCase().contains('sun') || 
                       text.toLowerCase().contains('day') ||
                       text.toLowerCase().contains('light')) {
              icon = Icons.wb_sunny;
            } else if (text.toLowerCase().contains('water') || 
                       text.toLowerCase().contains('river') ||
                       text.toLowerCase().contains('sea')) {
              icon = Icons.water;
            } else if (text.toLowerCase().contains('fire') || 
                       text.toLowerCase().contains('flame')) {
              icon = Icons.local_fire_department;
            } else if (text.toLowerCase().contains('earth') || 
                       text.toLowerCase().contains('ground') ||
                       text.toLowerCase().contains('soil')) {
              icon = Icons.terrain;
            } else if (text.toLowerCase().contains('air') || 
                       text.toLowerCase().contains('wind') ||
                       text.toLowerCase().contains('sky')) {
              icon = Icons.air;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: const Color(0xFF8B6B47),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF1A1612),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
