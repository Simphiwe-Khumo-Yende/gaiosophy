import 'package:flutter/material.dart';
import '../../data/models/content.dart';
import '../theme/typography.dart';

class SeasonalWisdomLayout extends StatelessWidget {
  const SeasonalWisdomLayout({
    super.key,
    required this.content,
  });

  final Content content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content.title),
        backgroundColor: _getSeasonColors().first,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFFCF9F2),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _getSeasonColors(),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Season icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getSeasonIcon(),
                    size: 60,
                    color: _getSeasonColors().first,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Content
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        style: context.primaryTitleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1612),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (content.summary?.isNotEmpty == true)
                        Text(
                          content.summary!,
                          style: context.secondaryBodyMedium.copyWith(
                            color: const Color(0xFF1A1612).withOpacity(0.8),
                            height: 1.6,
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (content.body?.isNotEmpty == true)
                        Text(
                          content.body!,
                          style: context.secondaryBodyMedium.copyWith(
                            color: const Color(0xFF1A1612).withOpacity(0.8),
                            height: 1.6,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getSeasonColors() {
    switch (content.season?.toLowerCase()) {
      case 'spring':
        return [
          const Color(0xFF9CCC65),
          const Color(0xFF66BB6A),
        ];
      case 'summer':
        return [
          const Color(0xFFFFB74D),
          const Color(0xFFFF8A65),
        ];
      case 'autumn':
      case 'fall':
        return [
          const Color(0xFFD32F2F),
          const Color(0xFFFF5722),
        ];
      case 'winter':
        return [
          const Color(0xFF5C6BC0),
          const Color(0xFF3F51B5),
        ];
      default:
        return [
          const Color(0xFF8B6B47),
          const Color(0xFF6D4C41),
        ];
    }
  }

  IconData _getSeasonIcon() {
    switch (content.season?.toLowerCase()) {
      case 'spring':
        return Icons.eco;
      case 'summer':
        return Icons.wb_sunny;
      case 'autumn':
      case 'fall':
        return Icons.park;
      case 'winter':
        return Icons.ac_unit;
      default:
        return Icons.schedule;
    }
  }
}
