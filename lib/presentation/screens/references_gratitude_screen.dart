import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/typography.dart';

class ReferencesGratitudeScreen extends StatelessWidget {
  const ReferencesGratitudeScreen({super.key});

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
          style: context.primaryTitleLarge.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
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
                      const Icon(
                        Icons.favorite,
                        color: Color(0xFF8B6B47),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Acknowledgments',
                          style: context.primaryTitleLarge.copyWith(
                            color: const Color(0xFF1A1612),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'This work is not mine alone. It arises from the generosity of many teachers, traditions, and voices who have shared their wisdom, and to whom I bow in gratitude.',
                    style: context.secondaryBodyMedium.copyWith(
                      color: const Color(0xFF1A1612),
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Teachers & Mentors
                  Text(
                    'Teachers & Mentors',
                    style: context.primaryTitleMedium.copyWith(
                      color: const Color(0xFF8B6B47),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildGratitudeItem(
                    context,
                    title: 'The Earth herself',
                    description: 'First and foremost, I give thanks to the living Earth, to the soil, waters, winds, stones, plants, and trees who continue to be my greatest teachers. Every step of this work is only possible through Her endless generosity and guidance.',
                  ),
                  
                  _buildGratitudeItem(
                    context,
                    title: 'My first teacher',
                    description: 'My mother, who raised me in an environment of energy work and intuitive connection, laying the foundations of all I do.',
                  ),
                  
                  _buildGratitudeItem(
                    context,
                    title: 'Irish mentor',
                    description: 'Niamh Criostail (The Heart of Ritual), who guided me to the Celtic Wheel of the Year, and helped me to re-member the ways of my ancestors, decolonise my spiritual practice, and bring my focus back to working with native plants and sustainable ceremony.',
                  ),
                  
                  _buildGratitudeItem(
                    context,
                    title: 'Beloved mentors in Mexico',
                    description: 'Xixi, Wambli, Edgar, and Don Eusebio, who welcomed me into their traditions.',
                  ),
                  
                  _buildGratitudeItem(
                    context,
                    title: 'Damanhur',
                    description: 'Teachings received through my studies at Damanhur in Italy, where I studied Alchemy.',
                  ),
                  
                  _buildGratitudeItem(
                    context,
                    title: 'Gene Keys',
                    description: 'Special thanks to Richard Rudd, whose profound teachings have guided me immensely in both my life and my work.',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Books Section
                  Text(
                    'Books That Have Informed and Inspired Me',
                    style: context.primaryTitleMedium.copyWith(
                      color: const Color(0xFF8B6B47),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ..._buildBooksList(context),
                  
                  const SizedBox(height: 24),
                  
                  // Online Resources Section
                  Text(
                    'Online Resources',
                    style: context.primaryTitleMedium.copyWith(
                      color: const Color(0xFF8B6B47),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Forager Chef
                  GestureDetector(
                    onTap: () => _launchUrl('https://foragerchef.com/?utm_source=chatgpt.com'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B6B47).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.link,
                            color: Color(0xFF8B6B47),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Forager Chef',
                                  style: context.secondaryBodyMedium.copyWith(
                                    color: const Color(0xFF8B6B47),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'foragerchef.com',
                                  style: context.secondaryBodySmall.copyWith(
                                    color: const Color(0xFF8B6B47).withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // The Order of Bards, Ovates & Druids
                  GestureDetector(
                    onTap: () => _launchUrl('https://druidry.org/?utm_source=chatgpt.com'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B6B47).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.link,
                            color: Color(0xFF8B6B47),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'The Order of Bards, Ovates & Druids',
                                  style: context.secondaryBodyMedium.copyWith(
                                    color: const Color(0xFF8B6B47),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'druidry.org',
                                  style: context.secondaryBodySmall.copyWith(
                                    color: const Color(0xFF8B6B47).withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // If launching fails, show a snackbar or dialog
      debugPrint('Could not launch $url');
    }
  }
  
  Widget _buildGratitudeItem(BuildContext context, {
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.secondaryBodyMedium.copyWith(
              color: const Color(0xFF8B6B47),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: context.secondaryBodyMedium.copyWith(
              color: const Color(0xFF1A1612),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  
  List<Widget> _buildBooksList(BuildContext context) {
    final books = [
      'Evolutionary Herbalism: Science, Spirituality, and Medicine from the Heart of Nature — Sajah Popham',
      'Earth Wisdom — Glennie Kindred',
      'The Sacred Yew: Rediscovering the Ancient Tree of Life — Allen Meredith',
      'Tree Wisdom — Jacqueline Memory Paterson',
      'You Can Heal Your Life — Louise Hay',
      'The Generosity of Plants: Shared Wisdom from the Community of Herb Lovers — Rosemary Gladstar',
      'A Modern Herbal — M. Grieve',
      '100 Organic Skincare Recipes: Make Your Own Fresh and Fabulous Organic Beauty — Jessica Ress',
      'Braiding Sweetgrass — Robin Wall Kimmerer',
      'Foraged and Grown — Tara Lanich-LaBrie',
    ];
    
    return books.map((book) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Color(0xFF8B6B47))),
          Expanded(
            child: Text(
              book,
              style: context.secondaryBodyMedium.copyWith(
                color: const Color(0xFF1A1612),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }
}