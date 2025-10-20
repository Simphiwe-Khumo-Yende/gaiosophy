# Season-Based Content Filtering

## Overview
The home screen now automatically filters content based on the current season configured in Firebase. This ensures users only see content relevant to the current season.

## How It Works

### 1. **Season Configuration**
- The current season is stored in `app_config/main` document
- Field: `current_season` (ID of the season, e.g., "fb08d580-0782-4c55-82ff-5c671f5759a6")
- This is watched in real-time by `appConfigStreamProvider`

### 2. **Content Filtering**
- Each content document has a `season_id` field that links it to a season
- The `RealTimeContentByTypeNotifier` filters content by matching `season_id` with `current_season`
- Query: `.where('status', isEqualTo: 'published').where('season_id', isEqualTo: currentSeasonId)`

### 3. **Automatic Updates**
- When admin changes `current_season` in Firebase Console:
  1. `appConfigStreamProvider` detects the change
  2. `RealTimeContentByTypeNotifier` listens to season changes
  3. Firestore query automatically re-runs with new season ID
  4. Home screen content updates in real-time
  5. User gets a notification about the season change

## Implementation Details

### Modified Files

1. **`lib/data/models/content.dart`**
   - Added `seasonId` field to `Content` model
   - Updated `fromFirestore` to parse `season_id` from Firestore

2. **`lib/data/repositories/firestore_content_repository.dart`**
   - Updated `parseContentFromData` to include `seasonId`

3. **`lib/application/providers/realtime_content_provider.dart`**
   - `RealTimeContentByTypeNotifier` now watches app config
   - Filters queries by `season_id` matching current season
   - Automatically refreshes when season changes

### Firestore Data Structure

**Content Document:**
```
content_plant_allies/{id}
├── title: "Bramble"
├── status: "published"
├── season_id: "fb08d580-0782-4c55-82ff-5c671f5759a6"
├── harvest_periods: [...]
├── linked_recipe_ids: [...]
└── ...
```

**App Config Document:**
```
app_config/main
├── current_season: "fb08d580-0782-4c55-82ff-5c671f5759a6"
├── current_season_name: "Autumn"
├── app_element: "water"
├── app_direction: "west"
└── ...
```

## Content Types Filtered

All three content types on the home screen are filtered by season:
1. **Seasonal Wisdom & Rituals** (`content_seasonal_wisdom`)
2. **Plant Allies** (`content_plant_allies`)
3. **Seasonal Remedies & Recipes** (`content_recipes`)

## User Experience

### When Season Changes:
1. 📱 **Notification**: User receives local notification: "🍂 New Season: Winter"
2. 🔄 **Content Update**: Home screen automatically refreshes
3. ✨ **New Content**: Only content tagged with the new season ID appears
4. 📝 **Subtitle Update**: "Green wisdom for the winter season"

### What's Hidden:
- Content with different `season_id` values
- Content with `status != 'published'`
- Content without a `season_id` (if season filtering is active)

## Admin Workflow

### To Change Season:
1. Go to Firebase Console → Firestore Database
2. Navigate to `app_config/main` document
3. Update:
   - `current_season`: New season ID
   - `current_season_name`: New season display name (e.g., "Winter")
   - `app_element`: Optional element update (e.g., "earth")
   - `app_direction`: Optional direction update (e.g., "north")
4. Save changes
5. App automatically updates within seconds

### Content Publishing for New Season:
1. Create/edit content document
2. Set `season_id` to the target season ID
3. Set `status` to `"published"`
4. Content appears when that season becomes active

## Filtering Logic

```dart
// Pseudocode
Query query = firestore
  .collection('content_plant_allies')
  .where('status', isEqualTo: 'published')
  .where('season_id', isEqualTo: currentSeasonFromAppConfig)
  .orderBy('updated_at', descending: true)
  .limit(50);
```

## Benefits

✅ **Real-time Updates**: No app restart needed
✅ **Seasonal Relevance**: Users only see current season content
✅ **Automatic Filtering**: Works across all content types
✅ **Admin Control**: Simple Firebase Console updates
✅ **User Notifications**: Season changes are announced
✅ **Performance**: Firestore indexes handle filtering efficiently

## Testing

### Test Season Filtering:
1. Run the app and note current home screen content
2. In Firebase Console, change `app_config/main/current_season` to a different season ID
3. Observe:
   - Notification appears
   - Home screen content updates
   - Only new season content displays

### Test No Season ID:
- Content without `season_id` won't appear when filtering is active
- Ensure all published content has appropriate `season_id`

## Firestore Indexes Required

For optimal performance, create composite indexes:

```
Collection: content_plant_allies
Fields: status (Ascending), season_id (Ascending), updated_at (Descending)

Collection: content_recipes
Fields: status (Ascending), season_id (Ascending), updated_at (Descending)

Collection: content_seasonal_wisdom
Fields: status (Ascending), season_id (Ascending), updated_at (Descending)
```

Firebase will prompt you to create these indexes automatically when the app first runs.

## Future Enhancements

- [ ] **Fallback**: Show all content if no season_id match
- [ ] **Multi-Season Content**: Support content tagged with multiple seasons
- [ ] **Transition Period**: Show both old and new season content during transition
- [ ] **Analytics**: Track season change engagement
- [ ] **Preview Mode**: Admin preview of content for upcoming seasons
