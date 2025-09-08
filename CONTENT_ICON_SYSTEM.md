# Content Icon & Box System

## Overview
The content system provides two powerful features for enhancing botanical content:
1. **Icon Mapping**: Embed icons directly in text using simple key-based syntax
2. **Box Sections**: Create highlighted content sections with special styling

This system enhances the visual appeal of educational botanical content while maintaining readability.

## Icon Mapping System

### Basic Usage
Wrap icon keys in square brackets within your content:

```
[morning] Upon sunrise, venture into the [forest] to collect [herb] specimens.
```

This will render as: ☀️ Upon sunrise, venture into the 🌲 to collect 🌿 specimens.

## Box Section System

### Basic Usage
Wrap content in [box-start] and [box-end] tags to create highlighted sections:

```
Regular content here...

[box-start]
[herb] Chamomile flowers - 2 tablespoons
[leaf] Peppermint leaves - 1 tablespoon
[water] Filtered water - 2 cups
[honey] Raw honey - to taste (optional)
[box-end]

Continue with regular content...
```

### Styled Box Sections
Add style identifiers to customize the appearance of box sections:

```
[box-start:warning]
[caution] Never consume unidentified plants
[toxic] Some varieties can be dangerous
[box-end]

[box-start:recipe]
[herb] Dried lavender - 1 tablespoon
[oil] Carrier oil - 4 tablespoons
[box-end]

[box-start:info]
[morning] Best harvested in early morning
[dew] When dew is still present
[box-end]
```

### Available Box Styles

#### Warning/Danger (Red Theme)
- `[box-start:warning]` - Light red background for cautions
- `[box-start:danger]` - Same as warning 
- `[box-start:caution]` - Same as warning

#### Information/Tips (Blue Theme)
- `[box-start:info]` - Light blue background for general info
- `[box-start:note]` - Same as info
- `[box-start:tip]` - Same as info

#### Success/Safety (Green Theme)
- `[box-start:success]` - Light green background for positive info
- `[box-start:safe]` - Same as success
- `[box-start:healing]` - Same as success

#### Recipes/Preparation (Orange Theme)
- `[box-start:recipe]` - Light orange background for recipes
- `[box-start:ingredients]` - Same as recipe
- `[box-start:preparation]` - Same as recipe

#### Magical/Mystical (Purple Theme)
- `[box-start:magical]` - Light purple background for mystical content
- `[box-start:mystical]` - Same as magical
- `[box-start:ritual]` - Same as magical

#### Seasonal/Timing (Yellow Theme)
- `[box-start:seasonal]` - Light yellow background for timing info
- `[box-start:timing]` - Same as seasonal
- `[box-start:calendar]` - Same as seasonal

#### Default Style (Beige Theme)
- `[box-start]` - Default beige background (backwards compatible)
- Any unrecognized style defaults to beige theme

### Icon Categories

#### 🌿 Plant & Nature
- `tree`, `flower`, `grass`, `leaf`, `herb`, `mushroom`, `vine`, `bush`, `fern`, `moss`
- `root`, `stem`, `branch`, `bark`, `seed`, `fruit`, `berry`, `nut`, `pod`, `bulb`

#### 🌦️ Seasons & Weather  
- `spring`, `summer`, `autumn`, `winter`, `snowflake`, `rain`, `sun`, `cloud`, `wind`, `frost`

#### 🔬 Scientific & Educational
- `scientific`, `botanical`, `medicinal`, `edible`, `toxic`, `rare`, `common`, `endangered`, `protected`, `native`

#### 🏥 Health & Safety
- `healing`, `medicine`, `vitamin`, `safe`, `caution`, `danger`, `poison`, `allergic`

#### 🌍 Location & Habitat
- `forest`, `meadow`, `mountain`, `water`, `wetland`, `desert`, `garden`, `wild`, `urban`, `coastal`

#### ⚗️ Preparation & Usage
- `tea`, `extract`, `oil`, `powder`, `fresh`, `dried`, `cooked`, `raw`, `topical`, `oral`

#### ⏰ Timing & Lifecycle
- `morning`, `noon`, `evening`, `night`, `dawn`, `dusk`, `harvest`, `blooming`, `growth`

## Implementation

### Using RichContentText Widget (Icons Only)
```dart
RichContentText(
  '[morning] Begin harvesting [herb] plants in the [forest]',
  textStyle: TextStyle(fontSize: 16),
  iconSize: 20,
  iconColor: Color(0xFF8B4513),
)
```

### Using BoxedContentText Widget (Icons + Box Sections)
```dart
BoxedContentText(
  'Regular content with [herb] icons.\n\n[box-start]\nSpecial highlighted content here\n[box-end]\n\nMore content...',
  textStyle: TextStyle(fontSize: 16),
  iconSize: 20,
  iconColor: Color(0xFF8B4513),
)
```

### Using Extension Method
```dart
'[tea] Brew fresh [herb] leaves for [healing] properties'.toRichContent(
  iconSize: 18,
  iconColor: Colors.green,
)
```

### ContentPreview Widget (Automatically Handles Both)
For content cards with icon indicators and box sections:
```dart
ContentPreview(
  title: 'Morning Foraging',
  content: '[morning] Look for [safe] [herb] varieties...\n\n[box-start]\nImportant safety notes here\n[box-end]',
  maxLines: 4,
)
```

