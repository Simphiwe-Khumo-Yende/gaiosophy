import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart';
import '../theme/typography.dart';
import 'firebase_storage_image.dart';

class PlantAllyCard extends StatelessWidget {
  const PlantAllyCard({super.key, required this.content});
  
  final Content content;

  @override
  Widget build(BuildContext context) {
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
        width: 180,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
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
          children: [
            // Portrait image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 210,
                width: double.infinity,
                child: content.featuredImageId != null
                    ? FirebaseStorageImage(
                        imageId: content.featuredImageId!,
                        fit: BoxFit.cover,
                        placeholder: _buildPlaceholder(),
                        errorWidget: _buildErrorWidget(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
            // Text section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5F1E8),
      child: Center(
        child: Icon(
          Icons.spa_outlined,
          color: const Color(0xFF8B6B47).withOpacity(0.4),
          size: 32,
        ),
      ),
    );
  }
  
  Widget _buildErrorWidget() {
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
}