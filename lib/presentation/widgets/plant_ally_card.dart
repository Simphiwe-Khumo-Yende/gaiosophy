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
        width: 200,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image covering the entire card
              content.featuredImageId != null
                  ? FirebaseStorageImage(
                      imageId: content.featuredImageId!,
                      fit: BoxFit.cover,
                      placeholder: _buildPlaceholder(),
                      errorWidget: _buildErrorWidget(),
                    )
                  : _buildPlaceholder(),
              
              // Dark overlay for better text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ],
          ),
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