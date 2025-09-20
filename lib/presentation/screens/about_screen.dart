import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'About',
          style: context.primaryTitleLarge.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main About Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF8B6B47),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'About Gaiosophy',
                          style: context.primaryTitleLarge.copyWith(
                            color: const Color(0xFF1A1612),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Main description
                  Text(
                    'Gaiosophy is a seasonal guide to help you walk in rhythm with nature. Rooted in the Celtic Wheel of the Year and the seasons of the Northern Hemisphere, the app unfolds with the turning of time, offering fresh content for each seasonal shift.',
                    style: context.secondaryBodyLarge.copyWith(
                      color: const Color(0xFF1A1612),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // What you'll discover section
                  Text(
                    'Inside you\'ll discover:',
                    style: context.primaryTitleMedium.copyWith(
                      color: const Color(0xFF8B6B47),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildFeatureItem(
                    context,
                    icon: Icons.auto_stories,
                    text: 'Folklore and wisdom teachings of the British Isles',
                  ),
                  
                  _buildFeatureItem(
                    context,
                    icon: Icons.nature_people,
                    text: 'Sustainable, earth-based ceremonies and rituals',
                  ),
                  
                  _buildFeatureItem(
                    context,
                    icon: Icons.handyman,
                    text: 'Seasonal sacred crafts to make with your hands and natural treasure',
                  ),
                  
                  _buildFeatureItem(
                    context,
                    icon: Icons.restaurant,
                    text: 'Foraged recipes for food, remedies, and natural skincare',
                  ),
                  
                  _buildFeatureItem(
                    context,
                    icon: Icons.psychology,
                    text: 'Guidance for co-creating with the land and re-enchanting your everyday life',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Closing message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B6B47).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Gaiosophy is an invitation to slow down, to be guided by the plants and cycles around you, and to find magic woven into the ordinary. It is a compass to help you remember your own true nature, and to be enchanted by the Earth.',
                      style: context.secondaryBodyMedium.copyWith(
                        color: const Color(0xFF1A1612),
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem(BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF8B6B47),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: context.secondaryBodyMedium.copyWith(
                color: const Color(0xFF1A1612),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}