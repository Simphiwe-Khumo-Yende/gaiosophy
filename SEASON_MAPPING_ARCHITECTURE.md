# Season Filtering Architecture - Global Control via app_config/main

## Overview
The `app_config/main` document acts as the **global controller** for season-based content filtering throughout the entire app. It references a season document from the `seasons` collection, creating a single source of truth.

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    FIREBASE FIRESTORE                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────────────┐                             │
│  │   app_config/main              │  ◄── GLOBAL CONTROLLER      │
│  ├────────────────────────────────┤                             │
│  │ current_season:                │                             │
│  │   "fb08d580-0782-4c55-82ff..." │ ─────┐                      │
│  │                                │      │                      │
│  │ current_season_name: "Autumn"  │      │ REFERENCES           │
│  │ app_element: "water"           │      │                      │
│  │ app_direction: "west"          │      │                      │
│  └────────────────────────────────┘      │                      │
│                                           │                      │
│  ┌────────────────────────────────┐      │                      │
│  │   seasons collection           │ ◄────┘                      │
│  ├────────────────────────────────┤                             │
│  │                                │                             │
│  │ fb08d580-0782-4c55-82ff... ◄───┼── MATCHED!                 │
│  │   ├─ name: "Autumn"            │                             │
│  │   ├─ status: "published"       │                             │
│  │   ├─ start_date: "2024-09-21"  │                             │
│  │   ├─ end_date: "2024-12-20"    │                             │
│  │   └─ id: "fb08d580-..."        │                             │
│  │                                │                             │
│  │ 49d5986e-0d98-47f2-8b21... ◄───┼── Not current season       │
│  │   ├─ name: "Winter"            │                             │
│  │   └─ status: "published"       │                             │
│  │                                │                             │
│  └────────────────────────────────┘                             │
│                                                                  │
│  ┌────────────────────────────────┐                             │
│  │ content_plant_allies           │                             │
│  ├────────────────────────────────┤                             │
│  │                                │                             │
│  │ bramble                        │                             │
│  │   ├─ season_id:                │                             │
│  │   │   "fb08d580-0782-..."  ◄───┼── ✅ MATCHES current_season │
│  │   ├─ status: "published"       │                             │
│  │   └─ title: "Bramble"          │     SHOWS ON HOME           │
│  │                                │                             │
│  │ rosemary                       │                             │
│  │   ├─ season_id:                │                             │
│  │   │   "49d5986e-0d98-..."  ◄───┼── ❌ Different season       │
│  │   ├─ status: "published"       │                             │
│  │   └─ title: "Rosemary"         │     HIDDEN FROM HOME        │
│  │                                │                             │
│  └────────────────────────────────┘                             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

                            ↓

┌─────────────────────────────────────────────────────────────────┐
│                       FLUTTER APP                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────────────┐                             │
│  │  appConfigProvider             │                             │
│  │  Watches: app_config/main      │                             │
│  └───────────────┬────────────────┘                             │
│                  │                                               │
│                  │ Provides currentSeason ID                    │
│                  │                                               │
│  ┌───────────────▼────────────────┐                             │
│  │ RealTimeContentByTypeNotifier  │                             │
│  │ Filters content by:            │                             │
│  │  - status = "published"        │                             │
│  │  - season_id = currentSeason   │                             │
│  └───────────────┬────────────────┘                             │
│                  │                                               │
│                  │ Filtered content                             │
│                  │                                               │
│  ┌───────────────▼────────────────┐                             │
│  │      Home Screen               │                             │
│  │  ┌──────────────────────────┐  │                             │
│  │  │ Plant Allies (Autumn)    │  │                             │
│  │  │  • Bramble               │  │                             │
│  │  │  • Elder                 │  │                             │
│  │  └──────────────────────────┘  │                             │
│  │  ┌──────────────────────────┐  │                             │
│  │  │ Seasonal Wisdom (Autumn) │  │                             │
│  │  └──────────────────────────┘  │                             │
│  │  ┌──────────────────────────┐  │                             │
│  │  │ Recipes (Autumn)         │  │                             │
│  │  └──────────────────────────┘  │                             │
│  └────────────────────────────────┘                             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Field Mapping

### app_config/main (Global Controller)
```javascript
{
  "current_season": "fb08d580-0782-4c55-82ff-5c671f5759a6",  // ← Season ID (PRIMARY KEY)
  "current_season_name": "Autumn",                           // ← Display name (synced manually)
  "app_element": "water",
  "app_direction": "west",
  "app_season": "fb08d580-0782-4c55-82ff-5c671f5759a6"      // ← Same as current_season
}
```

### seasons/{season_id}
```javascript
{
  "id": "fb08d580-0782-4c55-82ff-5c671f5759a6",             // ← MATCHES current_season
  "name": "Autumn",                                         // ← Source of truth for name
  "status": "published",
  "start_date": "2024-09-21",
  "end_date": "2024-12-20",
  "order_index": 3,
  "meta_title": "Autumn Plant Allies - Gaiosophy",
  "meta_description": "Discover the powerful plant allies of autumn..."
}
```

### content_plant_allies/{content_id}
```javascript
{
  "id": "2b966b66-cf66-4ceb-a288-69d636ab0227",
  "title": "Bramble",
  "season_id": "fb08d580-0782-4c55-82ff-5c671f5759a6",      // ← MUST MATCH current_season
  "status": "published",                                     // ← MUST BE "published"
  "harvest_periods": [
    { "season": "summer", "timing": "late" },
    { "season": "autumn", "timing": "mid" }
  ],
  "linked_recipe_ids": [...]
}
```

