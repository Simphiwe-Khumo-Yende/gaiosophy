import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/search_provider.dart';
import '../theme/typography.dart';
import '../../data/models/content.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String initialQuery;

  SearchScreen({super.key, this.initialQuery = ''});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // If an initial query was provided (via route query params), set it
    // and ensure the provider is updated; then auto-focus the field.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialQuery.trim().isNotEmpty) {
        _searchController.text = widget.initialQuery;
        // Update provider so search results refresh
        ref.read(searchQueryProvider.notifier).state = widget.initialQuery;
      }
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(searchQueryProvider.notifier).state = value;
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final isSearchActive = ref.watch(isSearchActiveProvider);
    final currentQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1612)),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          style: context.secondaryBodyLarge.copyWith(
            color: const Color(0xFF1A1612),
          ),
          decoration: InputDecoration(
            hintText: 'Search recipes, plants, seasonal wisdom...',
            hintStyle: context.secondaryBodyLarge.copyWith(
              color: const Color(0xFF1A1612).withValues(alpha: 0.6),
            ),
            border: InputBorder.none,
            suffixIcon: currentQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFF1A1612)),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSearchActive) ...[
              // Search suggestions when not searching
              Text(
                'Search Suggestions',
                style: context.primaryTitleMedium.copyWith(
                  color: const Color(0xFF1A1612),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSuggestionChip('Herbal tea'),
                  _buildSuggestionChip('Autumn remedies'),
                  _buildSuggestionChip('Elderberry'),
                  _buildSuggestionChip('Hair care'),
                  _buildSuggestionChip('Digestive'),
                  _buildSuggestionChip('Winter preparations'),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Recent Searches',
                style: context.primaryTitleMedium.copyWith(
                  color: const Color(0xFF1A1612),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              // You could implement recent searches storage here
              Text(
                'No recent searches',
                style: context.secondaryBodyMedium.copyWith(
                  color: const Color(0xFF5A5A5A),
                ),
              ),
            ] else ...[
              // Search results
              searchResults.when(
                loading: () => const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stackTrace) => Expanded(
                  child: Center(
                    child: Text(
                      'Error searching: $error',
                      style: context.secondaryBodyMedium.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                data: (results) => Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${results.length} result${results.length != 1 ? 's' : ''} for \"$currentQuery\"',
                        style: context.secondaryBodyMedium.copyWith(
                          color: const Color(0xFF5A5A5A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (results.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: const Color(0xFF5A5A5A).withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No results found',
                                  style: context.primaryTitleMedium.copyWith(
                                    color: const Color(0xFF5A5A5A),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try different keywords or check spelling',
                                  style: context.secondaryBodyMedium.copyWith(
                                    color: const Color(0xFF5A5A5A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final content = results[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildSearchResultCard(content),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion) {
    return InkWell(
      onTap: () {
        _searchController.text = suggestion;
        _onSearchChanged(suggestion);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE9E2D5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          suggestion,
          style: context.secondaryBodyMedium.copyWith(
            color: const Color(0xFF1A1612),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultCard(Content content) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
          child: InkWell(
        onTap: () {
          // Navigate to the content detail screen using the same pattern as home screen cards
          context.push('/content/${content.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Content type indicator
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getTypeColor(content.type),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // Content info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: context.primaryTitleMedium.copyWith(
                        color: const Color(0xFF1A1612),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getTypeLabel(content.type),
                      style: context.secondaryBodySmall.copyWith(
                        color: const Color(0xFF5A5A5A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (content.summary != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        content.summary!,
                        style: context.secondaryBodyMedium.copyWith(
                          color: const Color(0xFF5A5A5A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow icon
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF5A5A5A),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(ContentType type) {
    return switch (type) {
      ContentType.recipe => const Color(0xFF8B6B47),
      ContentType.plant => const Color(0xFF6B8B47),
      ContentType.seasonal => const Color(0xFF478B6B),
    };
  }

  String _getTypeLabel(ContentType type) {
    return switch (type) {
      ContentType.recipe => 'Recipe',
      ContentType.plant => 'Plant Ally',
      ContentType.seasonal => 'Seasonal Wisdom',
    };
  }
}
