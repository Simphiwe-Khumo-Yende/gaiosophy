import 'package:flutter/material.dart';
import 'lib/presentation/widgets/content_box_parser.dart';

void main() {
  runApp(const BoxTestApp());
}

class BoxTestApp extends StatelessWidget {
  const BoxTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFCF9F2), // App background color
        appBar: AppBar(
          title: const Text('Box Section Test'),
          backgroundColor: const Color(0xFFFCF9F2),
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Testing Static Box Color #E5E7EB',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              
              // Test magical box with icons
              BoxedContentText(
                '''
Here is some example content with magical symbols.

[box-start:magical]
This is a [magical] box section with [protection] and [ritual] elements.
The [tree] spirits guide us through [herb] wisdom.
[box-end]

And here's more content after the box.
                ''',
                textStyle: TextStyle(fontSize: 16, height: 1.5),
              ),
              
              SizedBox(height: 20),
              
              // Test different box styles (should all use same color now)
              BoxedContentText(
                '''
Testing different box styles:

[box-start:warning]
This should use static color #E5E7EB
[box-end]

[box-start:info]
This should also use static color #E5E7EB
[box-end]

[box-start:seasonal]
This should also use static color #E5E7EB 
[box-end]
                ''',
                textStyle: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
