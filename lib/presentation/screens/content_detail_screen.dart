// ignore_for_file: unused_element, unused_import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/content_list_provider.dart';
import '../../application/providers/network_connectivity_provider.dart';
import '../../data/models/content.dart' as content_model;
import '../theme/typography.dart';
import '../theme/app_theme.dart';
import '../widgets/firebase_storage_image.dart';
import '../widgets/bookmark_button.dart';
import '../widgets/content_box_parser.dart';
import '../widgets/content_icon_mapper.dart';
import '../widgets/enhanced_html_renderer.dart';
import 'audio_player_screen.dart';
import 'plant_allies_detail_screen.dart';
import 'recipe_screen.dart';

class ContentScreen extends ConsumerStatefulWidget {
  const ContentScreen({super.key, required this.contentId, this.initialContent});
  final String contentId;
  // Optional initial content passed via routing `extra` to avoid re-fetching
  // when we already have the content object (e.g., from search results).
  final content_model.Content? initialContent;

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
    // If an initialContent was provided via navigation `extra`, only use it
    // directly when it's sufficiently populated (has content blocks or body/summary).
    // Otherwise fall back to fetching the full content via the provider so
    // the detail screens receive the complete data they expect.
    final initial = widget.initialContent;
    final bool hasUsefulInitial = initial != null && (
      (initial.contentBlocks.isNotEmpty) ||
      ((initial.body ?? '').trim().isNotEmpty) ||
      ((initial.summary ?? '').trim().isNotEmpty)
    );

    if (hasUsefulInitial) {
      final content = initial;
      return Scaffold(
        backgroundColor: const Color(0xFFFCF9F2),
        appBar: _buildAppBar(context, false),
        body: _buildContentView(content),
      );
    }

    // Try real-time first, with automatic fallback
    final contentAsync = ref.watch(realTimeContentDetailProvider(widget.contentId));
    final isOffline = ref.watch(isOfflineProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: _buildAppBar(context, isOffline),
      body: contentAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B6B47)),
          ),
        ),
        error: (error, stack) {
          return _buildFallbackContent(context);
        },
        data: (content) => content != null 
            ? _buildContentView(content)
            : _buildFallbackContent(context),
      ),
    );
  }

  Widget _buildFallbackContent(BuildContext context) {
    final fallbackAsync = ref.watch(contentDetailProvider(widget.contentId));
    
    return fallbackAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B6B47)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading with fallback method...',
              style: TextStyle(
                color: Color(0xFF8B6B47),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => _buildErrorView(error),
      data: (content) => _buildContentView(content),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isOffline) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1612)),
        onPressed: () => context.pop(),
      ),
      title: isOffline
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off, size: 16, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    'Offline',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : null,
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

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Title on top of featured image
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              content.title,
              textAlign: TextAlign.center,
              style: AppTheme.screenHeadingStyle,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Large Featured Image (Figma design style)
          _buildFeaturedImage(content),
          
          // Content Preview Text
          _buildContentPreview(content),
          
          // Action Buttons closer to content
          _buildActionButtons(content),
          
          const SizedBox(height: 24), // Bottom padding
        ],
      ),
    );
  }

  // Large featured image matching Figma design
  Widget _buildFeaturedImage(content_model.Content content) {
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

  Widget _buildHtmlContent(String htmlContent) {
    return ContentDetailHtmlRenderer(
      content: htmlContent,
      iconSize: 20,
      iconColor: const Color(0xFF8B6B47),
    );
  }

  // Method to handle content with icon keys and HTML - now using enhanced renderer
  Widget _buildContentWithIcons(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ContentDetailHtmlRenderer(
        content: content,
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

  // Special method to handle HTML content that contains icon keys
  Widget _buildHtmlContentWithIcons(String htmlContent) {
    return ContentDetailHtmlRenderer(
      content: htmlContent,
      iconSize: 20,
      iconColor: const Color(0xFF8B6B47),
    );
  }

  Widget _buildActionButtons(content_model.Content content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 90),
      child: Column(
        children: [
          // Read More Button (Primary) - text changes based on ritual property
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _navigateToDetailedReading(content);
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
                // Use ritual field: true = "The Ritual", false/null = "Read More"
                content.ritual == true ? 'The Ritual' : 'Read More',
                style: AppTheme.buttonTextStyle,
              ),
            ),
          ),
          
          // Show audio button when ritual is not true (includes false and null cases)
          // When ritual field is not found (null), show both buttons (default behavior)
          if (content.ritual != true) ...[
            const SizedBox(height: 12),
            
            // Listen to Audio Button (Secondary)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _playAudio(content);
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

  void _navigateToDetailedReading(content_model.Content content) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DetailedReadingView(content: content),
      ),
    );
  }

  void _playAudio(content_model.Content content) {
    // Navigate to audio player screen
    Navigator.of(context).push(
      MaterialPageRoute<void>(
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(48, 40, 48, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
          if (block.data.title != null) ...[
                Text(
                  block.data.title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'RobotoSerif',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF000000),
                    height: 1.2,
                  ),
                ),
            const SizedBox(height: 12),
          ],

          // Audio button - show if button exists, show is true, and action is play_audio
          if (block.button != null && 
              block.button!.show && 
              block.button!.action == 'play_audio') ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _playAudioFromBlock(block),
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
                    block.button!.text.isNotEmpty ? block.button!.text : 'Listen to Audio',
                    style: AppTheme.buttonTextStyle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (block.data.subtitle != null) ...[
            Text(
              block.data.subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'PublicSans',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xFF25221E),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
          ],

          if (block.data.content != null) _buildDetailedHtmlContent(block.data.content!),
        ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailedHtmlContent(String htmlContent) {
    return ContentDetailHtmlRenderer(
      content: htmlContent,
      textStyle: const TextStyle(
        fontFamily: 'PublicSans',
        fontWeight: FontWeight.w400,
        fontSize: 15,
        color: Color(0xFF25221E),
        height: 1.6,
      ),
      iconSize: 20,
      iconColor: const Color(0xFF8B6B47),
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

  void _playAudioFromBlock(content_model.ContentBlock block) {
    // Use the block's audioId if available, otherwise fall back to content audioId
    final blockAudioId = block.audioId ?? widget.content.audioId ?? 'default_audio';
    
    // Create a Content object from the ContentBlock for audio playback
    // Set audioId to null to ensure the audioUrl parameter is recognized as block audio
    final content = content_model.Content(
      id: block.id,
      type: content_model.ContentType.seasonal,
      title: block.data.title ?? widget.content.title,
      slug: block.id,
      summary: block.data.subtitle,
      body: block.data.content,
      featuredImageId: widget.content.featuredImageId, // Always use content's image
      audioId: null, // Set to null so audioUrl is recognized as block audio
      published: true,
      contentBlocks: [block],
    );

    // Navigate to audio player screen
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => AudioPlayerScreen(
          content: content,
          audioUrl: blockAudioId, // Pass block audio ID as audioUrl parameter
        ),
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
        // Add audio button if content has audioId
        button: content.audioId != null ? content_model.ContentBlockButton(
          action: 'play_audio',
          show: true,
          text: 'Listen to Audio',
        ) : null,
        audioId: content.audioId,
      ),
    );

    return blocks;
  }
}

// Legacy class name alias for backward compatibility
class ContentDetailScreen extends ContentScreen {
  const ContentDetailScreen({super.key, required super.contentId});
}
