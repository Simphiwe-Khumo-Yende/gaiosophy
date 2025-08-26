import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;

class PlantOverviewScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const PlantOverviewScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  String _getPlantName() {
    // Extract plant name from parent title or content block title
    final title = parentTitle.toLowerCase();
    if (title.contains('bramble')) return 'brambles';
    if (title.contains('lavender')) return 'lavender';
    if (title.contains('sage')) return 'sage';
    if (title.contains('rosemary')) return 'rosemary';
    if (title.contains('mint')) return 'mint';
    // Add more plant names as needed
    return 'these wonderful plants';
  }

  String _getPlantDescription() {
    final plantName = _getPlantName();
    if (plantName == 'brambles') return 'thorny yet bountiful plants that have provided sustenance and medicine for countless generations';
    if (plantName == 'lavender') return 'fragrant purple flowers beloved for their calming properties and sweet scent';
    if (plantName == 'sage') return 'aromatic herbs with powerful cleansing and wisdom-enhancing properties';
    if (plantName == 'rosemary') return 'evergreen herbs symbolizing remembrance and mental clarity';
    if (plantName == 'mint') return 'refreshing herbs that invigorate the senses and aid digestion';
    return 'remarkable plants with their own unique gifts and properties';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Header
              Container(
                height: 180,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF6B8E5A),
                      const Color(0xFF5A7A49),
                      const Color(0xFF4A6B38),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.eco,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contentBlock.data.title ?? 'Plant Overview',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Discover the essence of ${_getPlantName()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Main Content Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5A4E3C).withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B8E5A).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: Color(0xFF5A4E3C),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'About This Plant',
                          style: TextStyle(
                            color: Color(0xFF5A4E3C),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Container(
                      width: double.infinity,
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF6B8E5A).withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    if (contentBlock.data.content != null) ...[
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
                            margin: Margins.only(bottom: 15),
                          ),
                          "h1, h2, h3, h4, h5, h6": Style(
                            color: const Color(0xFF5A4E3C),
                            fontWeight: FontWeight.bold,
                            margin: Margins.only(top: 20, bottom: 10),
                          ),
                        },
                      ),
                    ] else ...[
                      Text(
                        'Meet ${_getPlantName()} - ${_getPlantDescription()}. These resilient plants have been companions to humans throughout history, offering their gifts freely to those who understand their nature.',
                        style: const TextStyle(
                          color: Color(0xFF5A4E3C),
                          fontSize: 16,
                          height: 1.8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      
                      Text(
                        'From ancient times to modern day, ${_getPlantName()} have maintained their reputation as both practical allies and spiritual teachers, showing us the perfect balance between protection and generosity.',
                        style: const TextStyle(
                          color: Color(0xFF5A4E3C),
                          fontSize: 16,
                          height: 1.8,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
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
}
