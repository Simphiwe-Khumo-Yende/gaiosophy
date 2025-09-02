import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../data/models/content.dart' as content_model;

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

    return Html(
      data: contentBlock.data.content!,
      style: {
        "body": Style(
          fontSize: FontSize(14),
          color: const Color(0xFF5A5A5A),
          lineHeight: LineHeight(1.6),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        "p": Style(
          fontSize: FontSize(14),
          color: const Color(0xFF5A5A5A),
          lineHeight: LineHeight(1.6),
          margin: Margins.only(bottom: 12),
        ),
        "h1": Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6B5D54),
          margin: Margins.only(bottom: 16, top: 24),
        ),
        "h2": Style(
          fontSize: FontSize(16),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6B5D54),
          margin: Margins.only(bottom: 12, top: 20),
        ),
        "h3": Style(
          fontSize: FontSize(15),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF5A5A5A),
          margin: Margins.only(bottom: 8, top: 16),
        ),
        "ul": Style(
          margin: Margins.only(bottom: 16),
          padding: HtmlPaddings.zero,
        ),
        "ol": Style(
          margin: Margins.only(bottom: 16),
          padding: HtmlPaddings.zero,
        ),
        "li": Style(
          margin: Margins.only(bottom: 12),
          padding: HtmlPaddings.zero,
        ),
        "strong": Style(
          fontWeight: FontWeight.w500,
          color: const Color(0xFF5A5A5A),
        ),
        "b": Style(
          fontWeight: FontWeight.w500,
          color: const Color(0xFF5A5A5A),
        ),
        "em": Style(
          fontStyle: FontStyle.italic,
          color: const Color(0xFF5A5A5A),
        ),
        "i": Style(
          fontStyle: FontStyle.italic,
          color: const Color(0xFF5A5A5A),
        ),
        "blockquote": Style(
          backgroundColor: const Color(0xFFE8DFD3),
          padding: HtmlPaddings.all(20),
          margin: Margins.symmetric(vertical: 20),
        ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"li"},
          builder: (extensionContext) {
            final element = extensionContext.element;
            if (element == null) return const SizedBox.shrink();
            
            final text = element.text.toLowerCase();
            IconData icon;
            Color iconColor = const Color(0xFFB8956A);

            // Determine icon based on content keywords
            if (text.contains('protection') || text.contains('warding') || text.contains('guard')) {
              icon = Icons.shield_outlined;
            } else if (text.contains('healing') || text.contains('medicine')) {
              icon = Icons.favorite_outline;
            } else if (text.contains('magic') || text.contains('spell')) {
              icon = Icons.auto_fix_high_outlined;
            } else if (text.contains('ritual') || text.contains('ceremony')) {
              icon = Icons.auto_awesome_outlined;
            } else if (text.contains('seasonal') || text.contains('season') || text.contains('summer') || text.contains('lammas')) {
              icon = Icons.wb_sunny_outlined;
            } else if (text.contains('knowledge') || text.contains('wisdom')) {
              icon = Icons.menu_book_outlined;
            } else if (text.contains('plant') || text.contains('herb') || text.contains('bramble') || text.contains('berry')) {
              icon = Icons.eco_outlined;
            } else if (text.contains('altar') || text.contains('decorate')) {
              icon = Icons.auto_awesome_outlined;
            } else if (text.contains('carry') || text.contains('oils') || text.contains('baths')) {
              icon = Icons.spa_outlined;
            } else {
              icon = Icons.circle_outlined;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      element.text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        height: 1.6,
                        color: const Color(0xFF5A5A5A),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        TagExtension(
          tagsToExtend: {"h1"},
          builder: (extensionContext) {
            final element = extensionContext.element;
            if (element == null) return const SizedBox.shrink();

            return Container(
              margin: const EdgeInsets.only(top: 40, bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8956A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      element.text,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B5D54),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        TagExtension(
          tagsToExtend: {"blockquote"},
          builder: (extensionContext) {
            final element = extensionContext.element;
            if (element == null) return const SizedBox.shrink();

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8DFD3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Html(
                data: element.innerHtml,
                style: {
                  "body": Style(
                    fontSize: FontSize(14),
                    color: const Color(0xFF5A5A5A),
                    lineHeight: LineHeight(1.6),
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  "h1": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B5D54),
                    margin: Margins.only(bottom: 16),
                  ),
                  "h2": Style(
                    fontSize: FontSize(15),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF5A5A5A),
                    margin: Margins.only(bottom: 8, top: 16),
                  ),
                  "p": Style(
                    fontSize: FontSize(14),
                    color: const Color(0xFF5A5A5A),
                    lineHeight: LineHeight(1.6),
                    margin: Margins.only(bottom: 12),
                  ),
                  "em": Style(
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF5A5A5A),
                  ),
                  "i": Style(
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF5A5A5A),
                  ),
                },
              ),
            );
          },
        ),
      ],
    );
  }
}