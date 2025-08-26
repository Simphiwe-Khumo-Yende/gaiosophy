import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';

class BrambleOverviewScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const BrambleOverviewScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with Hero Image
            SliverAppBar(
              expandedHeight: 250,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFFFCF9F2),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF5A4E3C),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  contentBlock.data.title ?? 'Overview',
                  style: const TextStyle(
                    color: Color(0xFF5A4E3C),
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF8B6B47).withOpacity(0.3),
                        const Color(0xFFFCF9F2),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.nature_people,
                      size: 80,
                      color: Color(0xFF5A4E3C),
                    ),
                  ),
                ),
              ),
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Introduction Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5A4E3C).withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B6B47).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.auto_stories,
                                  color: Color(0xFF5A4E3C),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Plant Introduction',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: const Color(0xFF5A4E3C),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (contentBlock.data.content != null)
                            Html(
                              data: contentBlock.data.content,
                              style: {
                                "body": Style(
                                  color: const Color(0xFF5A4E3C),
                                  fontSize: FontSize(16),
                                  lineHeight: const LineHeight(1.8),
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                ),
                                "p": Style(
                                  color: const Color(0xFF5A4E3C),
                                  fontSize: FontSize(16),
                                  lineHeight: const LineHeight(1.8),
                                  margin: Margins.only(bottom: 16),
                                ),
                              },
                            )
                          else
                            Text(
                              'Welcome to the world of brambles - thorny yet bountiful plants that have provided sustenance and medicine for countless generations.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: const Color(0xFF5A4E3C),
                                height: 1.8,
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Key Features Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B6B47).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF8B6B47).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Key Characteristics',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF5A4E3C),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureItem(
                            icon: Icons.eco,
                            title: 'Thorny Canes',
                            description: 'Distinctive arching stems with protective thorns',
                          ),
                          _buildFeatureItem(
                            icon: Icons.local_florist,
                            title: 'Seasonal Blooms',
                            description: 'Beautiful white or pink flowers in spring',
                          ),
                          _buildFeatureItem(
                            icon: Icons.restaurant,
                            title: 'Edible Berries',
                            description: 'Nutritious blackberries rich in vitamins',
                          ),
                          _buildFeatureItem(
                            icon: Icons.healing,
                            title: 'Medicinal Properties',
                            description: 'Traditional remedy for various ailments',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF5A4E3C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF5A4E3C),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF5A4E3C),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: const Color(0xFF5A4E3C).withOpacity(0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