## Global Control Flow

### 1. Admin Changes Season
```
Firebase Console
  └─► app_config/main
      └─► Update: current_season = "49d5986e-0d98-47f2-8b21-6c574ec156f0"
      └─► Update: current_season_name = "Winter"
```

### 2. App Detects Change
```
appConfigStreamProvider (Real-time listener)
  └─► Emits new AppConfig with currentSeason = "49d5986e-..."
```

### 3. Content Providers React
```
RealTimeContentByTypeNotifier
  └─► Season change listener fires
  └─► Cancels old Firestore subscription
  └─► Creates new query:
      firestore
        .collection('content_plant_allies')
        .where('status', isEqualTo: 'published')
        .where('season_id', isEqualTo: '49d5986e-...')  ← NEW season ID
        .orderBy('updated_at', descending: true)
```

### 4. UI Updates
```
Home Screen
  └─► Shows notification: "🍂 New Season: Winter"
  └─► Updates subtitle: "Green wisdom for the winter season"
  └─► Displays only winter content
```

## Key Principles

### ✅ Single Source of Truth
- `app_config/main.current_season` is the **ONLY** controller
- All content filtering derives from this one field
- Change once, filters everywhere

### ✅ Loose Coupling
- `seasons` collection holds season metadata
- `app_config/main` references season by ID
- Content documents reference season by ID
- No direct dependencies between content and season documents

### ✅ Consistency
- `current_season_name` in app_config should match `name` in seasons doc
- Admin should update both when changing seasons
- App uses `current_season` (ID) for filtering, `current_season_name` for display

## Admin Workflow

### To Change Active Season:

1. **Find Target Season**
   ```
   Firebase Console → seasons collection
   Find season doc (e.g., Winter: 49d5986e-0d98-47f2-8b21-6c574ec156f0)
   Copy the document ID
   ```

2. **Update Global Controller**
   ```
   Firebase Console → app_config → main
   
   Update fields:
   - current_season: "49d5986e-0d98-47f2-8b21-6c574ec156f0"
   - current_season_name: "Winter" (match seasons/{id}/name)
   - app_element: "earth" (optional)
   - app_direction: "north" (optional)
   ```

3. **Save**
   ```
   App automatically updates:
   ✓ Notification sent to users
   ✓ Home content filtered by new season
   ✓ Subtitle updated
   ```

### To Add Content for a Season:

1. **Get Season ID**
   ```
   Firebase Console → seasons collection
   Copy desired season's document ID
   ```

2. **Create/Edit Content**
   ```
   Firebase Console → content_plant_allies (or other content collection)
   
   Set fields:
   - season_id: "fb08d580-0782-4c55-82ff-5c671f5759a6"
   - status: "published"
   - title, body, etc.
   ```

3. **Publish**
   ```
   Content will appear when:
   ✓ status = "published"
   ✓ season_id matches app_config/main/current_season
   ```

## Implementation Code

### Reading Current Season
```dart
// In providers
final appConfig = ref.watch(appConfigProvider);
final currentSeasonId = appConfig.currentSeason; // "fb08d580-..."
final seasonName = appConfig.currentSeasonName;  // "Autumn"
```

### Filtering Content
```dart
// In RealTimeContentByTypeNotifier._buildQuery()
Query<Map<String, dynamic>> _buildQuery() {
  final collectionName = _collectionPath();
  Query<Map<String, dynamic>> query = _db
      .collection(collectionName)
      .where('status', isEqualTo: 'published');

  // Get current season ID from global controller
  final appConfig = _ref.read(appConfigProvider);
  final currentSeasonId = appConfig.currentSeason;

  // Filter by season_id
  if (currentSeasonId.isNotEmpty) {
    query = query.where('season_id', isEqualTo: currentSeasonId);
  }

  return query;
}
```

### Reacting to Season Changes
```dart
// In RealTimeContentByTypeNotifier constructor
RealTimeContentByTypeNotifier(...) {
  // Watch for season changes
  _ref.listen<String>(
    appConfigProvider.select((config) => config.currentSeason),
    (previous, next) {
      if (previous != null && previous != next) {
        refresh(); // Re-query with new season
      }
    },
  );
  
  _startListening();
}
```

## Benefits of This Architecture

✅ **Centralized Control**: One field controls all filtering
✅ **Real-time Updates**: Firestore streams propagate changes instantly
✅ **Scalable**: Easy to add more content types or seasons
✅ **Maintainable**: Clear data relationships
✅ **Flexible**: Seasons can have metadata without affecting filtering
✅ **Performance**: Firestore indexes handle filtering efficiently

## Validation Checklist

Before deploying season change:

- [ ] `current_season` ID exists in `seasons` collection
- [ ] `current_season_name` matches `seasons/{id}/name`
- [ ] Season document has `status: "published"`
- [ ] Content for new season has matching `season_id`
- [ ] Content has `status: "published"`
- [ ] Test app updates after changing season

## Troubleshooting

### Content Not Showing After Season Change

1. **Check app_config/main**
   - `current_season` has valid season ID
   - ID exists in seasons collection

2. **Check content document**
   - `season_id` matches `app_config/main/current_season`
   - `status` equals "published"

3. **Check Firestore indexes**
   - Composite index exists for collection
   - Fields: status, season_id, updated_at

### Notification Not Appearing

1. **Check SharedPreferences**
   - Last season stored correctly
   - Season actually changed

2. **Check platform**
   - iOS/Android only (not web)
   - Notification permissions granted
