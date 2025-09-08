import 'package:flutter/material.dart';
import '../theme/typography.dart';
import 'content_icon_mapper.dart';
import 'content_box_parser.dart';

class RichContentText extends StatelessWidget {
  final String content;
  final TextStyle? textStyle;
  final double iconSize;
  final Color? iconColor;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const RichContentText(
    this.content, {
    super.key,
    this.textStyle,
    this.iconSize = 20,
    this.iconColor,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return _buildRichText(context);
  }

  Widget _buildRichText(BuildContext context) {
    final List<InlineSpan> spans = [];
    final RegExp iconRegex = RegExp(r'\[([^\]]+)\]');
    
    int lastMatchEnd = 0;
    final matches = iconRegex.allMatches(content);
    
    for (final match in matches) {
      // Add text before the icon
      if (match.start > lastMatchEnd) {
        final textBefore = content.substring(lastMatchEnd, match.start);
        if (textBefore.isNotEmpty) {
          spans.add(TextSpan(text: textBefore));
        }
      }
      
      // Add the icon
      final iconKey = match.group(1)!.toLowerCase();
      if (ContentIconMapper.hasIcon(iconKey)) {
        spans.add(WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: ContentIconMapper.buildIcon(
              iconKey,
              color: iconColor ?? const Color(0xFF8B4513),
              size: iconSize,
            ),
          ),
          alignment: PlaceholderAlignment.middle,
        ));
      } else {
        // If icon doesn't exist, keep the original text
        spans.add(TextSpan(text: match.group(0)!));
      }
      
      lastMatchEnd = match.end;
    }
    
    // Add remaining text after the last icon
    if (lastMatchEnd < content.length) {
      final remainingText = content.substring(lastMatchEnd);
      if (remainingText.isNotEmpty) {
        spans.add(TextSpan(text: remainingText));
      }
    }
    
    // If no icons were found, return simple text
    if (spans.isEmpty) {
      spans.add(TextSpan(text: content));
    }
    
    return RichText(
      text: TextSpan(
        children: spans,
        style: textStyle ?? context.secondaryFont(
          fontSize: 14,
          color: const Color(0xFF5A4E3C),
          height: 1.6,
        ),
      ),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}

/// Extension to make it easier to use with existing text widgets
extension RichContentExtension on String {
  Widget toRichContent({
    TextStyle? style,
    double iconSize = 20,
    Color? iconColor,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
  }) {
    return RichContentText(
      this,
      textStyle: style,
      iconSize: iconSize,
      iconColor: iconColor,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}

/// Widget for displaying content with icon previews
class ContentPreview extends StatelessWidget {
  final String content;
  final String title;
  final int maxLines;

  const ContentPreview({
    super.key,
    required this.content,
    required this.title,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    final iconKeys = ContentIconMapper.extractIconKeys(content);
    
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icons
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: context.primaryFont(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5A4E3C),
                    ),
                  ),
                ),
                if (iconKeys.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  ...iconKeys.take(3).map((key) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: ContentIconMapper.buildIcon(
                      key,
                      size: 18,
                      color: const Color(0xFF8B4513),
                    ),
                  )),
                  if (iconKeys.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '+${iconKeys.length - 3}',
                        style: context.secondaryFont(
                          fontSize: 12,
                          color: const Color(0xFF8B7355),
                        ),
                      ),
                    ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            // Content with rich text and box support
            BoxedContentText(
              content,
              textStyle: context.secondaryFont(
                fontSize: 14,
                color: const Color(0xFF5A4E3C),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
