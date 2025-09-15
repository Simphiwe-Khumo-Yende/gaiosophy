import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/enhanced_html_renderer.dart';

class MagicRitualsScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;
  final Color backgroundColor = const Color(0xFFFCF9F2);
  final Color boxColor = const Color(0xFFE9E2D5);
  final Color textColor = const Color(0xFF5A4E3C);

  const MagicRitualsScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    // Debug logging
    
    
    
    
    
    
    

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home_outlined, color: textColor),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  contentBlock.data.title ?? 'Magic and Rituals',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Subtitle if available
              if (contentBlock.data.subtitle != null) ...[
                Text(
                  contentBlock.data.subtitle!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              // Main Content from Firestore
              if (contentBlock.data.content != null && contentBlock.data.content!.isNotEmpty) ...[
                _buildContentWithIconsAndBoxes(contentBlock.data.content!),
                const SizedBox(height: 30),
              ] else ...[
                Center(
                  child: Text(
                    'No content available',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentWithIconsAndBoxes(String content) {    
    return EnhancedHtmlRenderer(
      content: content,
      iconSize: 20,
      iconColor: textColor,
    );
  }
}