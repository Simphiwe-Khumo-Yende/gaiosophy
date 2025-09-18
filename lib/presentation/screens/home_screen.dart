import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/home_sections_provider.dart';
import '../../data/services/disclaimer_service.dart';
import '../widgets/home_hero_header.dart';
import '../widgets/content_section_horizontal.dart';
import '../theme/typography.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sectionsAsync = ref.watch(homeSectionsProvider);
    final userAsync = ref.watch(firebaseAuthProvider);
    
    // Calculate opacity based on scroll offset
    double appBarOpacity = (_scrollOffset / 100).clamp(0.0, 1.0);
    
    // Calculate icon color based on scroll - light when transparent, dark when gradient appears
    Color iconColor = Color.lerp(
      const Color(0xFFFCF9F2), // Light color when transparent
      const Color(0xFF1A1612), // Dark color when gradient appears
      appBarOpacity,
    )!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: appBarOpacity),
                Colors.white.withValues(alpha: appBarOpacity * 0.8),
                Colors.transparent,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: iconColor,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: iconColor,
            ),
            onPressed: () {
              context.push('/search');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, userAsync),
      body: sectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load content\n' + e.toString(),
              style: TextStyle(color: const Color(0xFF1A1612)),
            ),
          ),
        ),
        data: (sections) => CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(child: HomeHeroHeader()),
            for (final s in sections)
              SliverToBoxAdapter(child: ContentSectionHorizontal(section: s)),
            const SliverPadding(padding: EdgeInsets.only(bottom: 48)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDrawer(BuildContext context, AsyncValue<User?> userAsync) {
    return Drawer(
      backgroundColor: const Color(0xFFFCF9F2),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF8B6B47).withValues(alpha: 0.1),
                  const Color(0xFF8B6B47).withValues(alpha: 0.2),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF8B6B47).withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person,
                    size: 35,
                    color: Color(0xFF8B6B47),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gaiosophy',
                  style: context.primaryTitleLarge.copyWith(
                    color: const Color(0xFF1A1612),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Botanical Wisdom',
                  style: context.secondaryBodySmall.copyWith(
                    color: const Color(0xFF1A1612).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.settings_outlined,
                    color: Color(0xFF8B6B47),
                  ),
                  title: Text(
                    'Settings',
                    style: context.secondaryBodyLarge.copyWith(
                      color: const Color(0xFF1A1612),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Color(0xFF8B6B47),
                  ),
                  title: Text(
                    'Logout',
                    style: context.secondaryBodyLarge.copyWith(
                      color: const Color(0xFF1A1612),
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error signing out: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          
          // User Info at Bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xFF8B6B47).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: userAsync.when(
              data: (user) => user != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.displayName ?? 'Botanical Explorer',
                          style: context.secondaryBodyMedium.copyWith(
                            color: const Color(0xFF1A1612),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email ?? 'No email',
                          style: context.secondaryBodySmall.copyWith(
                            color: const Color(0xFF1A1612).withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Not signed in',
                      style: context.secondaryBodyMedium.copyWith(
                        color: const Color(0xFF1A1612).withValues(alpha: 0.7),
                      ),
                    ),
              loading: () => const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) => Text(
                'Error loading user',
                style: context.secondaryBodySmall.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
