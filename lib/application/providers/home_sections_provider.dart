import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/content.dart';
import 'network_connectivity_provider.dart';
import 'realtime_content_provider.dart';
import 'app_config_provider.dart';
import '../../data/services/offline_storage_service.dart';

class HomeSection {
  HomeSection({required this.title, this.subtitle, required this.items});
  final String title;
  final String? subtitle;
  final List<Content> items;
}

class HomeSectionsState {
  const HomeSectionsState({
    required this.sections,
    required this.isInitialLoading,
    required this.isRefreshing,
    required this.isOffline,
    required this.hasRealtimeConnection,
    required this.hasData,
    this.error,
  });

  final List<HomeSection> sections;
  final bool isInitialLoading;
  final bool isRefreshing;
  final Object? error;
  final bool isOffline;
  final bool hasRealtimeConnection;
  final bool hasData;
}

// Provider for saved content list (reuse from offline_storage_service)
final homeSavedContentProvider = FutureProvider<List<Content>>((ref) async {
  final service = ref.watch(offlineStorageServiceProvider);
  final content = await service.getAllSavedContent();
  return content;
});

final homeSectionsProvider = Provider<HomeSectionsState>((ref) {
  final isOffline = ref.watch(isOfflineProvider);
  final appConfig = ref.watch(appConfigProvider);
  // When offline, show only saved content
  if (isOffline) {
    final savedContentAsync = ref.watch(homeSavedContentProvider);
    
    return savedContentAsync.when(
      data: (savedContent) {
        if (savedContent.isEmpty) {
          return HomeSectionsState(
            sections: const [],
            isInitialLoading: false,
            isRefreshing: false,
            error: null,
            isOffline: true,
            hasRealtimeConnection: false,
            hasData: false,
          );
        }
        
        // Group saved content by type
        final seasonalItems = savedContent.where((c) => c.type == ContentType.seasonal).toList();
        final plantItems = savedContent.where((c) => c.type == ContentType.plant).toList();
        final recipeItems = savedContent.where((c) => c.type == ContentType.recipe).toList();
        
        
        final sections = <HomeSection>[
          if (seasonalItems.isNotEmpty)
            HomeSection(
              title: 'Saved Seasonal Content',
              subtitle: 'Your bookmarked seasonal wisdom',
              items: seasonalItems,
            ),
          if (plantItems.isNotEmpty)
            HomeSection(
              title: 'Saved Plant Allies',
              subtitle: 'Your bookmarked plant guides',
              items: plantItems,
            ),
          if (recipeItems.isNotEmpty)
            HomeSection(
              title: 'Saved Recipes & Crafts',
              subtitle: 'Your bookmarked recipes',
              items: recipeItems,
            ),
        ];
        
        
        
        return HomeSectionsState(
          sections: sections,
          isInitialLoading: false,
          isRefreshing: false,
          error: null,
          isOffline: true,
          hasRealtimeConnection: false,
          hasData: sections.isNotEmpty,
        );
      },
      loading: () {
        return HomeSectionsState(
          sections: const [],
          isInitialLoading: true,
          isRefreshing: false,
          error: null,
          isOffline: true,
          hasRealtimeConnection: false,
          hasData: false,
        );
      },
      error: (error, _) {
        return HomeSectionsState(
          sections: const [],
          isInitialLoading: false,
          isRefreshing: false,
          error: error,
          isOffline: true,
          hasRealtimeConnection: false,
          hasData: false,
        );
      },
    );
  }
  
  // When online, show regular content
  final seasonalState = ref.watch(realTimeContentByTypeProvider(ContentType.seasonal));
  final plantState = ref.watch(realTimeContentByTypeProvider(ContentType.plant));
  final recipeState = ref.watch(realTimeContentByTypeProvider(ContentType.recipe));

  List<Content> limitItems(List<Content> items) => items.take(12).toList(growable: false);

  final sections = <HomeSection>[
    HomeSection(
      title: 'Seasonal Wisdom & Rituals',
      subtitle: 'Attune, give back, remember',
      items: limitItems(seasonalState.items),
    ),
    HomeSection(
      title: 'Plant Allies',
      subtitle: 'Green wisdom for the ${appConfig.currentSeasonName.toLowerCase()} season',
      items: limitItems(plantState.items),
    ),
    HomeSection(
      title: 'Seasonal Remedies, Recipes and Crafts',
      subtitle: 'Co-create with the land',
      items: limitItems(recipeState.items),
    ),
  ];

  final states = [seasonalState, plantState, recipeState];
  final hasItems = sections.any((section) => section.items.isNotEmpty);
  final anyLoading = states.any((state) => state.isLoading);
  final Object? error = states.map((state) => state.error).firstWhere((error) => error != null, orElse: () => null);
  final hasRealtimeConnection = states.any((state) => state.isConnected);

  if (error != null && !hasItems) {
    return HomeSectionsState(
      sections: const [],
      isInitialLoading: false,
      isRefreshing: false,
      error: error,
      isOffline: false,
      hasRealtimeConnection: hasRealtimeConnection,
      hasData: false,
    );
  }

  if (!hasItems && anyLoading) {
    return HomeSectionsState(
      sections: const [],
      isInitialLoading: true,
      isRefreshing: false,
      error: null,
      isOffline: false,
      hasRealtimeConnection: hasRealtimeConnection,
      hasData: false,
    );
  }

  return HomeSectionsState(
    sections: sections,
    isInitialLoading: !hasItems && anyLoading,
    isRefreshing: hasItems && anyLoading,
    error: error,
    isOffline: false,
    hasRealtimeConnection: hasRealtimeConnection,
    hasData: hasItems,
  );
});
