import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;

class ContentBlockDetailScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const ContentBlockDetailScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content Block Title
              if (contentBlock.data.title != null) ...[
                Text(
                  contentBlock.data.title!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF5A4E3C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              
              // Content Block Subtitle
              if (contentBlock.data.subtitle != null) ...[
                Text(
                  contentBlock.data.subtitle!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF5A4E3C).withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Content Block Content
              if (contentBlock.data.content != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5A4E3C).withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Html(
                    data: contentBlock.data.content,
                    style: {
                      "body": Style(
                        color: const Color(0xFF5A4E3C),
                        fontSize: FontSize(16),
                        lineHeight: const LineHeight(1.6),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "p": Style(
                        color: const Color(0xFF5A4E3C),
                        fontSize: FontSize(16),
                        lineHeight: const LineHeight(1.6),
                        margin: Margins.only(bottom: 12),
                      ),
                      "h1, h2, h3, h4, h5, h6": Style(
                        color: const Color(0xFF5A4E3C),
                        fontWeight: FontWeight.bold,
                        margin: Margins.only(top: 16, bottom: 8),
                      ),
                      "ul, ol": Style(
                        margin: Margins.only(bottom: 12),
                        padding: HtmlPaddings.only(left: 20),
                      ),
                      "li": Style(
                        color: const Color(0xFF5A4E3C),
                        margin: Margins.only(bottom: 4),
                      ),
                    },
                  ),
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5A4E3C).withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 48,
                        color: const Color(0xFF5A4E3C).withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No detailed content available for this section.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF5A4E3C).withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
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
