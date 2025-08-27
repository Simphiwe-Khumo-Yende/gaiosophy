import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart';
import '../theme/typography.dart';
import 'firebase_storage_image.dart';
import 'bookmark_button.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({super.key, required this.content});
  final Content content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.push('/content/${content.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFFCF9F2), // Cream background color
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: .4)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A1612).withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xFF1A1612).withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Image
                    SizedBox(
                      height: 80,
                      width: double.infinity,
                      child: content.featuredImageId != null
                          ? FirebaseStorageImage(
                              imageId: content.featuredImageId!,
                              fit: BoxFit.cover,
                              placeholder: Container(color: const Color(0xFFF5F1E8)), // Slightly darker cream for placeholders
                              errorWidget: Container(
                                color: const Color(0xFFF5F1E8), // Slightly darker cream for placeholders
                                child: const Center(
                                  child: Icon(Icons.image_not_supported, color: Color(0xFF8B6B47)),
                                ),
                              ),
                            )
                          : Container(
                              color: const Color(0xFFF5F1E8), // Slightly darker cream for placeholders
                              child: const Center(
                                child: Icon(Icons.image_not_supported, color: Color(0xFF8B6B47)),
                              ),
                            ),
                    ),
                    
                    // Bookmark indicator
                    Positioned(
                      top: 4,
                      right: 4,
                      child: BookmarkIconIndicator(
                        contentId: content.id,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                content.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.secondaryBodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1612),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
