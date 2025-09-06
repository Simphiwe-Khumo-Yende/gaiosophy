# Content Icon Mapping System

## Overview
The content icon mapping system allows you to embed icons directly in text content using simple key-based syntax. This enhances the visual appeal of educational botanical content while maintaining readability.

## How It Works

### Basic Usage
Wrap icon keys in square brackets within your content:

```
[morning] Upon sunrise, venture into the [forest] to collect [herb] specimens.
```

This will render as: ☀️ Upon sunrise, venture into the 🌲 to collect 🌿 specimens.

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

### Using RichContentText Widget
```dart
RichContentText(
  '[morning] Begin harvesting [herb] plants in the [forest]',
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

### ContentPreview Widget
For content cards with icon indicators:
```dart
ContentPreview(
  title: 'Morning Foraging',
  content: '[morning] Look for [safe] [herb] varieties...',
  maxLines: 3,
)
```

## Backend Data Structure

When storing content in your backend, simply include icon keys in the text:

```json
{
  "title": "Chamomile Collection",
  "content": "[morning] The best time to harvest [flower] chamomile is early [morning] when the [dew] is still present. Look for [white] flowers in [meadow] areas. This [herb] is [safe] for [tea] preparation and has [healing] properties for [digestive] issues."
}
```

## Available Icons

See the Content Icon Demo screen in the app (Settings > Content Icon Demo) for a complete visual reference of all available icons.

## Adding New Icons

To add new icons to the system:

1. Add the key-value pair to `ContentIconMapper.iconMap`
2. Choose an appropriate Material Design icon
3. Update this documentation
4. Test the icon in the demo screen

## Fallback Behavior

- If an icon key is not found, the original text `[key]` is displayed
- HTML content without icon keys is rendered normally
- The system gracefully handles mixed content (HTML + icon keys)

## Performance Notes

- Icon parsing is efficient and cached
- Rich text rendering is optimized for Flutter
- Large content blocks are handled smoothly
- Icon widgets are lightweight Material Design icons
