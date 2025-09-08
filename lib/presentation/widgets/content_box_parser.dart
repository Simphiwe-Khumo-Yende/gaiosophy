import 'package:flutter/material.dart';
import '../theme/typography.dart';
import 'enhanced_html_renderer.dart';

/// A utility class for parsing content with [box-start] and [box-end] tags
/// and rendering them with special box decorations.
class ContentBoxParser {
  /// Parses content and returns a list of widgets with box sections styled
  static List<Widget> parseContent(
    String content, {
    BuildContext? context,
    TextStyle? textStyle,
    double iconSize = 20,
    Color? iconColor,
    BoxDecoration? boxDecoration,
  }) {
    final List<Widget> widgets = [];
    
    // Split content by box sections
    final sections = _splitByBoxTags(content);
    
    for (final section in sections) {
      if (section.isBoxed) {
        // Create a boxed section with special styling based on boxStyle
        widgets.add(_buildBoxedSection(
          section.content,
          context: context,
          textStyle: textStyle,
          iconSize: iconSize,
          iconColor: iconColor,
          boxDecoration: boxDecoration,
          boxStyle: section.boxStyle, // Pass the style from the section
        ));
      } else {
        // Regular content section
        if (section.content.trim().isNotEmpty) {
          widgets.add(_buildRegularSection(
            section.content,
            textStyle: textStyle,
            iconSize: iconSize,
            iconColor: iconColor,
          ));
        }
      }
    }
    
    return widgets;
  }
  
  /// Splits content into sections based on [box-start] and [box-end] tags
  static List<ContentSection> _splitByBoxTags(String content) {
    final List<ContentSection> sections = [];
    // Updated regex to capture optional style parameter: [box-start] or [box-start:style]
    final RegExp boxRegex = RegExp(r'\[box-start(?::([^\]]+))?\](.*?)\[box-end\]', dotAll: true);
    
    int lastMatchEnd = 0;
    final matches = boxRegex.allMatches(content);
    
    for (final match in matches) {
      // Add content before the box
      if (match.start > lastMatchEnd) {
        final contentBefore = content.substring(lastMatchEnd, match.start);
        if (contentBefore.trim().isNotEmpty) {
          sections.add(ContentSection(
            content: contentBefore.trim(),
            isBoxed: false,
          ));
        }
      }
      
      // Add the boxed content with style
      final boxStyle = match.group(1); // Extract style parameter (e.g., "warning", "info")
      final boxContent = match.group(2)?.trim() ?? '';
      if (boxContent.isNotEmpty) {
        sections.add(ContentSection(
          content: boxContent,
          isBoxed: true,
          boxStyle: boxStyle, // Pass the style to the section
        ));
      }
      
      lastMatchEnd = match.end;
    }
    
    // Add remaining content after the last box
    if (lastMatchEnd < content.length) {
      final remainingContent = content.substring(lastMatchEnd).trim();
      if (remainingContent.isNotEmpty) {
        sections.add(ContentSection(
          content: remainingContent,
          isBoxed: false,
        ));
      }
    }
    
    // If no boxes were found, return the entire content as a regular section
    if (sections.isEmpty && content.trim().isNotEmpty) {
      sections.add(ContentSection(
        content: content.trim(),
        isBoxed: false,
      ));
    }
    
    return sections;
  }
  
