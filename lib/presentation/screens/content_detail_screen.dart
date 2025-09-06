import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/content_list_provider.dart';
import '../../data/models/content.dart' as content_model;
import '../theme/typography.dart';
import '../widgets/firebase_storage_image.dart';
import '../widgets/bookmark_button.dart';
import '../widgets/rich_content_text.dart';
import '../widgets/content_icon_mapper.dart';
import 'audio_player_screen.dart';
import 'plant_allies_detail_screen.dart';
import 'recipe_screen.dart';

class ContentScreen extends ConsumerStatefulWidget {
  const ContentScreen({super.key, required this.contentId});
  final String contentId;

  @override
  ConsumerState<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends ConsumerState<ContentScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(contentDetailProvider(widget.contentId));

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: _buildAppBar(context),
      body: contentAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B6B47)),
          ),
        ),
        error: (error, stack) => _buildErrorView(error),
        data: (content) => _buildContentView(content),
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

  Widget _buildErrorView(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: const Color(0xFF8B6B47).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Content Not Found',
              style: context.primaryTitleLarge.copyWith(
                color: const Color(0xFF1A1612),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The content you\'re looking for could not be loaded.',
              style: context.secondaryBodyMedium.copyWith(
                color: const Color(0xFF1A1612).withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B6B47),
                foregroundColor: Colors.white,
              ),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView(content_model.Content content) {
    // Check content type and route to appropriate screen
    if (content.type == content_model.ContentType.plant) {
      // For plant allies content, use the new specialized screen
      return PlantAlliesDetailScreen(content: content);
    } else if (content.type == content_model.ContentType.recipe) {
      // For recipe content, use the recipe screen
      return RecipeScreen(content: content);
    }
    
    // For seasonal wisdom and other content types, use the original layout
    final blocks = content.contentBlocks;
    
    if (blocks.isEmpty) {
      return _buildLegacyContentView(content);
    }

    // Note: Blocks available but using Figma design layout instead
    // final sortedBlocks = [...blocks]..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: [

        const Spacer(),
        
        const SizedBox(height: 24),
        // Title on top of featured image
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            content.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1A1612),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Large Featured Image (Figma design style)
        _buildFeaturedImage(content),
        
        // Content Preview Text
        _buildContentPreview(content),
        
        // Action Buttons closer to content
        _buildActionButtons(content),
        
        // Spacer to fill remaining space
        const Spacer(),
        
        const SizedBox(height: 24), // Bottom padding
      ],
    );
  }

  // Large featured image matching Figma design
  Widget _buildFeaturedImage(content_model.Content content) {
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
        child: content.featuredImageId != null
            ? FirebaseStorageImage(
                imageId: content.featuredImageId!,
                fit: BoxFit.cover,
              )
            : Container(
                color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: Color(0xFF8B6B47),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildContentPreview(content_model.Content content) {
    String? fullText;
    
    // Prioritize first content block (introduction) over summary or body
    if (content.contentBlocks.isNotEmpty) {
      fullText = content.contentBlocks.first.data.content;
    } else if (content.summary != null) {
      fullText = content.summary;
    } else {
      fullText = content.body;
    }
    
    // Extract first two lines and add "..."
    String previewText = 'No content available';
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
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Color(0xFF1A1612),
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildHtmlContent(String htmlContent) {
    return Html(
      data: htmlContent,
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: const Color(0xFF1A1612),
          fontSize: FontSize(16),
          lineHeight: LineHeight(1.6),
        ),
        "h1": Style(
          color: const Color(0xFF1A1612),
          fontSize: FontSize(24),
          fontWeight: FontWeight.w700,
          margin: Margins.only(top: 24, bottom: 12),
          textAlign: TextAlign.center,
        ),
        "h2": Style(
          color: const Color(0xFF1A1612),
          fontSize: FontSize(20),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 20, bottom: 10),
          textAlign: TextAlign.center,
        ),
        "h3": Style(
          color: const Color(0xFF1A1612),
          fontSize: FontSize(18),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 16, bottom: 8),
          textAlign: TextAlign.center,
        ),
        "p": Style(
          margin: Margins.only(bottom: 16),
          color: const Color(0xFF1A1612),
        ),
        "a": Style(
          color: const Color(0xFF8B6B47),
          textDecoration: TextDecoration.underline,
        ),
        "blockquote": Style(
          backgroundColor: const Color(0xFF8B6B47).withValues(alpha: 0.05),
          border: Border(
            left: BorderSide(color: const Color(0xFF8B6B47), width: 4),
          ),
          padding: HtmlPaddings.all(16),
          margin: Margins.only(bottom: 16),
          fontStyle: FontStyle.italic,
        ),
        "ul": Style(
          margin: Margins.only(bottom: 16),
        ),
        "ol": Style(
          margin: Margins.only(bottom: 16),
        ),
        "li": Style(
          margin: Margins.only(bottom: 4),
        ),
      },
    );
  }

  // Method to handle content with icon keys - will try rich content first, fallback to HTML
  Widget _buildContentWithIcons(String content) {
    // Check if content contains icon keys [key]
    final RegExp iconRegex = RegExp(r'\[([^\]]+)\]');
    final hasIcons = iconRegex.hasMatch(content);
    
    if (hasIcons) {
      // If it looks like HTML content (contains tags), we need special handling
      if (content.contains('<') && content.contains('>')) {
        return _buildHtmlContentWithIcons(content);
      } else {
        // Use rich content text for plain text with icon parsing
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: RichContentText(
            content,
            textStyle: context.secondaryFont(
              fontSize: 16,
              color: const Color(0xFF1A1612),
              height: 1.6,
            ),
            iconSize: 20,
            iconColor: const Color(0xFF8B6B47),
          ),
        );
      }
    } else {
      // Fallback to HTML rendering
      return _buildHtmlContent(content);
    }
  }

  // Special method to handle HTML content that contains icon keys
  Widget _buildHtmlContentWithIcons(String htmlContent) {
    // Preprocess the HTML to replace icon keys with placeholder text that we can style
    String processedHtml = _replaceIconKeysInHtml(htmlContent);
    
    return Html(
      data: processedHtml,
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: const Color(0xFF1A1612),
          fontSize: FontSize(16),
          lineHeight: LineHeight(1.6),
        ),
        "p": Style(
          margin: Margins.only(bottom: 16),
          color: const Color(0xFF1A1612),
        ),
        "ul": Style(
          margin: Margins.only(bottom: 16),
        ),
        "li": Style(
          margin: Margins.only(bottom: 4),
        ),
        ".icon": Style(
          color: const Color(0xFF8B6B47),
          fontWeight: FontWeight.bold,
        ),
      },
    );
  }

  // Helper method to replace icon keys with styled spans in HTML
  String _replaceIconKeysInHtml(String htmlContent) {
    final RegExp iconRegex = RegExp(r'\[([^\]]+)\]');
    return htmlContent.replaceAllMapped(iconRegex, (match) {
      final iconKey = match.group(1)!.toLowerCase();
      if (ContentIconMapper.hasIcon(iconKey)) {
        // Replace with a styled span that includes an icon symbol
        // Using Unicode symbols as a fallback since we can't embed Flutter icons in HTML
        final iconSymbol = _getIconSymbol(iconKey);
        return '<span class="icon">$iconSymbol</span>';
      } else {
        // Keep original text if icon not found
        return match.group(0)!;
      }
    });
  }

  // Helper method to get Unicode symbols for icons (fallback for HTML rendering)
  String _getIconSymbol(String iconKey) {
    const Map<String, String> iconSymbols = {
      'mountain': '⛰️',
      'tree': '🌲',
      'flower': '🌸',
      'herb': '🌿',
      'leaf': '🍃',
      'sun': '☀️',
      'morning': '🌅',
      'evening': '🌆',
      'night': '🌙',
      'water': '💧',
      'tea': '🍵',
      'healing': '💚',
      'safe': '✅',
      'caution': '⚠️',
      'danger': '⚠️',
      'toxic': '☠️',
      'medicine': '💊',
      'forest': '🌲',
      'meadow': '🌾',
      'garden': '🏡',
      'harvest': '🌾',
      'fresh': '🌱',
      'dried': '🍂',
      'oil': '🫗',
      'powder': '🥄',
      'compress': '🩹',
      'massage': '💆',
      'scalp': '👤',
      'hair': '💇',
      'wash': '🚿',
      'rinse': '💧',
      'store': '📦',
      'fridge': '🧊',
      'days': '📅',
      'time': '⏰',
      'best': '⭐',
      'results': '✅',
      'traditional': '📜',
      'usage': 'ℹ️',
    };
    
    return iconSymbols[iconKey] ?? '🔹';
  }

  Widget _buildActionButtons(content_model.Content content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 90),
      child: Column(
        children: [
          // Read More Button (Primary)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _navigateToDetailedReading(content);
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
              child: const Text(
                'Read More',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
                _playAudio(content);
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
              child: const Text(
                'Listen to Audio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailedReading(content_model.Content content) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailedReadingView(content: content),
      ),
    );
  }

  void _playAudio(content_model.Content content) {
    // Navigate to audio player screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AudioPlayerScreen(
          content: content,
          audioUrl: content.audioId,  // Use audioId instead of media array
        ),
      ),
    );
  }

  Widget _buildLegacyContentView(content_model.Content content) {
    return Column(
      children: [
        // Action Buttons (Read More & Audio)
        _buildActionButtons(content),
        
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Image
                if (content.featuredImageId != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FirebaseStorageImage(
                      imageId: content.featuredImageId!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Body Content
                if (content.body != null) _buildContentWithIcons(content.body!),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Detailed reading view for full content display
class DetailedReadingView extends StatefulWidget {
  final content_model.Content content;

  const DetailedReadingView({super.key, required this.content});

  @override
  State<DetailedReadingView> createState() => _DetailedReadingViewState();
}

class _DetailedReadingViewState extends State<DetailedReadingView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blocks = widget.content.contentBlocks.isEmpty
        ? _createLegacyBlocks(widget.content)
        : [...widget.content.contentBlocks]..sort((a, b) => a.order.compareTo(b.order));

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
            content: widget.content,
            iconColor: const Color(0xFF1A1612),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: blocks.length,
              physics: const BouncingScrollPhysics(),
              pageSnapping: true,
              allowImplicitScrolling: true,
              itemBuilder: (context, index) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.3, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    )),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: _buildDetailedPageContent(blocks[index]),
              ),
            ),
          ),
          if (blocks.length > 1) _buildDetailedPageIndicator(blocks.length),
        ],
      ),
    );
  }

  Widget _buildDetailedPageContent(content_model.ContentBlock block) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.data.title != null) ...[
            Text(
              block.data.title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1612),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (block.data.subtitle != null) ...[
            Text(
              block.data.subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF1A1612).withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
          ],

          if (block.data.featuredImageId != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FirebaseStorageImage(
                imageId: block.data.featuredImageId!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
          ],

          if (block.data.content != null) _buildDetailedHtmlContent(block.data.content!),
        ],
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

  Widget _buildDetailedPageIndicator(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPages, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentPage == index
                  ? const Color(0xFF8B6B47)
                  : const Color(0xFF8B6B47).withValues(alpha: 0.3),
            ),
          );
        }),
      ),
    );
  }

  // Create content blocks from legacy content structure
  List<content_model.ContentBlock> _createLegacyBlocks(content_model.Content content) {
    final blocks = <content_model.ContentBlock>[];

    // Create a single block from legacy content
    blocks.add(
      content_model.ContentBlock(
        id: 'legacy-${content.id}',
        type: 'text',
        order: 0,
        data: content_model.ContentBlockData(
          title: content.title,
          subtitle: content.summary,
          content: content.body,
          featuredImageId: content.featuredImageId,
          galleryImageIds: const [],
        ),
      ),
    );

    return blocks;
  }
}

// Legacy class name alias for backward compatibility
class ContentDetailScreen extends ContentScreen {
  const ContentDetailScreen({super.key, required super.contentId});
}
