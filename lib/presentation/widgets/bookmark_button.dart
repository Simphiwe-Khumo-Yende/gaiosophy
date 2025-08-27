import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/content.dart';
import '../../data/services/offline_storage_service.dart';

class BookmarkButton extends ConsumerWidget {
  final Content content;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onBookmarkChanged;

  const BookmarkButton({
    super.key,
    required this.content,
    this.iconColor,
    this.iconSize,
    this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarkedContentProvider);
    final offlineService = ref.watch(offlineStorageServiceProvider);

    return bookmarkedIds.when(
      data: (ids) {
        final isBookmarked = ids.contains(content.id);
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Offline indicator
            FutureBuilder<bool>(
              future: offlineService.isContentAvailableOffline(content.id),
              builder: (context, snapshot) {
                final isAvailableOffline = snapshot.data ?? false;
                if (isAvailableOffline) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.offline_pin,
                      size: 16,
                      color: Colors.green.shade600,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            
            // Bookmark button
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                color: isBookmarked 
                    ? Colors.amber.shade700 
                    : (iconColor ?? Colors.grey.shade600),
                size: iconSize ?? 24,
              ),
              onPressed: () => _toggleBookmark(ref, content, isBookmarked),
              tooltip: isBookmarked ? 'Remove bookmark' : 'Save for offline',
            ),
          ],
        );
      },
      loading: () => IconButton(
        icon: Icon(
          Icons.bookmark_outline,
          color: iconColor ?? Colors.grey.shade600,
          size: iconSize ?? 24,
        ),
        onPressed: null, // Disabled while loading
      ),
      error: (_, __) => IconButton(
        icon: Icon(
          Icons.bookmark_outline,
          color: iconColor ?? Colors.grey.shade600,
          size: iconSize ?? 24,
        ),
        onPressed: () => _toggleBookmark(ref, content, false),
      ),
    );
  }

  Future<void> _toggleBookmark(WidgetRef ref, Content content, bool isCurrentlyBookmarked) async {
    final offlineService = ref.read(offlineStorageServiceProvider);
    
    try {
      final newBookmarkStatus = await offlineService.toggleBookmark(content.id, content);
      
      // Show feedback to user
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text(
              newBookmarkStatus 
                  ? 'Content saved for offline access' 
                  : 'Content removed from saved items',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: newBookmarkStatus 
                ? Colors.green.shade600 
                : Colors.grey.shade600,
          ),
        );
      }
      
      // Callback for additional actions
      onBookmarkChanged?.call();
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('Error ${isCurrentlyBookmarked ? 'removing' : 'saving'} content: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }
}

// A simpler version for use in cards or lists
class BookmarkIconIndicator extends ConsumerWidget {
  final String contentId;
  final double size;
  final Color? color;

  const BookmarkIconIndicator({
    super.key,
    required this.contentId,
    this.size = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarkedContentProvider);
    final offlineService = ref.watch(offlineStorageServiceProvider);

    return bookmarkedIds.when(
      data: (ids) {
        final isBookmarked = ids.contains(contentId);
        if (!isBookmarked) return const SizedBox.shrink();

        return FutureBuilder<bool>(
          future: offlineService.isContentAvailableOffline(contentId),
          builder: (context, snapshot) {
            final isAvailableOffline = snapshot.data ?? false;
            
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bookmark,
                  size: size,
                  color: Colors.amber.shade700,
                ),
                if (isAvailableOffline) ...[
                  const SizedBox(width: 2),
                  Icon(
                    Icons.offline_pin,
                    size: size * 0.8,
                    color: Colors.green.shade600,
                  ),
                ],
              ],
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
