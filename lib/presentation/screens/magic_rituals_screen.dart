import 'package:flutter/material.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/enhanced_html_renderer.dart';

class MagicRitualsScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const MagicRitualsScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1A1612),
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.home_outlined,
              color: Color(0xFF1A1612),
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  contentBlock.data.title ?? 'Magic and Rituals',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF1A1612),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildContentSections(context, theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSections(BuildContext context, ThemeData theme) {
    if (contentBlock.data.content == null || contentBlock.data.content!.isEmpty) {
      return Center(
        child: Text(
          'No content available',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF5A5A5A),
          ),
        ),
      );
    }

    return _buildContentWithIconsAndBoxes(contentBlock.data.content!);
  }

  Widget _buildContentWithIconsAndBoxes(String content) {
    return EnhancedHtmlRenderer(
      content: content,
      iconSize: 18,
      iconColor: const Color(0xFF8B6B47),
    );
  }
}