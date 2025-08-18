import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/content_list_provider.dart';
import '../../data/models/content.dart' as content_model;
import '../theme/typography.dart';
import '../widgets/firebase_storage_image.dart';

class ContentScreen extends ConsumerStatefulWidget {
  const ContentScreen({super.key, required this.contentId});
  final String contentId;

  @override
  ConsumerState<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends ConsumerState<ContentScreen> {
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
    print('Content loading error: $error');
    
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
            const SizedBox(height: 8),
            Text(
              'Error: $error',
              style: context.secondaryBodySmall.copyWith(
                color: Colors.red.withValues(alpha: 0.7),
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
    final blocks = content.contentBlocks;
    
    // Debug: Print content info
    print('Content: ${content.title}');
    print('Content blocks count: ${blocks.length}');
    if (blocks.isNotEmpty) {
      print('First block: ${blocks.first.type} - ${blocks.first.data.title}');
    }
    
    if (blocks.isEmpty) {
      return _buildLegacyContentView(content);
    }

    // Sort blocks by order
    final sortedBlocks = [...blocks]..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: [
        // Content Header
        _buildContentHeader(content),
        
        // Paginated Content
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: sortedBlocks.length,
            itemBuilder: (context, index) => _buildContentBlock(sortedBlocks[index]),
          ),
        ),
        
        // Navigation Controls
        if (sortedBlocks.length > 1) _buildNavigationControls(sortedBlocks.length),
      ],
    );
  }

  Widget _buildContentHeader(content_model.Content content) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getContentTypeName(content.type),
              style: context.secondaryLabelSmall.copyWith(
                color: const Color(0xFF8B6B47),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Title
          Text(
            content.title,
            style: context.primaryTitleLarge.copyWith(
              color: const Color(0xFF1A1612),
              fontWeight: FontWeight.w700,
            ),
          ),
          
          // Summary
          if (content.summary != null) ...[
            const SizedBox(height: 8),
            Text(
              content.summary!,
              style: context.secondaryBodyMedium.copyWith(
                color: const Color(0xFF1A1612).withValues(alpha: 0.8),
              ),
            ),
          ],
          
          // Reading Time & Metadata
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: const Color(0xFF8B6B47).withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Text(
                '${_calculateReadingTime(content)} min read',
                style: context.secondaryLabelSmall.copyWith(
                  color: const Color(0xFF8B6B47).withValues(alpha: 0.7),
                ),
              ),
              if (content.season != null) ...[
                const SizedBox(width: 16),
                Icon(
                  Icons.spa,
                  size: 16,
                  color: const Color(0xFF8B6B47).withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  content.season!,
                  style: context.secondaryLabelSmall.copyWith(
                    color: const Color(0xFF8B6B47).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentBlock(content_model.ContentBlock block) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Block Header
          if (block.data.title != null) ...[
            Text(
              block.data.title!,
              style: context.primaryTitleMedium.copyWith(
                color: const Color(0xFF1A1612),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
          ],
          
          if (block.data.subtitle != null) ...[
            Text(
              block.data.subtitle!,
              style: context.secondaryBodyLarge.copyWith(
                color: const Color(0xFF1A1612).withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Featured Image
          if (block.data.featuredImageId != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FirebaseStorageImage(
                imageId: block.data.featuredImageId!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Content
          if (block.data.content != null) _buildHtmlContent(block.data.content!),
          
          // Gallery Images
          if (block.data.galleryImageIds.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildGallery(block.data.galleryImageIds),
          ],
        ],
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
        ),
        "h2": Style(
          color: const Color(0xFF1A1612),
          fontSize: FontSize(20),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 20, bottom: 10),
        ),
        "h3": Style(
          color: const Color(0xFF1A1612),
          fontSize: FontSize(18),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 16, bottom: 8),
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

  Widget _buildGallery(List<String> imageIds) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageIds.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: index < imageIds.length - 1 ? 12 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FirebaseStorageImage(
                imageId: imageIds[index],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationControls(int totalPages) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          IconButton(
            onPressed: _currentPage > 0
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: Icon(
              Icons.arrow_back_ios,
              color: _currentPage > 0
                  ? const Color(0xFF8B6B47)
                  : const Color(0xFF8B6B47).withValues(alpha: 0.3),
            ),
          ),
          
          // Page Indicators
          Row(
            children: List.generate(totalPages, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentPage
                      ? const Color(0xFF8B6B47)
                      : const Color(0xFF8B6B47).withValues(alpha: 0.3),
                ),
              );
            }),
          ),
          
          // Next Button
          IconButton(
            onPressed: _currentPage < totalPages - 1
                ? () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: _currentPage < totalPages - 1
                  ? const Color(0xFF8B6B47)
                  : const Color(0xFF8B6B47).withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegacyContentView(content_model.Content content) {
    return SingleChildScrollView(
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
          if (content.body != null) _buildHtmlContent(content.body!),
        ],
      ),
    );
  }

  String _getContentTypeName(content_model.ContentType type) {
    switch (type) {
      case content_model.ContentType.seasonal:
        return 'Seasonal';
      case content_model.ContentType.plant:
        return 'Plant Guide';
      case content_model.ContentType.recipe:
        return 'Recipe';
    }
  }

  int _calculateReadingTime(content_model.Content content) {
    int wordCount = 0;
    
    // Count words in content blocks
    for (final block in content.contentBlocks) {
      if (block.data.content != null) {
        // Remove HTML tags and count words
        final plainText = block.data.content!.replaceAll(RegExp(r'<[^>]*>'), '');
        wordCount += plainText.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
      }
    }
    
    // Fallback to body content for legacy content
    if (wordCount == 0 && content.body != null) {
      final plainText = content.body!.replaceAll(RegExp(r'<[^>]*>'), '');
      wordCount = plainText.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
    }
    
    // Average reading speed: 200 words per minute
    final readingTime = (wordCount / 200).ceil();
    return readingTime.clamp(1, 999);
  }
}

// Legacy class name alias for backward compatibility
class ContentDetailScreen extends ContentScreen {
  const ContentDetailScreen({super.key, required super.contentId});
}
