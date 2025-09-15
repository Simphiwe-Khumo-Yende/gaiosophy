import 'package:flutter_test/flutter_test.dart';
import '../lib/presentation/widgets/content_box_parser.dart';

void main() {
  group('HTML Stripping Tests', () {
    test('should strip HTML tags and preserve icon tags', () {
      const htmlContent = '''
<div><h>Threshold Guardians</h></div>
<div><div><b><br></b></div><div>
</div><div>[protection] Hang sprigs of elder above doors and windows to ward off harmful spirits and ill intent. Elder has long been revered as a tree of boundary and protection.</div><div>
</div></div><div><br></div><div><b>Ancestral Communion</b></div><div><b><br></b></div><div>
</div><div>[ritual] Pour elderflower tea or elderberry syrup as libation on the earth, calling in the wisdom of your lineage. [magical] Elder opens the bridge between worlds and helps us listen to those</div>
''';

      final strippedContent = ContentBoxParser.stripHtml(htmlContent);
      
      // Should remove all HTML tags
      expect(strippedContent.contains('<'), false);
      expect(strippedContent.contains('>'), false);
      expect(strippedContent.contains('<div>'), false);
      expect(strippedContent.contains('</div>'), false);
      expect(strippedContent.contains('<b>'), false);
      expect(strippedContent.contains('</b>'), false);
      expect(strippedContent.contains('<br>'), false);
      expect(strippedContent.contains('<h>'), false);
      expect(strippedContent.contains('</h>'), false);
      
      // Should preserve icon tags
      expect(strippedContent.contains('[protection]'), true);
      expect(strippedContent.contains('[ritual]'), true);
      expect(strippedContent.contains('[magical]'), true);
      
      // Should preserve actual text content
      expect(strippedContent.contains('Threshold Guardians'), true);
      expect(strippedContent.contains('Hang sprigs of elder'), true);
      expect(strippedContent.contains('Ancestral Communion'), true);
      expect(strippedContent.contains('Pour elderflower tea'), true);
      
      
      
      
    });

    test('should handle content with box sections and HTML', () {
      const htmlContent = '''
<div>Regular content before box.</div>

[box-start:magical]
<p>[protection] This is inside a box with HTML</p>
<div>[ritual] Another line with HTML tags</div>
[box-end]

<div>Content after box with [herb] icon.</div>
''';

      final strippedContent = ContentBoxParser.stripHtml(htmlContent);
      
      // Should preserve box tags
      expect(strippedContent.contains('[box-start:magical]'), true);
      expect(strippedContent.contains('[box-end]'), true);
      
      // Should preserve icon tags
      expect(strippedContent.contains('[protection]'), true);
      expect(strippedContent.contains('[ritual]'), true);
      expect(strippedContent.contains('[herb]'), true);
      
      // Should remove HTML tags
      expect(strippedContent.contains('<div>'), false);
      expect(strippedContent.contains('<p>'), false);
      
      
    });
  });
}
