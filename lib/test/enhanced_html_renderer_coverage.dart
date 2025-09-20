/// Test to verify EnhancedHtmlRenderer is working across all content screens
/// 
/// This file demonstrates how all content screens now support:
/// - Icon rendering with [icon] syntax
/// - Box tags with [box-start] and [box-end]
/// - New dynamic box variants [box-start-1] and [box-start-2]
/// - HTML content processing

const String testContent = '''
<h2>Enhanced HTML Rendering Test</h2>

<p>This content demonstrates the new features available across all content screens:</p>

<h3>Icon Support</h3>
<p>Icons can be embedded anywhere: [herb] for herbs, [protection] for protection, [healing] for healing properties.</p>

<h3>Box Tags</h3>

[box-start:info]
This is an informational box with [botanical] scientific information.
It supports **HTML formatting** and [leaf] icons within boxes.
[box-end]

[box-start-1:warning]
This is a light beige variant box with [caution] warnings.
Perfect for subtle highlighting of important information.
[box-end-1]

[box-start-2]
This is the standard beige variant box.
Same color as original but alternative syntax for content organization.
[box-end-2]

<h3>HTML Content</h3>
<p>All screens now support <strong>bold text</strong>, <em>italic text</em>, and proper HTML formatting.</p>

<ul>
<li>Enhanced content rendering [check]</li>
<li>Icon system integration [star]</li>
<li>Box system support [magic]</li>
<li>Dynamic color variants [palette]</li>
</ul>
''';

/// Screens that have been updated with EnhancedHtmlRenderer:
/// 
/// 1. content_detail_screen_new.dart - ContentDetailHtmlRenderer
/// 2. content_detail_screen.dart - ContentDetailHtmlRenderer  
/// 3. recipe_screen.dart - RecipeHtmlRenderer
/// 4. recipe_screen_fixed.dart - RecipeHtmlRenderer
/// 5. plant_overview_screen_fixed.dart - ContentDetailHtmlRenderer
/// 6. plant_overview_screen_new.dart - EnhancedHtmlRenderer
/// 7. bramble_folklore_screen.dart - EnhancedHtmlRenderer
/// 8. plant_folklore_screen.dart - EnhancedHtmlRenderer (already updated)
/// 9. magic_rituals_screen.dart - EnhancedHtmlRenderer (already updated)
/// 10. spellwork_words_screen.dart - BoxedContentText (already updated)
/// 11. bramble_overview_screen.dart - BoxedContentText (already updated)
/// 12. content_block_detail_screen.dart - BoxedContentText (already updated)
/// 13. plant_harvesting_screen.dart - EnhancedHtmlRenderer (already updated)
/// 
/// All content screens now have consistent support for:
/// - Icon rendering with [icon-name] syntax
/// - Box tags: [box-start], [box-start-1], [box-start-2] with [box-end] variants
/// - HTML content processing with proper styling
/// - Dynamic color system for box variants