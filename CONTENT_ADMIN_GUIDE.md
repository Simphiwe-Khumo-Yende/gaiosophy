# Gaiosophy Content Admin Guide

## Content Enhancement System

This guide explains how to use the icon mapping and box section systems to create rich, engaging botanical content for the Gaiosophy app.

## Table of Contents
1. [Icon System](#icon-system)
2. [Box Section System](#box-section-system)
3. [Best Practices](#best-practices)
4. [Content Examples](#content-examples)
5. [Troubleshooting](#troubleshooting)

---

## Icon System

### What Are Icons?
Icons are small visual symbols that appear inline with your text to enhance readability and visual appeal. They help users quickly identify key concepts.

### How to Use Icons
Wrap icon keywords in square brackets `[keyword]` within your content.

**Basic Example:**
```
The [herb] chamomile grows best in [morning] sunlight and requires [water] daily.
```

**Result:** The 🌿 chamomile grows best in 🌅 sunlight and requires 💧 daily.

### Available Icon Categories

#### 🌿 Plants & Nature
- `[tree]` `[flower]` `[grass]` `[leaf]` `[herb]` `[mushroom]` `[vine]` `[bush]` `[fern]` `[moss]`
- `[root]` `[stem]` `[branch]` `[bark]` `[seed]` `[fruit]` `[berry]` `[nut]` `[pod]` `[bulb]`

#### 🌦️ Weather & Seasons
- `[spring]` `[summer]` `[autumn]` `[winter]` `[rain]` `[sun]` `[cloud]` `[wind]` `[frost]`

#### ⏰ Time & Timing
- `[morning]` `[noon]` `[evening]` `[night]` `[dawn]` `[dusk]` `[harvest]` `[blooming]`

#### 🏥 Health & Safety
- `[healing]` `[medicine]` `[safe]` `[caution]` `[danger]` `[toxic]` `[allergic]`

#### 🌍 Locations
- `[forest]` `[meadow]` `[mountain]` `[water]` `[garden]` `[wild]` `[coastal]`

#### ⚗️ Preparation Methods
- `[tea]` `[oil]` `[powder]` `[fresh]` `[dried]` `[cooked]` `[raw]` `[topical]`

### Icon Guidelines
- ✅ **DO:** Use icons to highlight important concepts
- ✅ **DO:** Keep icon usage natural and readable
- ❌ **DON'T:** Overuse icons (max 1-2 per sentence)
- ❌ **DON'T:** Use icons for decorative purposes only

---

## Box Section System

### What Are Box Sections?
Box sections create visually distinct highlighted areas in your content. They're perfect for recipes, warnings, tips, and important information.

### Basic Box Syntax
```
[box-start]
Your highlighted content goes here.
This can include multiple lines and [herb] icons.
[box-end]
```

### Box Variants with Different Colors

#### Light Beige Boxes (Color #F1ECE1)
```
[box-start-1]
Content in light beige box.
Perfect for subtle highlights or secondary information.
[box-end-1]
```

#### Standard Beige Boxes (Color #F2E9D7)
```
[box-start-2]
Content in standard beige box.
Same color as original boxes, alternative syntax.
[box-end-2]
```

### Styled Box Sections
Add style tags for different visual themes:

#### Warning/Danger Boxes (Red Theme)
```
[box-start:warning]
[caution] Never consume unidentified plants
[toxic] Some varieties can be extremely dangerous
Always consult with experts before foraging
[box-end]
```

#### Recipe/Ingredient Boxes (Orange Theme)
```
[box-start:recipe]
**Chamomile Sleep Tea**
[herb] Dried chamomile flowers - 2 tablespoons
[water] Hot water - 2 cups
[honey] Raw honey - to taste
[tea] Steep for 5-8 minutes
[box-end]
```

#### Information/Tips Boxes (Blue Theme)
```
[box-start:info]
[botanical] Scientific name: Matricaria chamomilla
[native] Native to Europe and western Asia
[common] Now cultivated worldwide
[box-end]
```

#### Success/Healing Boxes (Green Theme)
```
[box-start:healing]
[safe] Chamomile is gentle for most people
[healing] Promotes relaxation and better sleep
[medicine] Safe for daily consumption as tea
[box-end]
```

#### Magical/Ritual Boxes (Purple Theme)
```
[box-start:magical]
[protection] Bramble thorns ward off negative energy
[ritual] Use in protection spells and ceremonies
[moon] Gather under full moon for maximum potency
[box-end]
```

#### Seasonal/Timing Boxes (Yellow Theme)
```
[box-start:seasonal]
[spring] Best harvested in late spring
[morning] Collect in early morning hours
[flower] When flowers are fully bloomed
[box-end]
```

### Available Box Styles

| Style Tag | Theme | Color | Use For |
|-----------|-------|-------|---------|
| `warning`, `danger`, `caution` | Red | #F2E9D7 | Safety warnings, toxic plants, important cautions |
| `info`, `note`, `tip` | Blue | #F2E9D7 | General information, helpful notes, educational content |
| `success`, `safe`, `healing` | Green | #F2E9D7 | Safe plants, healing properties, positive outcomes |
| `recipe`, `ingredients`, `preparation` | Orange | #F2E9D7 | Recipes, ingredient lists, preparation steps |
| `magical`, `mystical`, `ritual` | Purple | #F2E9D7 | Magical properties, ritual instructions, spiritual content |
| `seasonal`, `timing`, `calendar` | Yellow | #F2E9D7 | Harvest times, seasonal information, timing guides |
| No style (plain `[box-start]`) | Beige | #F2E9D7 | Default styling for general highlights |

### Box Variants with Color Options

| Box Type | Background Color | Border Color | Description |
|----------|------------------|--------------|-------------|
| `[box-start]` / `[box-end]` | #F2E9D7 | #E5D5C0 | Original beige boxes for standard highlights |
| `[box-start-1]` / `[box-end-1]` | #F1ECE1 | #E4D7C4 | Light beige boxes for subtle highlights |
| `[box-start-2]` / `[box-end-2]` | #F2E9D7 | #E5D5C0 | Standard beige boxes (same as original) |

**Note**: All box variants support style parameters (e.g., `[box-start-1:warning]`), but the background color is determined by the variant number, not the style.

---

## Best Practices

### Content Structure
1. **Start with plain text** - Write your content normally first
2. **Add icons strategically** - Enhance key concepts with relevant icons
3. **Create box sections** - Highlight important information in styled boxes
4. **Review and test** - Check how your content looks in the app

### Writing Guidelines

#### For Articles & Educational Content
```
The [herb] elderberry is a powerful [healing] plant that grows in [forest] environments.

[box-start:info]
[botanical] Scientific name: Sambucus canadensis
[season] Blooms in late [spring] to early [summer]
[harvest] [berry] fruits ripen in late [summer]
[box-end]

Traditional uses include [medicine] for immune support and [tea] for respiratory health.

[box-start-1:warning]
[caution] Only use ripe, dark purple berries
[toxic] Raw elderberries can cause stomach upset
[safe] Always cook berries before consumption
[box-end-1]

[box-start-2]
Additional information can go in the standard beige variant boxes
for consistent visual hierarchy in your content.
[box-end-2]
```

#### For Recipes
```
This traditional [herb] nettle soup is perfect for [spring] detoxification.

[box-start:recipe]
**Ingredients:**
[herb] Fresh nettle leaves - 4 cups
[water] Vegetable broth - 4 cups
[bulb] Onion - 1 medium, diced
[herb] Garlic - 2 cloves
[oil] Olive oil - 2 tablespoons
[healing] Salt and pepper to taste
[box-end]

[box-start:preparation]
1. [caution] Wear gloves when handling fresh [herb] nettles
2. [oil] Heat olive oil in large pot
3. [cooking] Sauté onion and garlic until soft
4. [water] Add broth and bring to boil
5. [herb] Add nettles and simmer 10 minutes
6. [blend] Blend until smooth
[box-end]

[box-start:healing]
[medicine] Rich in iron and vitamins
[safe] Cooking neutralizes nettle sting
[spring] Perfect for seasonal cleansing
[box-end]
```

#### For Magical/Spiritual Content
```
[herb] Rosemary has been used for [protection] and [memory] enhancement for centuries.

[box-start:magical]
**Magical Properties:**
[protection] Powerful protective herb
[memory] Enhances mental clarity and remembrance
[purification] Cleanses negative energy
[love] Used in love and fidelity spells
[box-end]

[box-start:ritual]
**Protection Ritual:**
1. [morning] Gather fresh [herb] rosemary at [dawn]
2. [bundle] Tie into small bundles with natural string
3. [smoke] Burn as incense for home protection
4. [door] Hang above doorways and windows
[box-end]
```

### Content Flow Tips
- **Introduce concepts** before using icons
- **Group related information** in appropriate box sections
- **Use consistent terminology** throughout your content
- **Balance text and visual elements** - don't overwhelm with too many icons

---

## Content Examples

### Complete Plant Profile Example
```
**Blackberry (Rubus species)**

The [berry] blackberry is one of nature's most generous gifts, offering both [healing] medicine and delicious [fruit] food throughout the [summer] season.

[box-start:info]
[botanical] Family: Rosaceae
[native] Native to Europe, Asia, and North America
[habitat] Grows in [forest] edges, [meadow] borders, and [garden] landscapes
[season] Flowers in late [spring], fruits in [summer]
[box-end]

**Traditional Uses**

[herb] Blackberry leaves have been used medicinally for centuries. The [leaf] contains tannins that provide [healing] astringent properties.

[box-start:healing]
[medicine] Leaf tea supports digestive health
[safe] Gentle enough for daily use
[traditional] Used by herbalists for diarrhea and inflammation
[topical] Leaf poultices for cuts and scrapes
[box-end]

**Harvesting Guidelines**

[box-start:seasonal]
[spring] [leaf] Leaves: Best in late spring before flowering
[summer] [berry] Fruits: When fully dark and easily detached
[morning] [dew] Harvest in early morning after dew dries
[garden] Choose plants away from roads and pollution
[box-end]

**Preparation Methods**

[box-start:recipe]
**Blackberry Leaf Tea**
[herb] Fresh blackberry leaves - 2 tablespoons
[herb] Or dried leaves - 1 tablespoon
[water] Hot water - 1 cup
[tea] Steep 10-15 minutes, strain and enjoy
[honey] Add honey if desired
[box-end]

[box-start:warning]
[caution] Always properly identify plants before harvesting
[allergic] Test small amounts first if you have allergies
[clean] Wash all plant materials thoroughly
[box-end]

**Magical Properties**

[box-start:magical]
[protection] Bramble thorns create protective barriers
[abundance] Symbol of nature's bounty and prosperity
[ritual] Used in hedge magic and nature-based practices
[moon] Associated with lunar energy and feminine power
[box-end]
```

### Recipe Example
```
**Wild Rose Hip Syrup**

[flower] Rose hips are the [fruit] of wild roses, packed with [medicine] vitamin C and perfect for [winter] immune support.

[box-start:seasonal]
[autumn] Best harvested after first frost
[berry] Look for bright red, plump hips
[morning] Collect in dry weather
[box-end]

[box-start:recipe]
**Ingredients:**
[berry] Fresh rose hips - 2 cups
[water] Water - 4 cups
[honey] Raw honey - 1 cup
[herb] Fresh ginger - 1 inch piece (optional)
[spice] Cinnamon stick - 1 (optional)
[box-end]

[box-start:preparation]
1. [wash] Rinse rose hips thoroughly
2. [chop] Roughly chop to break open
3. [water] Bring water to boil
4. [herb] Add rose hips and simmer 15 minutes
5. [strain] Strain through fine mesh
6. [honey] Stir in honey while warm
7. [store] Keep refrigerated up to 3 months
[box-end]

[box-start:healing]
[medicine] Extremely high in vitamin C
[safe] Gentle for all ages
[winter] Perfect for cold and flu season
[immune] Supports natural immunity
[box-end]

[box-start:info]
[traditional] Used by Indigenous peoples for centuries
[wild] Found throughout temperate regions
[sustainable] Harvesting doesn't harm the plant
[box-end]
```

---

## Troubleshooting

### Common Issues

#### Icons Not Displaying
- **Check spelling** - Icons are case-sensitive: use `[herb]` not `[Herb]`
- **Verify icon exists** - Refer to the icon list above
- **Check brackets** - Must be square brackets `[icon]` not parentheses or other brackets

#### Box Sections Not Working
- **Verify tags match** - Every `[box-start]` must have a matching `[box-end]`
- **Check style names** - Use exact style names: `[box-start:warning]` not `[box-start:warn]`
- **Line breaks matter** - Put box tags on their own lines when possible

#### Content Not Formatting Correctly
- **Test incrementally** - Add icons and boxes gradually to identify issues
- **Check for typos** - Extra characters can break formatting
- **Review examples** - Compare your content to working examples above

### Testing Your Content
1. **Preview in app** - Always test your content in the actual app
2. **Check all devices** - Verify appearance on different screen sizes
3. **Read aloud** - Ensure content flows naturally with icons
4. **Get feedback** - Have others review your enhanced content

### Style Guidelines
- **Be consistent** - Use the same style approach throughout your content
- **Stay relevant** - Choose icons that truly relate to your content
- **Consider context** - Warning boxes for safety, recipe boxes for preparations
- **Keep it readable** - Don't sacrifice clarity for visual appeal

---

## Quick Reference

### Most Common Icons
- Plants: `[herb]` `[flower]` `[tree]` `[leaf]` `[root]`
- Safety: `[safe]` `[caution]` `[danger]` `[toxic]`
- Time: `[morning]` `[evening]` `[spring]` `[summer]` `[harvest]`
- Health: `[healing]` `[medicine]` `[tea]` `[oil]` `[fresh]`
- Location: `[forest]` `[meadow]` `[garden]` `[wild]` `[mountain]`

### Most Common Box Styles
- `[box-start:warning]` - For safety information
- `[box-start:recipe]` - For ingredients and preparations
- `[box-start:info]` - For educational content
- `[box-start:healing]` - For medicinal properties
- `[box-start:seasonal]` - For timing and harvesting
- `[box-start:magical]` - For spiritual/magical content

### Content Checklist
- [ ] Content is clear and informative
- [ ] Icons enhance rather than distract
- [ ] Box sections highlight important information
- [ ] All box tags are properly matched
- [ ] Icon keywords are spelled correctly
- [ ] Content has been tested in the app
- [ ] Style is consistent throughout
- [ ] Information is accurate and safe

---

**Remember:** The goal is to create engaging, informative content that helps users connect with botanical wisdom. Use these tools to enhance your message, not replace good writing!
