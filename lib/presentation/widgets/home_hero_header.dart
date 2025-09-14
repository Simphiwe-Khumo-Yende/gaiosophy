import 'package:flutter/material.dart';
import '../theme/typography.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({super.key});

  Future<Map<String, dynamic>?> _fetchHeroData() async {
    print('Fetching app_config/main from Firestore...');
    final doc = await FirebaseFirestore.instance.collection('app_config').doc('main').get();
    print('Document exists: \\${doc.exists}');
    if (!doc.exists) return null;
    final data = doc.data();
    print('Raw data: \\${data}');
    if (data == null) return null;
    final heroData = {
      'imageUrl': data['app_image']?['url'],
      'seasonName': data['current_season'],
      'direction': data['app_direction'],
      'element': data['app_element'],
    };
    print('Parsed heroData: \\${heroData}');
    return heroData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchHeroData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox(
            height: 280,
            child: Center(child: Text('No hero data found')),
          );
        }
        final hero = snapshot.data!;
        return SizedBox(
          height: 280,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              hero['imageUrl'] != null
                  ? Image.network(
                      hero['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.brown.shade200),
                    )
                  : Container(color: Colors.brown.shade200),

              // Gradient overlay for better text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),

              // Centered text content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (hero['seasonName'] != null)
                      Text(
                        'Season: ${hero['seasonName']}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFFCF9F2),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    if (hero['direction'] != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Direction: ${hero['direction']}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFFCF9F2),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                    if (hero['element'] != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Element: ${hero['element']}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFFCF9F2),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}