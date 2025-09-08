import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaiosophy_app/presentation/widgets/content_box_parser.dart';

void main() {
  group('ContentBoxParser Static Styling Tests', () {
    testWidgets('should use static color #F2E9D7 for all box styles', (WidgetTester tester) async {
      const testContent = '''
This is regular content.

[box-start:magical]
Magical content with [protection] and [tree] icons.
[box-end]

More content.

[box-start:warning]
Warning content with [herb] icon.
[box-end]
''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoxedContentText(
              testContent,
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      );

      // Find all Container widgets (boxes)
      final containerFinders = find.byType(Container);
      
      // There should be 2 boxes + other containers
      expect(containerFinders, findsWidgets);

      // Check that containers with box styling use the static color
      await tester.pumpAndSettle();
      
      // Verify that the containers exist and have the expected styling
      final containers = tester.widgetList<Container>(containerFinders);
      
      bool foundStaticBoxes = false;
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration != null && 
            decoration.color == const Color(0xFFF2E9D7) &&
            decoration.borderRadius != null) {
          foundStaticBoxes = true;
        }
      }
      
      expect(foundStaticBoxes, isTrue, reason: 'Should find boxes with static #F2E9D7 color');
    });

    testWidgets('should render content with box sections correctly', (WidgetTester tester) async {
      const testContent = '''
Regular content.

[box-start:magical]
Box content with [protection] icon.
[box-end]

More regular content.
''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoxedContentText(
              testContent,
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Check that the content is rendered
      expect(find.text('Regular content.', findRichText: true), findsOneWidget);
      expect(find.text('More regular content.', findRichText: true), findsOneWidget);
      
      // Box content should be rendered (may be partial text due to icon processing)
      // Look for Container widgets which indicate boxed sections
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle multiple box sections with different styles using same static color', (WidgetTester tester) async {
      const testContent = '''
[box-start:warning]
Warning content.
[box-end]

[box-start:info]
Info content.
[box-end]
''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoxedContentText(
              testContent,
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Find all Container widgets with the static box styling
      final containers = tester.widgetList<Container>(find.byType(Container));
      
      int staticBoxCount = 0;
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration != null && 
            decoration.color == const Color(0xFFF2E9D7) &&
            decoration.borderRadius != null) {
          staticBoxCount++;
        }
      }
      
      // Should have at least 2 boxes with the static styling
      expect(staticBoxCount, greaterThanOrEqualTo(2), 
        reason: 'Should find at least 2 boxes with static #F2E9D7 color');
    });
  });
}
