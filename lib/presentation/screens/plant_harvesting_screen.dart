import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;

class PlantHarvestingScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;
  final Color backgroundColor = const Color(0xFFFCF9F2);
  final Color boxColor = const Color(0xFFE9E2D5);
  final Color textColor = const Color(0xFF5A4E3C);

  const PlantHarvestingScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    // Debug logging
    print('=== PLANT HARVESTING SCREEN ===');
    print('ContentBlock ID: ${contentBlock.id}');
    print('ContentBlock Type: ${contentBlock.type}');
    print('ContentBlock Order: ${contentBlock.order}');
    print('Has HTML content: ${contentBlock.data.content != null && contentBlock.data.content!.isNotEmpty}');
    print('HTML content length: ${contentBlock.data.content?.length ?? 0}');
    print('================================');

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home_outlined, color: textColor),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  contentBlock.data.title ?? 'Harvesting $parentTitle',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Seasonal Icons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSeasonIcon(context, Icons.local_florist, 'Spring'),
                  _buildSeasonIcon(context, Icons.wb_sunny, 'Summer'),
                  _buildSeasonIcon(context, Icons.eco, 'Autumn'),
                  _buildSeasonIcon(context, Icons.ac_unit, 'Winter'),
                ],
              ),
              const SizedBox(height: 20),
              
              // Timeline
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jan', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor)),
                    Expanded(
                      child: Slider(
                        value: 0.7,
                        onChanged: (value) {},
                        activeColor: Colors.brown[400],
                        inactiveColor: Colors.brown[200],
                      ),
                    ),
                    Text('Dec', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Subtitle if available (Ethical Foraging Practices)
              if (contentBlock.data.subtitle != null) ...[
                Text(
                  contentBlock.data.subtitle!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              
              // Main Content from Firestore
              if (contentBlock.data.content != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Html(
                    data: contentBlock.data.content!,
                    style: {
                      "body": Style(
                        color: textColor,
                        fontSize: FontSize(16),
                        lineHeight: const LineHeight(1.5),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "h1, h2, h3, h4, h5, h6": Style(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: FontSize(18),
                        margin: Margins.only(top: 16, bottom: 8),
                      ),
                      "p": Style(
                        color: textColor,
                        margin: Margins.only(bottom: 12),
                        fontSize: FontSize(14),
                      ),
                      "ul, ol": Style(
                        color: textColor,
                        margin: Margins.zero,
                        padding: HtmlPaddings.only(left: 16),
                      ),
                      "li": Style(
                        color: textColor,
                        margin: Margins.zero,
                        fontSize: FontSize(14),
                        lineHeight: const LineHeight(1.1),
                      ),
                      "b, strong": Style(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                      "span": Style(
                        color: textColor,
                      ),
                    },
                    onLinkTap: (url, _, __) {
                      // Handle link taps if needed
                      print('Link tapped: $url');
                    },
                    extensions: [
                      TagExtension(
                        tagsToExtend: {"li"},
                        builder: (extensionContext) {
                          final element = extensionContext.element;
                          if (element == null) return const SizedBox.shrink();

                          final parent = element.parent;
                          final isOrdered = parent?.localName == 'ol';
                          final index = parent != null ? parent.children.indexOf(element) : 0;

                          IconData icon;
                          if (isOrdered) {
                            // Use numbered icons for ordered lists
                            switch (index) {
                              case 0: icon = Icons.looks_one_outlined; break;
                              case 1: icon = Icons.looks_two_outlined; break;
                              case 2: icon = Icons.looks_3_outlined; break;
                              case 3: icon = Icons.looks_4_outlined; break;
                              case 4: icon = Icons.looks_5_outlined; break;
                              default: icon = Icons.circle_outlined; break;
                            }
                          } else {
                            // Determine icon based on content keywords
                            final text = element.text.toLowerCase();
                            if (text.contains('harvest') || text.contains('collect')) {
                              icon = Icons.agriculture_outlined;
                            } else if (text.contains('season') || text.contains('time')) {
                              icon = Icons.schedule_outlined;
                            } else if (text.contains('prepare') || text.contains('process')) {
                              icon = Icons.build_outlined;
                            } else if (text.contains('store') || text.contains('preserve')) {
                              icon = Icons.inventory_outlined;
                            } else if (text.contains('dry') || text.contains('drying')) {
                              icon = Icons.wb_sunny_outlined;
                            } else if (text.contains('caution') || text.contains('warning')) {
                              icon = Icons.warning_outlined;
                            } else {
                              icon = Icons.eco_outlined;
                            }
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(icon, size: 16, color: textColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Html(
                                    data: element.innerHtml,
                                    style: {
                                      "body": Style(
                                        fontSize: FontSize(14),
                                        color: textColor,
                                        lineHeight: LineHeight(1.5),
                                        margin: Margins.zero,
                                        padding: HtmlPaddings.zero,
                                      ),
                                      "p": Style(
                                        fontSize: FontSize(14),
                                        color: textColor,
                                        lineHeight: LineHeight(1.5),
                                        margin: Margins.zero,
                                        padding: HtmlPaddings.zero,
                                      ),
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeasonIcon(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: boxColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: textColor, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
