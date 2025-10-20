# Season Change Notifications

## Overview
The app now automatically notifies users when the season changes in the Gaiosophy platform. This feature monitors the `app_config/main` document in Firestore and sends a local notification when the `current_season_name` field updates.

## How It Works

### 1. **Real-time Monitoring**
- The `appConfigStreamProvider` watches the `app_config/main` document in Firestore
- When `current_season_name` changes, the stream emits a new `AppConfig` object
- The `seasonChangeMonitorProvider` watches for these changes

### 2. **Notification Trigger**
- Compares the new season name with the previously stored season
- If different, triggers a local notification with:
  - **Title**: "🍂 New Season: {Season Name}"
  - **Body**: "Explore new seasonal wisdom, rituals, and plant allies • {Element} • {Direction}"
  - **Icon**: App launcher icon
  - **Priority**: High (Android) / Alert (iOS)

### 3. **State Persistence**
- Stores the last seen season in `SharedPreferences`
- Prevents duplicate notifications on app restart
- Only shows notification when season actually changes

## Implementation Files

### Core Components
1. **`lib/data/models/app_config.dart`**
   - Freezed model for app configuration
   - Contains `currentSeasonName`, `appElement`, `appDirection`, etc.

2. **`lib/data/repositories/app_config_repository.dart`**
   - Fetches app config from Firestore
   - Provides stream for real-time updates

3. **`lib/application/providers/app_config_provider.dart`**
   - Provides app config to the app
   - `appConfigStreamProvider`: Real-time stream
   - `appConfigProvider`: Current config with defaults

4. **`lib/data/services/season_notification_service.dart`**
   - Manages local notifications for season changes
   - Checks for season updates and sends notifications
   - Stores last seen season in SharedPreferences

5. **`lib/application/providers/season_notification_provider.dart`**
   - Monitors season changes
   - Triggers notifications when season updates

### Integration
- **`lib/main.dart`**: Watches `seasonChangeMonitorProvider` in `GaiosophyApp`
- **`lib/application/providers/home_sections_provider.dart`**: Uses dynamic season name in UI

## User Experience

### First Launch
- No notification shown
- Stores current season silently

### Season Change
1. Admin updates `current_season_name` in Firebase Console
2. App receives real-time update via Firestore stream
3. User sees local notification immediately
4. Tapping notification opens the app
5. Home screen subtitle updates: "Green wisdom for the {season} season"

### Notification Example
```
🍂 New Season: Winter
Explore new seasonal wisdom, rituals, and plant allies • water • west
```

## Platform Support

### iOS
- ✅ Local notifications with alert, badge, and sound
- ✅ Requires notification permission (requested on first use)
- ✅ Works in foreground and background

### Android
- ✅ High-priority notifications with vibration
- ✅ Custom notification channel: "Season Changes"
- ✅ Works in foreground and background

### Web
- ❌ Not supported (web doesn't have local notifications)
- ℹ️ UI still updates with new season name

## Firebase Configuration

### Firestore Structure
```
app_config (collection)
  └── main (document)
      ├── current_season_name: "Autumn" (string)
      ├── current_season: "49d5986e-..." (string)
      ├── app_direction: "west" (string)
      ├── app_element: "water" (string)
      ├── app_season: "fb08d580-..." (string)
      ├── app_image: {...} (map)
      ├── app_version: "1.0.0" (string)
      ├── content_refresh_interval: 3600 (number)
      └── app_settings: {...} (map)
```

### Required Fields
- `current_season_name`: Display name (e.g., "Autumn", "Winter", "Spring", "Summer")
- `app_element`: Optional, shown in notification
- `app_direction`: Optional, shown in notification

## Testing

### Trigger a Notification
1. Run the app on iOS/Android device (not web)
2. Let it initialize (stores current season)
3. In Firebase Console, change `current_season_name` (e.g., "Autumn" → "Winter")
4. Notification appears within seconds

### Reset Test
To clear stored season and test again:
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.remove('last_season_name');
```

## Dependencies
- `flutter_local_notifications: ^17.2.1` - Local notifications
- `shared_preferences: ^2.2.3` - Season state persistence
- `cloud_firestore: ^6.0.1` - Real-time updates from Firebase

## Future Enhancements
- [ ] Custom notification sound per season
- [ ] Rich notification with season image
- [ ] Deep linking to seasonal content
- [ ] Notification settings in user preferences
- [ ] Multiple language support for notifications