## Backend Data Structure

When storing content in your backend, simply include icon keys and styled box sections in the text:

```json
{
  "title": "Chamomile Safety & Preparation",
  "content": "[morning] The best time to harvest [flower] chamomile is early [morning] when the [dew] is still present.\n\n[box-start:warning]\n[caution] Always properly identify plants before harvesting\n[expert] Consult field guides or experts when in doubt\n[allergic] Some people may be allergic to chamomile\n[box-end]\n\n[box-start:recipe]\n[herb] Chamomile flowers - 2 tablespoons\n[water] Hot water - 2 cups\n[honey] Raw honey - to taste\n[box-end]\n\n[tea] Steep for 5-8 minutes. This [herb] is generally [safe] for [tea] preparation and has [healing] properties for [digestive] issues.\n\n[box-start:info]\n[botanical] Scientific name: Matricaria chamomilla\n[native] Native to Europe and western Asia\n[cultivation] Now cultivated worldwide\n[box-end]"
}
```

## Box Section Features

### Dynamic Styling
Box sections now support dynamic styling through backend-defined tags:
- **Style Tags**: Content creators can specify visual themes using `[box-start:style]`
- **Color Themes**: Each style has its own color scheme and visual identity
- **Semantic Meaning**: Styles convey meaning (warning=red, info=blue, etc.)
- **Backwards Compatible**: Plain `[box-start]` still works with default styling

### Styling System
- **Background Colors**: Each style has a specific background color
- **Border Colors**: Matching border colors for visual cohesion  
- **Border Radius**: Consistent 12px rounded corners
- **Padding**: 20px padding for comfortable reading
- **Margins**: 8px vertical margins for proper spacing

### Use Cases by Style
- **Warning/Danger**: Safety instructions, poisonous plants, cautions
- **Info/Note/Tip**: General information, helpful notes, tips
- **Success/Safe/Healing**: Safe plants, healing properties, positive info
- **Recipe/Ingredients**: Preparation steps, ingredient lists, cooking
- **Magical/Mystical**: Ritual instructions, magical properties, spells
- **Seasonal/Timing**: Harvest times, seasonal information, calendars

### Box Section Examples

#### Recipe Ingredients (Orange Theme)
```
[box-start:recipe]
[herb] Dried lavender - 1 tablespoon
[oil] Carrier oil - 4 tablespoons
[container] Dark glass bottle
[box-end]
```

#### Safety Warning (Red Theme)
```
[box-start:warning]
[caution] Never consume unidentified plants
[toxic] Some plants can be dangerous
[expert] Always consult with professionals
[box-end]
```

#### Healing Information (Green Theme)
```
[box-start:healing]
[safe] Chamomile is gentle for most people
[healing] Promotes relaxation and sleep
[tea] Safe for daily consumption
[box-end]
```

#### Magical Properties (Purple Theme)
```
[box-start:magical]
[protection] Bramble thorns ward off negativity
[ritual] Use in protection spells
[moon] Gather under full moon for potency
[box-end]
```

#### Timing Information (Yellow Theme)
```
[box-start:seasonal]
[spring] Best collected in late spring
[morning] Harvest in early morning hours
[flower] When flowers are fully bloomed
[box-end]
```

#### General Information (Blue Theme)
```
[box-start:info]
[botanical] Scientific name: Rubus species
[native] Native to temperate regions
[common] Found throughout Europe and Asia
[box-end]
```

## Available Icons

See the Content Icon Demo screen in the app (Settings > Content Icon Demo) for a complete visual reference of all available icons and box section examples.

## Adding New Features

### Adding New Icons
To add new icons to the system:

1. Add the key-value pair to `ContentIconMapper.iconMap`
2. Choose an appropriate Material Design icon
3. Update this documentation
4. Test the icon in the demo screen

### Customizing Box Styles
To customize box decoration:

1. Modify `_defaultBoxDecoration()` in `ContentBoxParser`
2. Or pass custom `BoxDecoration` to `BoxedContentText`
3. Test in the demo screen

## Fallback Behavior

### Icons
- If an icon key is not found, the original text `[key]` is displayed
- HTML content without icon keys is rendered normally
- The system gracefully handles mixed content (HTML + icon keys)

### Box Sections
- If `[box-start]` is found without `[box-end]`, content is treated as regular text
- Unmatched tags are ignored and displayed as regular text
- Multiple box sections in the same content are supported
- Box sections can contain icon tags
- **Style Fallback**: Unknown styles (e.g., `[box-start:unknown]`) default to the beige theme
- **Backwards Compatibility**: Plain `[box-start]` without style works as before

## Parser Functions

### ContentIconMapper
- `hasIcon(String key)` - Check if icon exists
- `buildIcon(String key)` - Create icon widget
- `extractIconKeys(String content)` - Get all icon keys from content

### ContentBoxParser
- `parseContent(String content)` - Parse content into widgets
- `hasBoxTags(String content)` - Check if content has box sections
- `removeBoxTags(String content)` - Remove box tags for plain text

## Performance Notes

- Icon parsing is efficient and cached
- Rich text rendering is optimized for Flutter
- Large content blocks are handled smoothly
- Icon widgets are lightweight Material Design icons
