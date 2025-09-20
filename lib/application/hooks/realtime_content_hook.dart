import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/realtime_content_provider.dart';
import '../providers/network_connectivity_provider.dart';
import '../../data/models/content.dart';

/// Hook for using real-time content with automatic refresh and offline handling
class RealTimeContentHook {
  static Widget builder({
    required WidgetRef ref,
    ContentType? contentType,
    required Widget Function(List<Content> content, bool isLoading, bool isConnected) builder,
    Widget Function(Object error)? errorBuilder,
    Duration? refreshInterval,
  }) {
    // Watch real-time content based on type
    final contentState = contentType != null 
        ? ref.watch(realTimeContentByTypeProvider(contentType))
        : ref.watch(realTimeContentProvider);
    
    // Watch network connectivity
    final isOffline = ref.watch(isOfflineProvider);
    final isOnline = !isOffline;
    
    // Auto-refresh when coming back online
    ref.listen(isOfflineProvider, (previous, next) {
      if (previous == true && next == false) {
        // Just came back online, refresh content
        _refreshContent(ref, contentType);
      }
    });

    // Handle error state
    if (contentState.error != null && errorBuilder != null) {
      return errorBuilder(contentState.error!);
    }

    return builder(
      contentState.items,
      contentState.isLoading,
      contentState.isConnected && isOnline,
    );
  }

  static void _refreshContent(WidgetRef ref, ContentType? contentType) {
    if (contentType != null) {
      ref.read(realTimeContentByTypeProvider(contentType).notifier).refresh();
    } else {
      ref.read(realTimeContentProvider.notifier).refresh();
    }
  }

  /// Force refresh content manually
  static void forceRefresh(WidgetRef ref, {ContentType? contentType}) {
    _refreshContent(ref, contentType);
  }

  /// Get content synchronously from current state
  static List<Content> getContent(WidgetRef ref, {ContentType? contentType}) {
    final state = contentType != null 
        ? ref.read(realTimeContentByTypeProvider(contentType))
        : ref.read(realTimeContentProvider);
    return state.items;
  }

  /// Check if content is currently loading
  static bool isLoading(WidgetRef ref, {ContentType? contentType}) {
    final state = contentType != null 
        ? ref.read(realTimeContentByTypeProvider(contentType))
        : ref.read(realTimeContentProvider);
    return state.isLoading;
  }
}

/// Widget that automatically handles real-time content updates
class RealTimeContentBuilder extends ConsumerWidget {
  const RealTimeContentBuilder({
    super.key,
    required this.builder,
    this.contentType,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.showOfflineIndicator = true,
  });

  final Widget Function(List<Content> content, bool isConnected) builder;
  final ContentType? contentType;
  final Widget Function(Object error)? errorBuilder;
  final Widget? loadingBuilder;
  final Widget? emptyBuilder;
  final bool showOfflineIndicator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RealTimeContentHook.builder(
      ref: ref,
      contentType: contentType,
      builder: (content, isLoading, isConnected) {
        // Show loading state
        if (isLoading && content.isEmpty) {
          return loadingBuilder ?? const Center(child: CircularProgressIndicator());
        }

        // Show empty state
        if (content.isEmpty && !isLoading) {
          return emptyBuilder ?? const Center(
            child: Text('No content available'),
          );
        }

        // Build main content with optional offline indicator
        return Column(
          children: [
            if (showOfflineIndicator && !isConnected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.orange.withOpacity(0.2),
                child: Row(
                  children: [
                    Icon(Icons.cloud_off, size: 16, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Showing cached content - Updates will sync when online',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(child: builder(content, isConnected)),
          ],
        );
      },
      errorBuilder: errorBuilder,
    );
  }
}

/// Mixin for adding real-time content capabilities to existing widgets
mixin RealTimeContentMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  
  /// Watch real-time content with automatic refresh handling
  RealTimeContentState watchRealTimeContent({ContentType? contentType}) {
    return contentType != null 
        ? ref.watch(realTimeContentByTypeProvider(contentType))
        : ref.watch(realTimeContentProvider);
  }

  /// Listen to network changes and refresh content when online
  void setupNetworkListener({ContentType? contentType}) {
    ref.listen(isOfflineProvider, (previous, next) {
      if (previous == true && next == false) {
        refreshRealTimeContent(contentType: contentType);
      }
    });
  }

  /// Manually refresh real-time content
  void refreshRealTimeContent({ContentType? contentType}) {
    RealTimeContentHook.forceRefresh(ref, contentType: contentType);
  }

  /// Get current content items
  List<Content> getCurrentContent({ContentType? contentType}) {
    return RealTimeContentHook.getContent(ref, contentType: contentType);
  }
}