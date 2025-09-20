import 'package:flutter/material.dart';
import 'lib/presentation/widgets/content_box_parser.dart';

void main() {
  runApp(UnderlinedTextTestApp());
}

class UnderlinedTextTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Underlined Text Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: UnderlinedTextTestScreen(),
    );
  }
}

class UnderlinedTextTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Test content with underlined text in boxes
    final String testContent = '''
<p>Regular text before the box.</p>

[box-start-1]
This is content in box 1 with <u>Seasonal Rites</u> and <u>Samhain</u> as underlined text.
<br><br>
The underlined text should use Roboto Serif, Regular, size 16, color #5A4E3C, but the underline decoration should be hidden.
[box-end-1]

<p>Regular text between boxes.</p>

[box-start-2]
This is content in box 2 with <u>Ethical Foraging Practices</u> as underlined text.
<br><br>
Icons and underlined text should use the same color: #5A4E3C
[box-end-2]

<p>Regular text after the boxes.</p>
    ''';

    return Scaffold(
      appBar: AppBar(
        title: Text('Underlined Text Styling Test'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Testing Underlined Text Implementation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Expected behavior: Underlined text should use Roboto Serif, Regular, 16px, #5A4E3C color, but NO visible underline.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            ...ContentBoxParser.parseContent(
              testContent,
              iconColor: Color(0xFF5A4E3C),
            ),
          ],
        ),
      ),
    );
  }
}