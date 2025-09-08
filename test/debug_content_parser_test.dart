import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gaiosophy_app/presentation/widgets/content_box_parser.dart';

void main() {
  group('Content Box Parser Debug Tests', () {
    testWidgets('should parse box and HTML content correctly', (WidgetTester tester) async {
      const testContent = '''
[box-start:magical]
<b>Boxed Bold Text</b>
[box-end]

<p>Regular HTML paragraph with <strong>bold</strong> text.</p>
      ''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoxedContentText(testContent),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Just verify the widget renders without errors
      expect(find.byType(BoxedContentText), findsOneWidget);
      
      // Print all text widgets to see what's actually being rendered
      final finder = find.byType(Text);
      final widgets = tester.widgetList(finder);
      print('Text widgets found: ${widgets.length}');
      for (final widget in widgets) {
        if (widget is Text) {
          print('Text content: "${widget.data}"');
        }
      }
    });

    test('should detect HTML tags correctly', () {
      const htmlContent = '<p>This has <b>HTML</b> tags</p>';
      const noHtmlContent = 'This has no HTML tags';
      
      expect(ContentBoxParser.hasHtmlTags(htmlContent), isTrue);
      expect(ContentBoxParser.hasHtmlTags(noHtmlContent), isFalse);
    });

    test('should detect box tags correctly', () {
      const boxContent = '[box-start:info]Content[box-end]';
      const noBoxContent = 'This has no box tags';
      
      expect(ContentBoxParser.hasBoxTags(boxContent), isTrue);
      expect(ContentBoxParser.hasBoxTags(noBoxContent), isFalse);
    });
  });
}
