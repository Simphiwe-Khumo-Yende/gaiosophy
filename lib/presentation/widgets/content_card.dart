import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart';
import '../theme/typography.dart';
import 'firebase_storage_image.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key, 
    required this.content,
  });
  
  final Content content;

  @override
  Widget build(BuildContext context) {
    // Use different designs based on content type
    if (content.type == ContentType.plant) {
      return _buildPlantAllyCard(context);
    }
    
    return _buildStandardCard(context);
  }

  Widget _buildStandardCard(BuildContext context) {
    String? subtitleText = (content.subtitle ?? content.summary)?.trim();
    if (subtitleText == null || subtitleText.isEmpty) {
      if (content.contentBlocks.isNotEmpty) {
        final first = content.contentBlocks.first;
        subtitleText = (first.data.subtitle ?? first.data.title ?? first.data.content)?.trim();
      }
    }

  return GestureDetector(
    onTap: () => context.push('/content/${content.id}'),
    child: Container(
      width: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFFCF9F2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full image taking up most of the card
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: AspectRatio(
              aspectRatio: 1.1, // Slightly taller than before (was 1.3)
              child: content.featuredImageId != null
                  ? FirebaseStorageImage(
                      imageId: content.featuredImageId!,
                      fit: BoxFit.cover,
                      placeholder: _buildStandardPlaceholder(),
                      errorWidget: _buildStandardErrorWidget(),
                    )
                  : _buildStandardPlaceholder(),
            ),
          ),
          // Title and optional subtitle below image
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  style: context.primaryFont(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1612),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitleText != null && subtitleText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitleText,
                    style: context.secondaryFont(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1A1612).withOpacity(0.75),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPlantAllyCard(BuildContext context) {
  String? subtitleText = (content.subtitle ?? content.summary)?.trim();
  if (subtitleText == null || subtitleText.isEmpty) {
    if (content.contentBlocks.isNotEmpty) {
      final first = content.contentBlocks.first;
      subtitleText = (first.data.subtitle ?? first.data.title ?? first.data.content)?.trim();
    }
  }

  return GestureDetector(
    onTap: () => context.push('/content/${content.id}'),
    child: Container(
      width: 180, // Much wider than standard cards (130px)
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Slightly more rounded
        color: const Color(0xFFFCF9F2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Taller portrait artwork
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 0.8, // Portrait ratio (5:6)
              child: content.featuredImageId != null
                  ? FirebaseStorageImage(
                      imageId: content.featuredImageId!,
                      fit: BoxFit.cover,
                      placeholder: _buildPlantPlaceholder(),
                      errorWidget: _buildPlantErrorWidget(),
                    )
                  : _buildPlantPlaceholder(),
            ),
          ),
          // Text section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  style: context.primaryFont(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1612),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitleText != null && subtitleText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitleText,
                    style: context.secondaryFont(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B6B6B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  
  Widget _buildPlantPlaceholder() {
    return Container(
      color: const Color(0xFFF5F1E8),
      child: Center(
        child: Icon(
          Icons.spa_outlined,
          color: const Color(0xFF8B6B47).withValues(alpha: 0.4),
          size: 32,
        ),
      ),
    );
  }
  
  Widget _buildPlantErrorWidget() {
    return Container(
      color: const Color(0xFFF5F1E8),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xFF8B6B47),
          size: 28,
        ),
      ),
    );
  }
  
  Widget _buildStandardPlaceholder() {
    return Container(
      color: const Color(0xFFF5F1E8),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Color(0xFF8B6B47),
          size: 24,
        ),
      ),
    );
  }
  
  Widget _buildStandardErrorWidget() {
    return Container(
      color: const Color(0xFFF5F1E8),
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: Color(0xFF8B6B47),
          size: 24,
        ),
      ),
    );
  }
}