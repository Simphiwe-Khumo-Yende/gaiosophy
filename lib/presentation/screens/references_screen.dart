import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/typography.dart';

class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'References & Gratitude',
          style: context.primaryFont(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFCF9F2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 28,
                        color: const Color(0xFF8B6B47),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Gratitude',
                          style: context.primaryFont(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1612),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This work is not mine alone. It arises from the generosity of many teachers, traditions, and voices who have shared their wisdom, and to whom I bow in gratitude.',
                    style: context.secondaryFont(
                      fontSize: 16,
                      color: const Color(0xFF1A1612),
                      height: 1.6,
                    ).copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Teachers & Mentors Section
            _buildSectionHeader(context, 'Teachers & Mentors'),
            const SizedBox(height: 16),
            
            _buildGratitudeItem(
              context,
              icon: Icons.eco,
              title: 'The Earth herself',
              description: 'First and foremost, I give thanks to the living Earth, to the soil, waters, winds, stones, plants, and trees who continue to be my greatest teachers. Every step of this work is only possible through Her endless generosity and guidance.',
            ),
            
            _buildGratitudeItem(
              context,
              icon: Icons.family_restroom,
              title: 'My first teacher',
              description: 'My mother, who raised me in an environment of energy work and intuitive connection, laying the foundations of all I do.',
            ),
            
            _buildGratitudeItem(
              context,
              icon: Icons.auto_stories,
              title: 'Irish mentor',
              description: 'Niamh Criostail (The Heart of Ritual), who guided me to the Celtic Wheel of the Year, and helped me to re-member the ways of my ancestors, decolonise my spiritual practice, and bring my focus back to working with native plants and sustainable ceremony.',
            ),
            
            _buildGratitudeItem(
              context,
              icon: Icons.public,
              title: 'Beloved mentors in Mexico',
              description: 'Xixi, Wambli, Edgar, and Don Eusebio, who welcomed me into their traditions.',
            ),
            
            _buildGratitudeItem(
              context,
              icon: Icons.school,
              title: 'Damanhur',
              description: 'Teachings received through my studies at Damanhur in Italy, where I studied Alchemy.',
            ),
            
            _buildGratitudeItem(
              context,
              icon: Icons.vpn_key,
              title: 'Gene Keys',
              description: 'Special thanks to Richard Rudd, whose profound teachings have guided me immensely in both my life and my work.',
            ),
            
            const SizedBox(height: 32),
            
            // Books Section
            _buildSectionHeader(context, 'Books That Have Informed and Inspired Me'),
            const SizedBox(height: 16),
            
            _buildBookItem(context, 'Evolutionary Herbalism: Science, Spirituality, and Medicine from the Heart of Nature', 'Sajah Popham'),
            _buildBookItem(context, 'Earth Wisdom', 'Glennie Kindred'),
            _buildBookItem(context, 'The Sacred Yew: Rediscovering the Ancient Tree of Life', 'Allen Meredith'),
            _buildBookItem(context, 'Tree Wisdom', 'Jacqueline Memory Paterson'),
            _buildBookItem(context, 'You Can Heal Your Life', 'Louise Hay'),
            _buildBookItem(context, 'The Generosity of Plants: Shared Wisdom from the Community of Herb Lovers', 'Rosemary Gladstar'),
            _buildBookItem(context, 'A Modern Herbal', 'M. Grieve'),
            _buildBookItem(context, '100 Organic Skincare Recipes: Make Your Own Fresh and Fabulous Organic Beauty', 'Jessica Ress'),
            _buildBookItem(context, 'Braiding Sweetgrass', 'Robin Wall Kimmerer'),
            _buildBookItem(context, 'Foraged and Grown', 'Tara Lanich-LaBrie'),
            
            const SizedBox(height: 32),
            
            // Online Resources Section
            _buildSectionHeader(context, 'Online Resources'),
            const SizedBox(height: 16),
            
            _buildResourceItem(context, 'Forager Chef'),
            _buildResourceItem(context, 'The Order of Bards, Ovates & Druids'),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: context.primaryFont(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A1612),
      ),
    );
  }

  Widget _buildGratitudeItem(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B6B47).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6B47).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF8B6B47),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: context.primaryFont(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1612),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: context.secondaryFont(
              fontSize: 14,
              color: const Color(0xFF1A1612),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, String title, String author) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF8B6B47).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.book,
            size: 20,
            color: const Color(0xFF8B6B47),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.secondaryFont(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1612),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  author,
                  style: context.secondaryFont(
                    fontSize: 13,
                    color: const Color(0xFF8B6B47),
                  ).copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(BuildContext context, String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF8B6B47).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.language,
            size: 20,
            color: const Color(0xFF8B6B47),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: context.secondaryFont(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1612),
              ),
            ),
          ),
        ],
      ),
    );
  }
}