  /// Builds a boxed section with special styling
  static Widget _buildBoxedSection(
    String content, {
    BuildContext? context,
    TextStyle? textStyle,
    double iconSize = 20,
    Color? iconColor,
    BoxDecoration? boxDecoration,
    String? boxStyle, // Style identifier for dynamic decoration
  }) {
    // Use custom boxDecoration if provided, otherwise use style-based decoration
    final decoration = boxDecoration ?? _getBoxDecorationForStyle(boxStyle);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: decoration,
      child: EnhancedHtmlRenderer(
        content: content,
        textStyle: textStyle ?? _getDefaultTextStyle(context),
        iconSize: iconSize,
        iconColor: iconColor,
      ),
    );
  }
  
  /// Builds a regular content section
  static Widget _buildRegularSection(
    String content, {
    TextStyle? textStyle,
    double iconSize = 20,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: EnhancedHtmlRenderer(
        content: content,
        textStyle: textStyle,
        iconSize: iconSize,
        iconColor: iconColor,
      ),
    );
  }
  
  /// Static box decoration using Figma design color #F2E9D7
  static BoxDecoration _staticBoxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFF2E9D7), // Static color from Figma design
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFE5D5C0), // Slightly darker border
        width: 1,
      ),
    );
  }

  /// Gets static box decoration (no longer style-dependent)
  static BoxDecoration _getBoxDecorationForStyle(String? boxStyle) {
    // Always return the same static styling regardless of style parameter
    return _staticBoxDecoration();
  }
  
  /// Gets default text style based on context
  static TextStyle _getDefaultTextStyle(BuildContext? context) {
    if (context != null) {
      return context.secondaryBodyMedium.copyWith(
        height: 1.5,
        color: const Color(0xFF5A5A5A),
      );
    }
    return const TextStyle(
      fontSize: 16,
      height: 1.5,
      color: Color(0xFF5A5A5A),
    );
  }
  
  /// Checks if content contains box tags (with or without style)
  static bool hasBoxTags(String content) {
    return content.contains(RegExp(r'\[box-start(?::[^\]]+)?\]')) && content.contains('[box-end]');
  }
  
  /// Removes box tags from content (useful for plain text extraction)
  static String removeBoxTags(String content) {
    return content
        .replaceAll(RegExp(r'\[box-start(?::[^\]]+)?\]'), '')
        .replaceAll('[box-end]', '')
        .trim();
  }

  /// Strips HTML tags and decodes HTML entities
  static String stripHtml(String htmlString) {
    // Remove HTML tags
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String stripped = htmlString.replaceAll(exp, '');
    
    // Decode HTML entities
    stripped = stripped
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&ldquo;', '"')
        .replaceAll('&rdquo;', '"')
        .replaceAll('&lsquo;', "'")
        .replaceAll('&rsquo;', "'");
    
    // Clean up extra whitespace
    stripped = stripped.trim().replaceAll(RegExp(r'\s+'), ' ');
    
    return stripped;
  }

  /// Parse content for enhanced HTML rendering with box support
  static List<Widget> parseContentForHtml(
    String content, {
    BuildContext? context,
    TextStyle? textStyle,
    double iconSize = 20,
    Color? iconColor,
  }) {
    final List<Widget> widgets = [];
    
    // Split content by box sections
    final sections = _splitByBoxTags(content);
    
    for (final section in sections) {
      if (section.isBoxed) {
        // Create a boxed section with enhanced HTML renderer
        widgets.add(_buildBoxedSectionWithHtml(
          section.content,
          context: context,
          textStyle: textStyle,
          iconSize: iconSize,
          iconColor: iconColor,
          boxStyle: section.boxStyle,
        ));
      } else {
        // Regular content section with HTML support
        if (section.content.trim().isNotEmpty) {
          widgets.add(_buildRegularSectionWithHtml(
            section.content,
            textStyle: textStyle,
            iconSize: iconSize,
            iconColor: iconColor,
          ));
        }
      }
    }
    
    return widgets;
  }
  
  /// Builds a boxed section with enhanced HTML renderer
  static Widget _buildBoxedSectionWithHtml(
    String content, {
    BuildContext? context,
    TextStyle? textStyle,
    double iconSize = 20,
    Color? iconColor,
    String? boxStyle,
  }) {
    final decoration = _getBoxDecorationForStyle(boxStyle);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: decoration,
      child: EnhancedHtmlRenderer(
        content: content,
        textStyle: textStyle ?? _getDefaultTextStyle(context),
        iconSize: iconSize,
        iconColor: iconColor,
      ),
    );
  }
  
  /// Builds a regular content section with HTML support
  static Widget _buildRegularSectionWithHtml(
    String content, {
    TextStyle? textStyle,
    double iconSize = 20,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: EnhancedHtmlRenderer(
        content: content,
        textStyle: textStyle,
        iconSize: iconSize,
        iconColor: iconColor,
      ),
    );
  }

  /// Check if content has HTML tags
  static bool hasHtmlTags(String content) {
    final htmlRegex = RegExp(r'<[^>]+>');
    return htmlRegex.hasMatch(content);
  }
}

/// Represents a section of content that can be either boxed or regular
class ContentSection {
  final String content;
  final bool isBoxed;
  final String? boxStyle; // Style identifier for the box (e.g., "warning", "info", "recipe")
  
  const ContentSection({
    required this.content,
    required this.isBoxed,
    this.boxStyle,
  });
  
  @override
  String toString() {
    return 'ContentSection(content: "${content.length > 50 ? '${content.substring(0, 50)}...' : content}", isBoxed: $isBoxed, boxStyle: $boxStyle)';
  }
}

/// Widget that automatically handles content with box sections
class BoxedContentText extends StatelessWidget {
  final String content;
  final TextStyle? textStyle;
  final double iconSize;
  final Color? iconColor;
  final BoxDecoration? boxDecoration;
  
  const BoxedContentText(
    this.content, {
    super.key,
    this.textStyle,
    this.iconSize = 20,
    this.iconColor,
    this.boxDecoration,
  });
  
  @override
  Widget build(BuildContext context) {
    // Always use the enhanced HTML parsing for consistency
    final widgets = ContentBoxParser.parseContent(
      content,
      context: context,
      textStyle: textStyle,
      iconSize: iconSize,
      iconColor: iconColor,
      boxDecoration: boxDecoration,
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
