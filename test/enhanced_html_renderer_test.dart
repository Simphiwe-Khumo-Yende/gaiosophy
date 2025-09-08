import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gaiosophy_app/presentation/widgets/enhanced_html_renderer.dart';

void main() {
  group('EnhancedHtmlRenderer Tests', () {
    testWidgets('should render HTML with icon mapping', (WidgetTester tester) async {
      const testContent = '''
        <h1>Test Content</h1>
        <p>This is a test with [protection] icon and [ritual] icon.</p>
        <div>HTML content with icons.</div>
      ''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedHtmlRenderer(
              content: testContent,
              iconSize: 20,
              iconColor: const Color(0xFF8B6B47),
            ),
          ),
        ),
      );

      // Should not throw any errors and build successfully
      expect(find.byType(EnhancedHtmlRenderer), findsOneWidget);
    });

    testWidgets('should render content with box sections', (WidgetTester tester) async {
      const testContent = '''
        Regular content before box.
        [box-start:info]
        This is boxed content with [protection] icon.
        [box-end]
        Regular content after box.
      ''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedHtmlRenderer(
              content: testContent,
              iconSize: 20,
              iconColor: const Color(0xFF8B6B47),
            ),
          ),
        ),
      );

      expect(find.byType(EnhancedHtmlRenderer), findsOneWidget);
    });

    testWidgets('RecipeHtmlRenderer should have recipe-specific styling', (WidgetTester tester) async {
      const testContent = '''
        <h2>Recipe Instructions</h2>
        <p>Mix the [herb] with water.</p>
        <ul>
          <li>Step 1: Prepare [protection] herbs</li>
          <li>Step 2: Add [ritual] elements</li>
        </ul>
      ''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeHtmlRenderer(
              content: testContent,
              iconSize: 16,
              iconColor: const Color(0xFF8B6B47),
            ),
          ),
        ),
      );

      expect(find.byType(RecipeHtmlRenderer), findsOneWidget);
    });

    testWidgets('ContentDetailHtmlRenderer should render content detail styling', (WidgetTester tester) async {
      const testContent = '''
        <h1>Content Title</h1>
        <p>Content description with [protection] and [ritual] icons.</p>
        [box-start:warning]
        Warning box with [herb] icon.
        [box-end]
      ''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContentDetailHtmlRenderer(
              content: testContent,
              iconSize: 20,
              iconColor: const Color(0xFF8B6B47),
            ),
          ),
        ),
      );

      expect(find.byType(ContentDetailHtmlRenderer), findsOneWidget);
    });
  });
}
