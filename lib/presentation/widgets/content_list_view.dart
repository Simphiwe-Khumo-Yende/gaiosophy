import 'package:flutter/material.dart';
import '../../application/providers/content_list_provider.dart';

class ContentListView extends StatelessWidget {
  const ContentListView({super.key, required this.state, required this.onLoadMore});
  final PaginatedContentState state;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final items = state.items;
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.pixels > n.metrics.maxScrollExtent - 200 && state.hasMore && !state.isLoading) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        itemCount: items.length + (state.isLoading ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          if (i >= items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final c = items[i];
          return ListTile(
            title: Text(c.title),
            subtitle: Text(c.summary ?? ''),
            onTap: () {},
          );
        },
      ),
    );
  }
}
