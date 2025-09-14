import 'package:flutter/material.dart';
import '../theme/typography.dart';

class HomeHeroHeader extends StatelessWidget {
  const HomeHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, // Fixed height
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/autumn.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.brown.shade200),
          ),
          
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
                Text(
                  'Season: Autumn',
                  style: context.primaryHeadlineMedium.copyWith(
                    color: const Color(0xFFFCF9F2),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Direction: West',
                  style: context.primaryHeadlineMedium.copyWith(
                    color: const Color(0xFFFCF9F2),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Element: Water',
                  style: context.primaryHeadlineMedium.copyWith(
                    color: const Color(0xFFFCF9F2),
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