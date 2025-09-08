import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gaiosophy_app/presentation/widgets/enhanced_html_renderer.dart';

void main() {
  group('Enhanced HTML Renderer Tests - HTML Parsing Issue', () {
    testWidgets('should properly render HTML tags instead of showing them as text', (WidgetTester tester) async {
      // This is the type of content that was showing raw HTML tags
      const problematicContent = '''
        <div><b>Threshold Guardians</b></div>
        <div>[protection] Hang sprigs of elder above doors and windows to ward off harmful spirits and ill intent.</div>
        <div><b>Ancestral Communion</b></div>
        <div>[ritual] Pour elderflower tea or elderberry syrup as libation on the earth.</div>
      ''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedHtmlRenderer(
              content: problematicContent,
              iconSize: 20,
              iconColor: const Color(0xFF8B6B47),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The HTML should be processed, so we should NOT find raw HTML tags as text
      expect(find.text('<div>'), findsNothing);
      expect(find.text('<b>'), findsNothing);
      expect(find.text('</b>'), findsNothing);
      expect(find.text('</div>'), findsNothing);
      
      // But we should find the actual content text
      expect(find.textContaining('Threshold Guardians'), findsWidgets);
      expect(find.textContaining('Ancestral Communion'), findsWidgets);
      
      // And the widget should render without errors
      expect(find.byType(EnhancedHtmlRenderer), findsOneWidget);
    });

    testWidgets('should handle mixed HTML and icon content correctly', (WidgetTester tester) async {
      const mixedContent = '''
        <p>This is a <b>bold</b> paragraph with [protection] icon.</p>
        <div>Another div with [ritual] and <em>italic</em> text.</div>
        [box-start:info]
        <h3>Boxed Content</h3>
        <p>This box contains HTML and [magical] icons.</p>
        [box-end]
      ''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedHtmlRenderer(
              content: mixedContent,
              iconSize: 20,
              iconColor: const Color(0xFF8B6B47),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should not show raw HTML tags
      expect(find.text('<p>'), findsNothing);
      expect(find.text('<b>'), findsNothing);
      expect(find.text('<em>'), findsNothing);
      expect(find.text('<h3>'), findsNothing);
      
      // Should find processed content
      expect(find.textContaining('bold'), findsWidgets);
      expect(find.textContaining('italic'), findsWidgets);
      expect(find.textContaining('Boxed Content'), findsWidgets);
      
      // Should have a Container for the boxed section
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });
  });
}
