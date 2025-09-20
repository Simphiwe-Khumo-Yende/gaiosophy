import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaiosophy_app/presentation/widgets/content_box_parser.dart';

void main() {
  group('Dynamic Box Colors Tests', () {
    testWidgets('should use #F2E9D7 for original [box-start] tags', (WidgetTester tester) async {
      const testContent = '''
[box-start]
Original box content with default styling.
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

      // Find all Container widgets (boxes)
      final containerFinders = find.byType(Container);
      expect(containerFinders, findsWidgets);

      // Check that containers with original box styling use #F2E9D7
      final containers = tester.widgetList<Container>(containerFinders);
      
      bool foundOriginalBox = false;
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration != null && 
            decoration.color == const Color(0xFFF2E9D7) &&
            decoration.borderRadius != null) {
          foundOriginalBox = true;
        }
      }
      
      expect(foundOriginalBox, isTrue, reason: 'Should find original box with #F2E9D7 color');
    });

    testWidgets('should use #F1ECE1 for [box-start-1] tags', (WidgetTester tester) async {
      const testContent = '''
[box-start-1]
Box variant 1 content with light beige styling.
[box-end-1]
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

      // Find all Container widgets (boxes)
      final containerFinders = find.byType(Container);
      expect(containerFinders, findsWidgets);

      // Check that containers with variant 1 styling use #F1ECE1
      final containers = tester.widgetList<Container>(containerFinders);
      
      bool foundVariant1Box = false;
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration != null && 
            decoration.color == const Color(0xFFF1ECE1) &&
            decoration.borderRadius != null) {
          foundVariant1Box = true;
        }
      }
      
      expect(foundVariant1Box, isTrue, reason: 'Should find variant 1 box with #F1ECE1 color');
    });

    testWidgets('should use #F2E9D7 for [box-start-2] tags', (WidgetTester tester) async {
      const testContent = '''
[box-start-2]
Box variant 2 content with original beige styling.
[box-end-2]
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

      // Find all Container widgets (boxes)
      final containerFinders = find.byType(Container);
      expect(containerFinders, findsWidgets);

      // Check that containers with variant 2 styling use #F2E9D7
      final containers = tester.widgetList<Container>(containerFinders);
      
      bool foundVariant2Box = false;
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration != null && 
            decoration.color == const Color(0xFFF2E9D7) &&
            decoration.borderRadius != null) {
          foundVariant2Box = true;
        }
      }
      
      expect(foundVariant2Box, isTrue, reason: 'Should find variant 2 box with #F2E9D7 color');
    });

    testWidgets('should handle multiple box variants in the same content', (WidgetTester tester) async {
      const testContent = '''
Regular content before boxes.

[box-start-1]
First variant box with light beige styling.
[box-end-1]

Some text between boxes.

[box-start]
Original box with default styling.
[box-end]

More text.

[box-start-2]
Second variant box with original beige styling.
[box-end-2]
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

      // Find all Container widgets (boxes)
      final containerFinders = find.byType(Container);
      expect(containerFinders, findsWidgets);

      // Check that we have the expected color combinations
      final containers = tester.widgetList<Container>(containerFinders);
      
      bool foundVariant1Box = false;
      bool foundOriginalBox = false;
      bool foundVariant2Box = false;
      
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration != null && decoration.borderRadius != null) {
          if (decoration.color == const Color(0xFFF1ECE1)) {
            foundVariant1Box = true;
          } else if (decoration.color == const Color(0xFFF2E9D7)) {
            // Could be either original or variant 2 (both use same color)
            foundOriginalBox = true;
            foundVariant2Box = true;
          }
        }
      }
      
      expect(foundVariant1Box, isTrue, reason: 'Should find variant 1 box with #F1ECE1 color');
      expect(foundOriginalBox, isTrue, reason: 'Should find original box with #F2E9D7 color');
      expect(foundVariant2Box, isTrue, reason: 'Should find variant 2 box with #F2E9D7 color');
    });

    testWidgets('should support styles with variants', (WidgetTester tester) async {
      const testContent = '''
[box-start-1:warning]
Variant 1 box with warning style should still use #F1ECE1.
[box-end-1]

[box-start-2:info]
Variant 2 box with info style should still use #F2E9D7.
[box-end-2]
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

      // Find all Container widgets (boxes)
      final containerFinders = find.byType(Container);
      expect(containerFinders, findsWidgets);

      // Check colors are still variant-based, not style-based
      final containers = tester.widgetList<Container>(containerFinders);
      
      bool foundVariant1Color = false;
      bool foundVariant2Color = false;
      
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration != null && decoration.borderRadius != null) {
          if (decoration.color == const Color(0xFFF1ECE1)) {
            foundVariant1Color = true;
          } else if (decoration.color == const Color(0xFFF2E9D7)) {
            foundVariant2Color = true;
          }
        }
      }
      
      expect(foundVariant1Color, isTrue, reason: 'Variant 1 should use #F1ECE1 regardless of style');
      expect(foundVariant2Color, isTrue, reason: 'Variant 2 should use #F2E9D7 regardless of style');
    });

    test('should correctly detect box variants in hasBoxTags', () {
      expect(ContentBoxParser.hasBoxTags('[box-start]content[box-end]'), isTrue);
      expect(ContentBoxParser.hasBoxTags('[box-start-1]content[box-end-1]'), isTrue);
      expect(ContentBoxParser.hasBoxTags('[box-start-2]content[box-end-2]'), isTrue);
      expect(ContentBoxParser.hasBoxTags('[box-start:style]content[box-end]'), isTrue);
      expect(ContentBoxParser.hasBoxTags('[box-start-1:warning]content[box-end-1]'), isTrue);
      expect(ContentBoxParser.hasBoxTags('regular content'), isFalse);
    });

    test('should correctly remove all box variant tags', () {
      const content = '''
Regular content.
[box-start]Box content[box-end]
[box-start-1:warning]Variant 1 content[box-end-1]
[box-start-2]Variant 2 content[box-end-2]
More regular content.
''';
      
      final cleaned = ContentBoxParser.removeBoxTags(content);
      
      expect(cleaned, contains('Regular content.'));
      expect(cleaned, contains('Box content'));
      expect(cleaned, contains('Variant 1 content'));
      expect(cleaned, contains('Variant 2 content'));
      expect(cleaned, contains('More regular content.'));
      expect(cleaned, isNot(contains('[box-start')));
      expect(cleaned, isNot(contains('[box-end')));
    });
  });
}