import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/realtime_content_provider.dart';
import '../../application/providers/network_connectivity_provider.dart';
import '../widgets/enhanced_html_renderer.dart';
import '../widgets/content_box_parser.dart';
import '../../data/models/content.dart';

/// Example of how to use real-time content in a screen
class RealTimeContentExampleScreen extends ConsumerStatefulWidget {
  const RealTimeContentExampleScreen({super.key});

  @override
  ConsumerState<RealTimeContentExampleScreen> createState() => _RealTimeContentExampleScreenState();
}

class _RealTimeContentExampleScreenState extends ConsumerState<RealTimeContentExampleScreen> {

  @override
  void initState() {
    super.initState();
    // Setup automatic refresh when network comes back online
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen(isOfflineProvider, (previous, next) {
        if (previous == true && next == false) {
          // Came back online, refresh content
          ref.read(realTimeContentByTypeProvider(ContentType.plant).notifier).refresh();
        }
      });
    });
  }

  void _refreshContent() {
    ref.read(realTimeContentByTypeProvider(ContentType.plant).notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(realTimeContentByTypeProvider(ContentType.plant));
    final isOffline = ref.watch(isOfflineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Plant Content'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshContent,
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline indicator
          if (isOffline)
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
                      'Offline - showing cached content',
                      style: TextStyle(color: Colors.orange[700], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          
          // Content area
          Expanded(
            child: _buildContent(contentState),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(RealTimeContentState contentState) {
    // Loading state
    if (contentState.isLoading && contentState.items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading real-time content...'),
          ],
        ),
      );
    }

    // Error state
    if (contentState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${contentState.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshContent,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (contentState.items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No content available'),
          ],
        ),
      );
    }

    // Content list
    return RefreshIndicator(
      onRefresh: () async => _refreshContent(),
      child: ListView.builder(
        itemCount: contentState.items.length,
        itemBuilder: (context, index) {
          final item = contentState.items[index];
          return _buildContentItem(item);
        },
      ),
    );
  }

  Widget _buildContentItem(Content content) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (content.updatedAt != null)
                  Text(
                    _formatUpdateTime(content.updatedAt!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
            if (content.summary != null) ...[
              const SizedBox(height: 8),
              Text(
                content.summary!,
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ],
            if (content.body != null) ...[
              const SizedBox(height: 16),
              // Use your enhanced HTML renderer for rich content
              ContentBoxParser.hasBoxTags(content.body!) 
                  ? BoxedContentText(content.body!)
                  : EnhancedHtmlRenderer(content: content.body!),
            ],
          ],
        ),
      ),
    );
  }

  String _formatUpdateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}