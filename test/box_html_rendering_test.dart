import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gaiosophy_app/presentation/widgets/enhanced_html_renderer.dart';

void main() {
  group('HTML Box Rendering Tests', () {
    testWidgets('should properly render content with both HTML and box tags', (WidgetTester tester) async {
      // This is the exact content that's showing box tags instead of proper boxes
      const contentWithBoxAndHtml = '''
[box-start:magical]
[ritual] Leave offerings or sing songs at the roots of an elder tree when harvesting. This honors the Elder Mother, the spirit who guards the tree and bestows her gifts.
[box-end]

<div><div>[protection] Hang sprigs of elder above doors and windows to ward off harmful spirits and ill intent. 🌳 Elder has long been revered as a tree of boundary and protection.</div></div>

<div><div><b>Threshold Guardian</b></div></div>

[box-start:magical]
[protection] Hang sprigs of elder above doors and windows to ward off harmful spirits and ill intent. 🌳 Elder has long been revered as a tree of boundary and protection.
[box-end]
      ''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFFFCF9F2),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: EnhancedHtmlRenderer(
                content: contentWithBoxAndHtml,
                iconSize: 20,
                iconColor: const Color(0xFF8B6B47),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the enhanced renderer renders without errors
      expect(find.byType(EnhancedHtmlRenderer), findsOneWidget);
      
      // The content should not contain raw box tags when properly rendered
      expect(find.textContaining('[box-start:magical]'), findsNothing);
      expect(find.textContaining('[box-end]'), findsNothing);
      
      // HTML should be properly rendered (not as raw tags)
      expect(find.textContaining('<div>'), findsNothing);
      expect(find.textContaining('<b>'), findsNothing);
      
      // But we should find the actual content text
      expect(find.textContaining('Leave offerings'), findsAtLeast(1));
      expect(find.textContaining('Threshold Guardian'), findsWidgets);
    });
  });
}
