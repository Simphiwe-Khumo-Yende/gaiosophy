import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:gaiosophy_app/presentation/widgets/content_box_parser.dart';

void main() {
  group('Consistent Rendering Fix Tests', () {
    testWidgets('should render HTML content consistently regardless of box tags', (WidgetTester tester) async {
      // Elder content (problematic) - has HTML tags
      const elderContent = '''
<div><b>Ethical Foraging Practices</b></div>
<div><div><b><br></b></div></div>
<div><div><b>Ask Permission:</b></div></div>
<div><div>🌳 Before harvesting and request the tree's blessing. Listen with your heart for the response.</div></div>
      ''';

      // Bramble content (working) - has box tags
      const brambleContent = '''
[box-start:info]
Ask Permission:
Before harvesting and request Bramble's blessing. Listen with your heart for the response.

Leave Offerings:
A strand of hair, a song, or a splash of water. Honour the reciprocal relationship between human and plant.
[box-end]

Harvest Sustainably:
Take no more than one-third from any patch.
      ''';

      // Test Elder content
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Elder Content:'),
                BoxedContentText(elderContent),
                SizedBox(height: 20),
                Text('Bramble Content:'),
                BoxedContentText(brambleContent),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Both should render without errors
      expect(find.byType(BoxedContentText), findsNWidgets(2));
      
      // Should NOT find raw HTML tags in either
      expect(find.textContaining('<div>'), findsNothing);
      expect(find.textContaining('<b>'), findsNothing);
      
      // Should NOT find raw box tags in either
      expect(find.textContaining('[box-start:info]'), findsNothing);
      expect(find.textContaining('[box-end]'), findsNothing);
      
      print('✅ Both Elder and Bramble content render consistently without raw tags!');
    });

    test('should parse both HTML and box content using same method', () {
      const htmlContent = '<div><b>HTML Content</b></div>';
      const boxContent = '[box-start:info]Box Content[box-end]';
      const mixedContent = '<p>HTML</p>[box-start:info]Box[box-end]';
      
      // All should be parsed by the same method now
      final htmlSections = ContentBoxParser.parseContent(htmlContent);
      final boxSections = ContentBoxParser.parseContent(boxContent);
      final mixedSections = ContentBoxParser.parseContent(mixedContent);
      
      expect(htmlSections.isNotEmpty, isTrue);
      expect(boxSections.isNotEmpty, isTrue);
      expect(mixedSections.isNotEmpty, isTrue);
      
      print('✅ All content types parsed consistently!');
    });
  });
}
