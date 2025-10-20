import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_config.dart';

class AppConfigRepository {
  AppConfigRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Stream<AppConfig> watchAppConfig() {
    return _firestore
        .collection('app_config')
        .doc('main')
        .snapshots()
        .asyncMap((doc) async {
      if (!doc.exists || doc.data() == null) {
        return const AppConfig();
      }

      final data = doc.data()!;
      final currentSeasonId = data['current_season'] as String? ?? '';
      
      // Fetch the season name from the seasons collection
      String seasonName = 'Autumn'; // Default fallback
      if (currentSeasonId.isNotEmpty) {
        try {
          final seasonDoc = await _firestore
              .collection('seasons')
              .doc(currentSeasonId)
              .get();
          
          if (seasonDoc.exists && seasonDoc.data() != null) {
            seasonName = seasonDoc.data()!['name'] as String? ?? seasonName;
          }
        } catch (e) {
          // If fetching season name fails, use fallback
          print('Error fetching season name: $e');
        }
      }
      
      return AppConfig(
        currentSeasonName: seasonName, // From seasons collection
        currentSeason: currentSeasonId,
        appDirection: data['app_direction'] as String? ?? '',
        appElement: data['app_element'] as String? ?? '',
        appSeason: data['app_season'] as String? ?? '',
        appImageUrl: data['app_image']?['url'] as String?,
        appImageId: data['app_image']?['id'] as String?,
        appVersion: data['app_version'] as String? ?? '1.0.0',
        contentRefreshInterval: data['content_refresh_interval'] as int? ?? 3600,
        analyticsEnabled: data['app_settings']?['analytics_enabled'] as bool? ?? true,
        offlineModeEnabled: data['app_settings']?['offline_mode_enabled'] as bool? ?? true,
        pushNotificationsEnabled: data['app_settings']?['push_notifications_enabled'] as bool? ?? true,
        themeMode: data['app_settings']?['theme_mode'] as String? ?? 'auto',
      );
    });
  }

  Future<AppConfig> getAppConfig() async {
    final doc = await _firestore.collection('app_config').doc('main').get();
    
    if (!doc.exists || doc.data() == null) {
      return const AppConfig();
    }

    final data = doc.data()!;
    final currentSeasonId = data['current_season'] as String? ?? '';
    
    // Fetch the season name from the seasons collection
    String seasonName = 'Autumn'; // Default fallback
    if (currentSeasonId.isNotEmpty) {
      try {
        final seasonDoc = await _firestore
            .collection('seasons')
            .doc(currentSeasonId)
            .get();
        
        if (seasonDoc.exists && seasonDoc.data() != null) {
          seasonName = seasonDoc.data()!['name'] as String? ?? seasonName;
        }
      } catch (e) {
        // If fetching season name fails, use fallback
        print('Error fetching season name: $e');
      }
    }
    
    return AppConfig(
      currentSeasonName: seasonName, // From seasons collection
      currentSeason: currentSeasonId,
      appDirection: data['app_direction'] as String? ?? '',
      appElement: data['app_element'] as String? ?? '',
      appSeason: data['app_season'] as String? ?? '',
      appImageUrl: data['app_image']?['url'] as String?,
      appImageId: data['app_image']?['id'] as String?,
      appVersion: data['app_version'] as String? ?? '1.0.0',
      contentRefreshInterval: data['content_refresh_interval'] as int? ?? 3600,
      analyticsEnabled: data['app_settings']?['analytics_enabled'] as bool? ?? true,
      offlineModeEnabled: data['app_settings']?['offline_mode_enabled'] as bool? ?? true,
      pushNotificationsEnabled: data['app_settings']?['push_notifications_enabled'] as bool? ?? true,
      themeMode: data['app_settings']?['theme_mode'] as String? ?? 'auto',
    );
  }
}
