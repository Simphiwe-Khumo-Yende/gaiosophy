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
    // Check if content has box sections first (as they are more complex)
    if (ContentBoxParser.hasBoxTags(content)) {
      return _buildContentWithBoxes(context);
    }
    // Then check for indentation tags
    else if (_hasIndentationTags(content)) {
      return _buildContentWithIndentation(context);
    } else {
      // No box sections or indentation, render as enhanced HTML with icon support
      return _buildEnhancedHtml(context);
    }
  }

  /// Check if content contains indentation tags
  bool _hasIndentationTags(String content) {
    return content.contains('[indent-start]') || content.contains('[indent-end]');
  }

  /// Build content with indentation support
  Widget _buildContentWithIndentation(BuildContext context) {
    final sections = _parseContentWithIndentation(content, context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  /// Parse content into sections with indentation awareness
  List<Widget> _parseContentWithIndentation(String content, BuildContext context) {
    final List<Widget> widgets = [];
    
    // More flexible approach: find indentation tags within HTML content
    final segments = _splitContentByIndentationTags(content);
    bool isIndented = false;
    
    for (final segment in segments) {
      if (segment.type == 'indent-start') {
        isIndented = true;
        continue;
      } else if (segment.type == 'indent-end') {
        isIndented = false;
        continue;
      } else if (segment.content.trim().isNotEmpty) {
        final sectionWidget = _buildTextSectionWithIcons(segment.content.trim(), isIndented, context);
        widgets.add(sectionWidget);
      }
    }
    
    return widgets;
  }

  /// Split content by indentation tags, handling HTML-wrapped tags
  List<ContentSegment> _splitContentByIndentationTags(String content) {
    final List<ContentSegment> segments = [];
    
    // Find all indentation tags, whether wrapped in HTML or not
    final indentPattern = RegExp(r'(?:<[^>]*>)?\s*\[(indent-start|indent-end)\]\s*(?:<[^>]*>)?');
    
    // Create a list of all indentation positions
    final List<IndentationMarker> markers = [];
    
    // Find all indentation markers
    for (final match in indentPattern.allMatches(content)) {
      final type = match.group(1)!; // 'indent-start' or 'indent-end'
      markers.add(IndentationMarker(match.start, match.end, type));
    }
    
    // Sort markers by position
    markers.sort((a, b) => a.start.compareTo(b.start));
    
    // Split content based on markers
    int lastEnd = 0;
    for (final marker in markers) {
      // Add content before this marker
      if (marker.start > lastEnd) {
        final contentBefore = content.substring(lastEnd, marker.start);
        if (contentBefore.trim().isNotEmpty) {
          segments.add(ContentSegment(contentBefore, 'content'));
        }
      }
      
      // Add the marker itself
      segments.add(ContentSegment('', marker.type));
      lastEnd = marker.end;
    }
    
    // Add remaining content
    if (lastEnd < content.length) {
      final remaining = content.substring(lastEnd);
      if (remaining.trim().isNotEmpty) {
        segments.add(ContentSegment(remaining, 'content'));
      }
    }
    
    return segments;
  }

  /// Build a text section with icon support and optional indentation
  Widget _buildTextSectionWithIcons(String text, bool isIndented, BuildContext context) {
    // Calculate indentation based on a more visible amount
    final double indentWidth = isIndented ? 24.0 : 0;
    
    return Container(
      margin: EdgeInsets.only(left: indentWidth, bottom: 8),
      child: _buildHtmlWithIcons(text, context),
    );
  }

  /// Build HTML content with inline icons (for indented sections)
  Widget _buildHtmlWithIcons(String htmlContent, BuildContext context) {
    // Clean HTML content and process icons
    String processedContent = _processIconsInContent(htmlContent);
    
    // Use Html widget to handle HTML tags properly
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
        TagExtension(
          tagsToExtend: {"title-text"},
          builder: (extensionContext) {
            return Text(
              extensionContext.element!.text,
              style: const TextStyle(
                fontFamily: 'Roboto Serif',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF5A4E3C),
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
        TagExtension(
          tagsToExtend: {"subtitle-text"},
          builder: (extensionContext) {
            return Text(
              extensionContext.element!.text,
              style: const TextStyle(
                fontFamily: 'Roboto Serif',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF5A4E3C),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Process icon placeholders in HTML content
  String _processIconsInContent(String content) {
    String processedContent = content;
    
    // Process custom title-text tags first
    processedContent = _processTitleTextTags(processedContent);
    
    // Process custom subtitle-text tags
    processedContent = _processSubtitleTextTags(processedContent);
    
    // Replace 🍃 emojis with icon tags
    processedContent = processedContent.replaceAllMapped(
      RegExp(r'🍃\s*([^🍃\n<]*?)(?=\s|$|<|🍃)'),
      (match) {
        String iconText = match.group(1)?.trim() ?? 'leaf';
        return '<icon>$iconText</icon> ';
      },
    );
    
    // Replace other icon patterns like [icon:key] with <icon>key</icon>
    processedContent = processedContent.replaceAllMapped(
      RegExp(r'\[icon:([^\]]+)\]'),
      (match) => '<icon>${match.group(1)}</icon>',
    );
    
    // Replace icon keys [iconKey] with custom HTML tags, but exclude title-text and subtitle-text tags
    processedContent = processedContent.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]'),
      (match) {
        final fullMatch = match.group(0)!;
        final iconKey = match.group(1)!.toLowerCase();
        
        // Skip title-text and subtitle-text tags - they should be processed by their respective methods
        if (iconKey == 'title-text-start' || iconKey == 'title-text-end' ||
            iconKey == 'subtitle-text-start' || iconKey == 'subtitle-text-end') {
          return fullMatch; // Return unchanged
        }
        
        if (ContentIconMapper.hasIcon(iconKey)) {
          return '<icon>$iconKey</icon>';
        } else {
          return fullMatch;
        }
      },
    );
    
    return processedContent;
  }

  /// Process custom title-text tags [title-text-start]content[title-text-end]
  String _processTitleTextTags(String content) {
    return content.replaceAllMapped(
      RegExp(r'\[title-text-start\](.*?)\[title-text-end\]', dotAll: true),
      (match) {
        final titleContent = match.group(1) ?? '';
        
        // Extract plain text from HTML content by removing HTML tags
        String plainText = titleContent.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        
        return '<title-text>$plainText</title-text>';
      },
    );
  }

  /// Process custom subtitle-text tags [subtitle-text-start]content[subtitle-text-end]
  String _processSubtitleTextTags(String content) {
    return content.replaceAllMapped(
      RegExp(r'\[subtitle-text-start\](.*?)\[subtitle-text-end\]', dotAll: true),
      (match) {
        final subtitleContent = match.group(1) ?? '';
        
        // Extract plain text from HTML content by removing HTML tags
        String plainText = subtitleContent.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        
        return '<subtitle-text>$plainText</subtitle-text>';
      },
    );
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
    final processedContent = _processIconsInContent(content);

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
        TagExtension(
          tagsToExtend: {"title-text"},
          builder: (extensionContext) {
            return Text(
              extensionContext.element!.text,
              style: const TextStyle(
                fontFamily: 'Roboto Serif',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF5A4E3C),
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
        TagExtension(
          tagsToExtend: {"subtitle-text"},
          builder: (extensionContext) {
            return Text(
              extensionContext.element!.text,
              style: const TextStyle(
                fontFamily: 'Roboto Serif',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFF5A4E3C),
              ),
            );
          },
        ),
      ],
    );
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
        fontSize: FontSize(16),
        color: const Color(0xFF5A4E3C),
      ),
      "title-text": Style(
        fontFamily: 'Roboto Serif',
        fontWeight: FontWeight.bold,
        fontSize: FontSize(18),
        color: const Color(0xFF5A4E3C),
        textDecoration: TextDecoration.none,
        margin: Margins.only(bottom: 4),
      ),
      "subtitle-text": Style(
        fontFamily: 'Roboto Serif',
        fontWeight: FontWeight.w400,
        fontSize: FontSize(16),
        color: const Color(0xFF5A4E3C),
        textDecoration: TextDecoration.none,
        margin: Margins.only(bottom: 4),
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

/// Helper class for content segments
class ContentSegment {
  final String content;
  final String type; // 'content', 'indent-start', 'indent-end'
  
  ContentSegment(this.content, this.type);
}

/// Helper class for indentation markers
class IndentationMarker {
  final int start;
  final int end;
  final String type;
  
  IndentationMarker(this.start, this.end, this.type);
}
