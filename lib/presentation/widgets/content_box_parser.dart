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
        // Create a boxed section with special styling based on boxStyle and boxVariant
        widgets.add(_buildBoxedSection(
          section.content,
          context: context,
          textStyle: textStyle,
          iconSize: iconSize,
          iconColor: iconColor,
          boxDecoration: boxDecoration,
          boxStyle: section.boxStyle, // Pass the style from the section
          boxVariant: section.boxVariant, // Pass the variant from the section
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
    // Updated regex to capture box variants: [box-start], [box-start-1], [box-start-2] with optional style parameter
    final RegExp boxRegex = RegExp(r'\[box-start(-[12])?(?::([^\]]+))?\](.*?)\[box-end(-[12])?\]', dotAll: true);
    
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
      
      // Add the boxed content with style and variant
      final boxVariant = match.group(1); // Extract variant (-1 or -2)
      final boxStyle = match.group(2); // Extract style parameter (e.g., "warning", "info")
      final boxContent = match.group(3)?.trim() ?? '';
      if (boxContent.isNotEmpty) {
        sections.add(ContentSection(
          content: boxContent,
          isBoxed: true,
          boxStyle: boxStyle, // Pass the style to the section
          boxVariant: boxVariant, // Pass the variant to the section
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
    String? boxVariant, // Variant identifier for dynamic decoration
  }) {
    // Use custom boxDecoration if provided, otherwise use style-based decoration
    final decoration = boxDecoration ?? _getBoxDecorationForStyle(boxStyle, boxVariant);
    
    // Process content for better spacing
    final processedContent = processContentSpacing(content);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12), // Reduced from 16 to 12
      margin: const EdgeInsets.symmetric(vertical: 4), // Reduced from 6 to 4
      decoration: decoration,
      child: EnhancedHtmlRenderer(
        content: processedContent,
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
    // Process content for better spacing
    final processedContent = processContentSpacing(content);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1), // Reduced from 2 to 1
      child: EnhancedHtmlRenderer(
        content: processedContent,
        textStyle: textStyle,
        iconSize: iconSize,
        iconColor: iconColor,
      ),
    );
  }
  
  /// Gets dynamic box decoration based on variant and style
  static BoxDecoration _getBoxDecorationForStyle(String? boxStyle, String? boxVariant) {
    // Map variants to colors
    final Color backgroundColor = _getBackgroundColorForVariant(boxVariant);
    final Color borderColor = _getBorderColorForVariant(boxVariant);
    
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: borderColor,
        width: 1,
      ),
    );
  }
  
  /// Maps box variant to background color
  static Color _getBackgroundColorForVariant(String? boxVariant) {
    switch (boxVariant) {
      case '-1':
        return const Color(0xFFF1ECE1); // Light beige for box-start-1
      case '-2':
        return const Color(0xFFF2E9D7); // Original beige for box-start-2
      default:
        return const Color(0xFFF2E9D7); // Original beige for box-start (no variant)
    }
  }
  
  /// Maps box variant to border color
  static Color _getBorderColorForVariant(String? boxVariant) {
    switch (boxVariant) {
      case '-1':
        return const Color(0xFFE4D7C4); // Slightly darker border for box-start-1
      case '-2':
        return const Color(0xFFE5D5C0); // Original border for box-start-2
      default:
        return const Color(0xFFE5D5C0); // Original border for box-start (no variant)
    }
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
  
  /// Checks if content contains box tags (with or without style, including variants)
  static bool hasBoxTags(String content) {
    bool hasStart = content.contains(RegExp(r'\[box-start(-[12])?(?::[^\]]+)?\]'));
    bool hasEnd = content.contains(RegExp(r'\[box-end(-[12])?\]'));
    print('ContentBoxParser.hasBoxTags: start=$hasStart, end=$hasEnd');
    return hasStart && hasEnd;
  }
  
  /// Removes box tags from content (useful for plain text extraction, including variants)
  static String removeBoxTags(String content) {
    return content
        .replaceAll(RegExp(r'\[box-start(-[12])?(?::[^\]]+)?\]'), '')
        .replaceAll(RegExp(r'\[box-end(-[12])?\]'), '')
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

  /// Processes content to improve sentence spacing and empty line handling
  static String processContentSpacing(String content) {
    // Convert double newlines to minimal paragraph breaks - much tighter spacing
    content = content.replaceAll(RegExp(r'\n\s*\n'), '<br>');
    
    // Convert single newlines to minimal breaks
    content = content.replaceAll(RegExp(r'\n'), '<br>');
    
    // Add proper spacing after sentence endings followed by capital letters
    content = content.replaceAllMapped(RegExp(r'([.!?])\s*([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    });
    
    // Ensure proper spacing around periods, exclamation marks, and question marks
    content = content.replaceAllMapped(RegExp(r'([.!?])([A-Za-z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    });
    
    // Handle multiple spaces and normalize
    content = content.replaceAll(RegExp(r' {2,}'), ' ');
    
    // Remove excessive line breaks
    content = content.replaceAll(RegExp(r'<br>\s*<br>\s*<br>'), '<br><br>');
    
    return content;
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
          boxVariant: section.boxVariant,
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
    String? boxVariant, // Add boxVariant parameter
  }) {
    final decoration = _getBoxDecorationForStyle(boxStyle, boxVariant);
    
    // Process content for better spacing
    final processedContent = processContentSpacing(content);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12), // Reduced from 16 to 12
      margin: const EdgeInsets.symmetric(vertical: 4), // Reduced from 6 to 4
      decoration: decoration,
      child: EnhancedHtmlRenderer(
        content: processedContent,
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
    // Process content for better spacing
    final processedContent = processContentSpacing(content);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1), // Reduced from 2 to 1
      child: EnhancedHtmlRenderer(
        content: processedContent,
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
  final String? boxVariant; // Variant identifier for the box (e.g., "-1", "-2", null for original)
  
  const ContentSection({
    required this.content,
    required this.isBoxed,
    this.boxStyle,
    this.boxVariant,
  });
  
  @override
  String toString() {
    return 'ContentSection(content: "${content.length > 50 ? '${content.substring(0, 50)}...' : content}", isBoxed: $isBoxed, boxStyle: $boxStyle, boxVariant: $boxVariant)';
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
