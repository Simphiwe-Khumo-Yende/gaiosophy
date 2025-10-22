import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({super.key});

  Future<Map<String, dynamic>?> _fetchHeroData() async {
    
    final doc = await FirebaseFirestore.instance.collection('app_config').doc('main').get();
    
    if (!doc.exists) return null;
    final data = doc.data();
    
    if (data == null) return null;
    // Resolve image: prefer canonical storage download URL from image id when possible
    String? resolvedUrl = data['app_image']?['url'] as String?;
    final imageId = data['app_image']?['id'];
    if (imageId != null) {
      // try common extensions
      for (final ext in ['png', 'jpg', 'jpeg']) {
        final candidate = 'media/uploads/$imageId.$ext';
        try {
          final url = await FirebaseStorage.instance.ref().child(candidate).getDownloadURL();
          resolvedUrl = url;
          
          break;
        } catch (e) {
          // ignore and try next ext
        }
      }
    }

    final heroData = {
      'imageUrl': resolvedUrl,
      'seasonName': data['current_season_name'],
      'direction': data['app_direction'],
      'element': data['app_element'],
    };
    
    return heroData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchHeroData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 500,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox(
            height: 500,
            child: Center(child: Text('No hero data found')),
          );
        }
        final hero = snapshot.data!;
        return SizedBox(
          height: 500,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              hero['imageUrl'] != null
                  ? Image.network(
                      hero['imageUrl'] as String,
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
            ],
          ),
        );
      },
    );
  }
}