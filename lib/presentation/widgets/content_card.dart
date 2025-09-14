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
  return GestureDetector(
    onTap: () => context.push('/content/${content.id}'),
    child: Container(
      width: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 1.3, // Landscape ratio
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
          // Title below image
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              content.title,
              style: context.primaryFont(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1612),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPlantAllyCard(BuildContext context) {
  return GestureDetector(
    onTap: () => context.push('/content/${content.id}'),
    child: Container(
      width: 180, // Much wider!
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full portrait artwork
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 0.7, // Tall portrait like tarot cards
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
          // Title and subtitle
          Container(
            padding: const EdgeInsets.all(12),
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
                if (content.summary != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    content.summary!,
                    style: TextStyle(
                      color: const Color(0xFF1A1612).withOpacity(0.7),
                      fontSize: 13,
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