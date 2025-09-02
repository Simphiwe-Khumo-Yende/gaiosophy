import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import '../../data/models/content.dart' as content_model;

class PlantFolkloreScreen extends StatefulWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const PlantFolkloreScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  State<PlantFolkloreScreen> createState() => _PlantFolkloreScreenState();
}

class _PlantFolkloreScreenState extends State<PlantFolkloreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parentTitle),
        backgroundColor: const Color(0xFF8B6B47),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeaturedImage(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContentPreview(),
                  const SizedBox(height: 24),
                  _buildActionButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedImage() {
    final title = widget.parentTitle.toLowerCase();
    String imagePath;

    if (title.contains('magic') || title.contains('ritual')) {
      imagePath = 'assets/images/magic_rituals.png';
    } else if (title.contains('folk') || title.contains('medicine')) {
      imagePath = 'assets/images/folk_medicine.png';
    } else if (title.contains('harvesting') || title.contains('harvest')) {
      imagePath = 'assets/images/plant_harvesting.png';
    } else {
      imagePath = 'assets/images/autumn.png'; // Default image
    }

    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: Center(
          child: Text(
            widget.contentBlock.data.title ?? 'Folklore & Legends',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildContentPreview() {
    String? fullText = widget.contentBlock.data.content;
    String previewText = '';

    if (fullText != null && fullText.isNotEmpty) {
      // Extract plain text from HTML for preview
      final document = html_parser.parse(fullText);
      final plainText = document.body?.text ?? '';
      
      // Take first 200 characters for preview
      previewText = plainText.length > 200 
          ? '${plainText.substring(0, 200)}...'
          : plainText;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1612),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          previewText.isNotEmpty ? previewText : 'No content available',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF4A4A4A),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _navigateToDetailedReading,
        icon: const Icon(Icons.book, color: Colors.white),
        label: const Text(
          'Read More',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B6B47),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  void _navigateToDetailedReading() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B6B47),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.contentBlock.data.title ?? 'Folklore & Legends',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.contentBlock.data.content != null) ...[
                          Html(
                            data: widget.contentBlock.data.content!,
                            style: {
                              "body": Style(
                                color: const Color(0xFF1A1612),
                                fontSize: FontSize(16),
                                lineHeight: LineHeight(1.6),
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                              ),
                              "h1": Style(
                                color: const Color(0xFF8B6B47),
                                fontSize: FontSize(24),
                                fontWeight: FontWeight.bold,
                                margin: Margins.only(bottom: 16),
                              ),
                              "h2": Style(
                                color: const Color(0xFF8B6B47),
                                fontSize: FontSize(20),
                                fontWeight: FontWeight.bold,
                                margin: Margins.only(bottom: 12),
                              ),
                              "h3": Style(
                                color: const Color(0xFF8B6B47),
                                fontSize: FontSize(18),
                                fontWeight: FontWeight.w600,
                                margin: Margins.only(bottom: 10),
                              ),
                              "ul": Style(
                                color: const Color(0xFF1A1612),
                                margin: Margins.only(left: 16, bottom: 12),
                                padding: HtmlPaddings.zero,
                              ),
                              "ol": Style(
                                color: const Color(0xFF1A1612),
                                margin: Margins.only(left: 16, bottom: 12),
                                padding: HtmlPaddings.zero,
                              ),
                              "li": Style(
                                color: const Color(0xFF1A1612),
                                margin: Margins.only(bottom: 8),
                                padding: HtmlPaddings.zero,
                              ),
                              "p": Style(
                                color: const Color(0xFF1A1612),
                                margin: Margins.only(bottom: 12),
                              ),
                            },
                            extensions: [
                              TagExtension(
                                tagsToExtend: {"li"},
                                builder: (extensionContext) {
                                  final element = extensionContext.element;
                                  final text = element?.text ?? '';
                                  
                                  IconData icon = Icons.circle;
                                  if (text.toLowerCase().contains('magic') || 
                                      text.toLowerCase().contains('ritual') ||
                                      text.toLowerCase().contains('spell')) {
                                    icon = Icons.auto_fix_high;
                                  } else if (text.toLowerCase().contains('herb') || 
                                             text.toLowerCase().contains('plant') ||
                                             text.toLowerCase().contains('flower')) {
                                    icon = Icons.grass;
                                  } else if (text.toLowerCase().contains('moon') || 
                                             text.toLowerCase().contains('night') ||
                                             text.toLowerCase().contains('dark')) {
                                    icon = Icons.nightlight;
                                  } else if (text.toLowerCase().contains('sun') || 
                                             text.toLowerCase().contains('day') ||
                                             text.toLowerCase().contains('light')) {
                                    icon = Icons.wb_sunny;
                                  } else if (text.toLowerCase().contains('water') || 
                                             text.toLowerCase().contains('river') ||
                                             text.toLowerCase().contains('sea')) {
                                    icon = Icons.water;
                                  } else if (text.toLowerCase().contains('fire') || 
                                             text.toLowerCase().contains('flame')) {
                                    icon = Icons.local_fire_department;
                                  } else if (text.toLowerCase().contains('earth') || 
                                             text.toLowerCase().contains('ground') ||
                                             text.toLowerCase().contains('soil')) {
                                    icon = Icons.terrain;
                                  } else if (text.toLowerCase().contains('air') || 
                                             text.toLowerCase().contains('wind') ||
                                             text.toLowerCase().contains('sky')) {
                                    icon = Icons.air;
                                  }

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          icon,
                                          size: 16,
                                          color: const Color(0xFF8B6B47),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            text,
                                            style: const TextStyle(
                                              color: Color(0xFF1A1612),
                                              fontSize: 14,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ] else ...[
                          const Text(
                            'No content available',
                            style: TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Color(0xFF8B6B47)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
