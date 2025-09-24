import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'content_icon_mapper.dart';
import 'content_box_parser.dart';

/// Enhanced HTML renderer that supports both HTML rendering AND icon mapping/box features
class EnhancedHtmlRenderer extends StatelessWidget {
  final String content;
  final TextStyle? textStyle;
  final double iconSize;
  final Color? iconColor;
  final Map<String, Style>? customStyles;

  const EnhancedHtmlRenderer({
    super.key,
    required this.content,
    this.textStyle,
    this.iconSize = 20,
    this.iconColor,
    this.customStyles,
  });

  @override
  Widget build(BuildContext context) {
    // First, check if content has box sections
    if (ContentBoxParser.hasBoxTags(content)) {
      return _buildContentWithBoxes(context);
    } else {
      // No box sections, render as enhanced HTML with icon support
      return _buildEnhancedHtml(context);
    }
  }

  Widget _buildContentWithBoxes(BuildContext context) {
    // Parse the content to extract sections and boxes
    final sections = ContentBoxParser.parseContent(
      content,
      context: context,
      textStyle: textStyle,
      iconSize: iconSize,
      iconColor: iconColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  Widget _buildEnhancedHtml(BuildContext context) {
    // Process content to replace icon keys with HTML spans that can be styled
    final processedContent = _processIconsInHtml(content);

    return Html(
      data: processedContent,
      style: _getHtmlStyles(context),
      extensions: [
        TagExtension(
          tagsToExtend: {"icon"},
          builder: (extensionContext) {
            final iconKey = extensionContext.element!.text.toLowerCase();
            if (ContentIconMapper.hasIcon(iconKey)) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ContentIconMapper.buildIcon(
                  iconKey,
                  color: iconColor ?? const Color(0xFF8B4513),
                  size: iconSize,
                ),
              );
            }
            return Text('[$iconKey]');
          },
        ),
      ],
    );
  }

  String _processIconsInHtml(String htmlContent) {
    // Replace icon keys [iconKey] with custom HTML tags that can be processed by extensions
    final RegExp iconRegex = RegExp(r'\[([^\]]+)\]');
    return htmlContent.replaceAllMapped(iconRegex, (match) {
      final iconKey = match.group(1)!.toLowerCase();
      if (ContentIconMapper.hasIcon(iconKey)) {
        return '<icon>$iconKey</icon>';
      } else {
        // Keep original text if icon not found
        return match.group(0)!;
      }
    });
  }

  Map<String, Style> _getHtmlStyles(BuildContext context) {
    final defaultStyles = {
      "body": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        color: const Color(0xFF1A1612),
        fontSize: FontSize(16),
        lineHeight: LineHeight(1.1), // Reduced from 1.3 to 1.1
      ),
      "br": Style(
        margin: Margins.only(bottom: 2), // Reduced from 4 to 2
      ),
      "h1": Style(
        color: const Color(0xFF1A1612),
        fontSize: FontSize(24),
        fontWeight: FontWeight.w700,
        margin: Margins.only(top: 12, bottom: 6), // Reduced from 16,8 to 12,6
        textAlign: TextAlign.center,
      ),
      "h2": Style(
        color: const Color(0xFF1A1612),
        fontSize: FontSize(20),
        fontWeight: FontWeight.w600,
        margin: Margins.only(top: 10, bottom: 4), // Reduced from 14,6 to 10,4
      ),
      "h3": Style(
        color: const Color(0xFF1A1612),
        fontSize: FontSize(18),
        fontWeight: FontWeight.w600,
        margin: Margins.only(top: 8, bottom: 3), // Reduced from 12,4 to 8,3
      ),
      "p": Style(
        margin: Margins.only(bottom: 3), // Reduced from 6 to 3
        color: const Color(0xFF1A1612),
      ),
      "div": Style(
        margin: Margins.only(bottom: 2), // Minimal spacing for div elements
      ),
      "ul": Style(
        margin: Margins.only(bottom: 3), // Reduced from 6 to 3
      ),
      "li": Style(
        margin: Margins.only(bottom: 1), // Reduced from 2 to 1
      ),
      "strong": Style(
        fontWeight: FontWeight.bold,
      ),
      "em": Style(
        fontStyle: FontStyle.italic,
      ),
      "u": Style(
        textDecoration: TextDecoration.none, // Hide the underline
        fontFamily: 'Roboto Serif',
        fontWeight: FontWeight.w400,
        fontSize: FontSize(20),
        color: const Color(0xFF5A4E3C),
      ),
      "icon": Style(
        color: iconColor ?? const Color(0xFF8B6B47),
        fontWeight: FontWeight.bold,
        display: Display.inlineBlock,
      ),
    };

    // Merge with custom styles if provided
    if (customStyles != null) {
      defaultStyles.addAll(customStyles!);
    }

    return defaultStyles;
  }
}

/// Enhanced HTML renderer specifically for recipes with recipe-specific styling
class RecipeHtmlRenderer extends EnhancedHtmlRenderer {
  const RecipeHtmlRenderer({
    super.key,
    required super.content,
    super.textStyle,
    super.iconSize = 16,
    super.iconColor,
  });

  @override
  Map<String, Style> _getHtmlStyles(BuildContext context) {
    final baseStyles = super._getHtmlStyles(context);
    
    // Override with recipe-specific styles
    baseStyles.addAll({
      "body": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        color: const Color(0xFF5A5A5A),
        fontSize: FontSize(13),
        lineHeight: LineHeight(1.0), // Minimal line height
      ),
      "p": Style(
        margin: Margins.zero, // No margins for paragraphs
      ),
      "div": Style(
        margin: Margins.zero, // No margins for divs
      ),
      "span": Style(
        margin: Margins.zero, // No margins for spans
      ),
      "h1, h2, h3": Style(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
        margin: Margins.zero, // No margins for headers
      ),
      "ul": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
      ),
      "li": Style(
        margin: Margins.zero, // No margins for list items
        listStyleType: ListStyleType.disc,
      ),
      "br": Style(
        margin: Margins.zero, // No margins for line breaks
      ),
    });

    return baseStyles;
  }
}

/// Enhanced HTML renderer for content detail screens
class ContentDetailHtmlRenderer extends EnhancedHtmlRenderer {
  const ContentDetailHtmlRenderer({
    super.key,
    required super.content,
    super.textStyle,
    super.iconSize = 20,
    super.iconColor,
  });

  @override
  Map<String, Style> _getHtmlStyles(BuildContext context) {
    final baseStyles = super._getHtmlStyles(context);
    
    // Content detail specific styles are already good in the base class
    return baseStyles;
  }
}
