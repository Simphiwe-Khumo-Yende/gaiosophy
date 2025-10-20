# Firestore Index Setup for Season Filtering

## ⚠️ Required Indexes

The season filtering feature requires composite indexes in Firestore. Firebase will show you error messages with direct links to create these indexes when they're needed.

## Error Message

```
Failed to load content
[cloud_firestore/failed-precondition] The query requires an index.
You can create it here: https://console.firebase.google.com/...
```

## Required Indexes

You need to create composite indexes for each content collection:

### 1. **content_plant_allies**
```
Collection ID: content_plant_allies
Fields indexed:
  - status (Ascending)
  - season_id (Ascending)  
  - updated_at (Descending)

Query scope: Collection
```

**Direct Link:** Click the link in the error message, or go to:
`Firebase Console → Firestore Database → Indexes → Create Index`

### 2. **content_recipes**
```
Collection ID: content_recipes
Fields indexed:
  - status (Ascending)
  - season_id (Ascending)
  - updated_at (Descending)

Query scope: Collection
```

### 3. **content_seasonal_wisdom**
```
Collection ID: content_seasonal_wisdom
Fields indexed:
  - status (Ascending)
  - season_id (Ascending)
  - updated_at (Descending)

Query scope: Collection
```

## How to Create Indexes

### Option 1: Click the Error Link (Easiest)
1. When you see the error in your app, it includes a direct link
2. Click the link - it will open Firebase Console with pre-filled index settings
3. Click **"Create Index"**
4. Wait 2-5 minutes for the index to build

### Option 2: Manual Creation
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Firestore Database** → **Indexes** tab
4. Click **"Create Index"**
5. Fill in:
   - **Collection ID**: `content_plant_allies`
   - Add fields:
     - `status` - Ascending
     - `season_id` - Ascending
     - `updated_at` - Descending
   - **Query scope**: Collection
6. Click **Create**
7. Repeat for `content_recipes` and `content_seasonal_wisdom`

## Index Build Time

- **Small database** (< 100 documents): ~30 seconds
- **Medium database** (100-1000 documents): 2-5 minutes
- **Large database** (1000+ documents): 5-15 minutes

You'll receive an email when indexes are ready.

## Fallback Behavior

The app now includes fallback logic:

1. **First attempt**: Query with season filter
   ```
   .where('status', isEqualTo: 'published')
   .where('season_id', isEqualTo: currentSeasonId)
   .orderBy('updated_at', descending: true)
   ```

2. **If index missing**: Falls back to query without season filter
   ```
   .where('status', isEqualTo: 'published')
   .orderBy('updated_at', descending: true)
   ```

3. **Result**: Content loads (all seasons), but not filtered by current season until indexes are created

## Verify Indexes Are Working

Once indexes are built:

1. **Restart your app**
2. **Check home screen** - should show content
3. **Change season** in `app_config/main`
4. **Verify filtering** - content should update to new season

If you see content from all seasons, indexes are still building or need to be created.

## Index Status Check

To check if your indexes are ready:

1. Go to Firebase Console → Firestore Database → Indexes
2. Look for the three indexes you created
3. Status should be:
   - ✅ **Enabled** (green) - Ready to use
   - 🔄 **Building** (yellow) - Wait a few more minutes
   - ❌ **Error** (red) - Click to see details and fix

## Common Issues

### "Index already exists"
- Someone already created it
- Check the Indexes tab to verify it's enabled

### "Index build failed"
- Usually due to field type mismatches
- Ensure `status` and `season_id` are strings
- Ensure `updated_at` is a timestamp

### "Query still not working after index creation"
- Wait a few more minutes
- Try hot restart: `r` in terminal
- Check index status is "Enabled" not "Building"

## Future Optimization

Once indexes are created, the fallback logic is no longer needed. The app will automatically use the indexed queries for fast, filtered results.

## Need Help?

If indexes fail to build or you encounter errors:
1. Check field types in your Firestore documents
2. Verify collection names match exactly
3. Ensure you have sufficient permissions in Firebase Console
4. Contact Firebase support if persistent issues occur
