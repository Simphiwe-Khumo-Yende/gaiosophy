import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;

class MagicRitualsScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;
  final Color backgroundColor = const Color(0xFFFCF9F2);
  final Color boxColor = const Color(0xFFF2E9D7);
  final Color textColor = const Color(0xFF3C3C3C);

  const MagicRitualsScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Dynamic content using flutter_html
              if (contentBlock.data.content != null)
                Html(
                  data: contentBlock.data.content!,
                  style: {
                    "body": Style(
                      fontSize: FontSize(14),
                      color: textColor,
                      lineHeight: LineHeight(1.5),
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                    "p": Style(
                      fontSize: FontSize(14),
                      color: textColor,
                      lineHeight: LineHeight(1.5),
                      margin: Margins.only(bottom: 16),
                    ),
                    "h1": Style(
                      fontSize: FontSize(20),
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      margin: Margins.only(bottom: 16, top: 24),
                    ),
                    "h2": Style(
                      fontSize: FontSize(18),
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      margin: Margins.only(bottom: 12, top: 20),
                    ),
                    "h3": Style(
                      fontSize: FontSize(16),
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      margin: Margins.only(bottom: 12, top: 16),
                    ),
                    "ul": Style(
                      margin: Margins.only(left: 16, bottom: 16),
                      padding: HtmlPaddings.zero,
                    ),
                    "ol": Style(
                      margin: Margins.only(left: 16, bottom: 16),
                      padding: HtmlPaddings.zero,
                    ),
                    "li": Style(
                      margin: Margins.only(bottom: 8),
                      padding: HtmlPaddings.zero,
                    ),
                    "strong": Style(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    "b": Style(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    "em": Style(
                      fontStyle: FontStyle.italic,
                      color: textColor,
                    ),
                    "i": Style(
                      fontStyle: FontStyle.italic,
                      color: textColor,
                    ),
                  },
                  extensions: [
                    TagExtension(
                      tagsToExtend: {"li"},
                      builder: (extensionContext) {
                        final element = extensionContext.element;
                        if (element == null) return const SizedBox.shrink();
                        
                        final parent = element.parent;
                        final isOrdered = parent?.localName == 'ol';
                        final index = parent != null ? parent.children.indexOf(element) : 0;

                        IconData icon;
                        if (isOrdered) {
                          // Use numbered icons for ordered lists
                          switch (index) {
                            case 0: icon = Icons.looks_one_outlined; break;
                            case 1: icon = Icons.looks_two_outlined; break;
                            case 2: icon = Icons.looks_3_outlined; break;
                            case 3: icon = Icons.looks_4_outlined; break;
                            case 4: icon = Icons.looks_5_outlined; break;
                            default: icon = Icons.circle_outlined; break;
                          }
                        } else {
                          // Determine icon based on content keywords
                          final text = element.text.toLowerCase();
                          if (text.contains('protection') || text.contains('warding')) {
                            icon = Icons.shield_outlined;
                          } else if (text.contains('healing') || text.contains('medicine')) {
                            icon = Icons.favorite_outline;
                          } else if (text.contains('magic') || text.contains('spell')) {
                            icon = Icons.auto_fix_high_outlined;
                          } else if (text.contains('ritual') || text.contains('ceremony')) {
                            icon = Icons.auto_awesome_outlined;
                          } else if (text.contains('seasonal') || text.contains('season')) {
                            icon = Icons.wb_sunny_outlined;
                          } else if (text.contains('knowledge') || text.contains('wisdom')) {
                            icon = Icons.menu_book_outlined;
                          } else if (text.contains('plant') || text.contains('herb')) {
                            icon = Icons.eco_outlined;
                          } else {
                            icon = Icons.circle_outlined;
                          }
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(icon, size: 16, color: textColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Html(
                                  data: element.innerHtml,
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(14),
                                      color: textColor,
                                      lineHeight: LineHeight(1.5),
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                    "p": Style(
                                      fontSize: FontSize(14),
                                      color: textColor,
                                      lineHeight: LineHeight(1.5),
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}