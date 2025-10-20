import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/content.dart';
import 'network_connectivity_provider.dart';
import 'realtime_content_provider.dart';
import 'app_config_provider.dart';

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

final homeSectionsProvider = Provider<HomeSectionsState>((ref) {
  final seasonalState = ref.watch(realTimeContentByTypeProvider(ContentType.seasonal));
  final plantState = ref.watch(realTimeContentByTypeProvider(ContentType.plant));
  final recipeState = ref.watch(realTimeContentByTypeProvider(ContentType.recipe));
  final isOffline = ref.watch(isOfflineProvider);
  final appConfig = ref.watch(appConfigProvider);

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
      title: 'Seasonal Remedies & Recipes and Crafts',
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
      isOffline: isOffline,
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
      isOffline: isOffline,
      hasRealtimeConnection: hasRealtimeConnection,
      hasData: false,
    );
  }

  return HomeSectionsState(
    sections: sections,
    isInitialLoading: !hasItems && anyLoading,
    isRefreshing: hasItems && anyLoading,
    error: error,
    isOffline: isOffline,
    hasRealtimeConnection: hasRealtimeConnection,
    hasData: hasItems,
  );
});
