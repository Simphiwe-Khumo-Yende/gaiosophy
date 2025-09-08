import 'package:flutter/material.dart';
import 'package:gaiosophy_app/presentation/widgets/enhanced_html_renderer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFCF9F2),
        appBar: AppBar(title: Text('HTML Renderer Test')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Test 1: Basic HTML with Icons'),
                SizedBox(height: 10),
                EnhancedHtmlRenderer(
                  content: '''
                    <div><b>Threshold Guardians</b> [protection] Hang sprigs of elder above doors and windows to ward off harmful spirits and ill intent. Elder has long been revered as a tree of boundary and protection.</div>
                    <div><b>Ancestral Communion</b> [ritual] Pour elderflower tea or elderberry syrup as libation on the earth, calling in the wisdom of your lineage. [magical] Elder opens the bridge between worlds and helps us listen to those who have walked before us.</div>
                  ''',
                  iconSize: 20,
                  iconColor: const Color(0xFF8B6B47),
                ),
                SizedBox(height: 20),
                Text('Test 2: Content with Box Section'),
                SizedBox(height: 10),
                EnhancedHtmlRenderer(
                  content: '''
                    Regular content before box.
                    [box-start:info]
                    <p>This is boxed content with <b>bold text</b> and [protection] icon.</p>
                    [box-end]
                    Regular content after box.
                  ''',
                  iconSize: 20,
                  iconColor: const Color(0xFF8B6B47),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
