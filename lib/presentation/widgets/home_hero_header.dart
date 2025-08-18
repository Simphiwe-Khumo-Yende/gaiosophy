import 'package:flutter/material.dart';
import '../theme/typography.dart';

class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, // Reduced height since AppBar handles the top area
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/autumn.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.brown.shade200),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          // Removed the top positioned widget since AppBar handles navigation now
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Season: Autumn',
                  style: context.secondaryBodyMedium.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  'Seasonal Autumn\nDirection: West\nElement: Water',
                  style: context.primaryHeadlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
