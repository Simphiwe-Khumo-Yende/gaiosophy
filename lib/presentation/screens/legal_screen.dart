import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../theme/typography.dart';
import '../../data/services/disclaimer_service.dart';

class LegalScreen extends ConsumerWidget {
  const LegalScreen({super.key});

  static const String _disclaimerText = '''
The content in this app is for educational and informational purposes only. It is not medical advice and should never replace the care of a qualified healthcare professional.

Foraging, plant preparation, and consumption always carry risks. You are solely responsible for your own safety and well-being. Always be absolutely certain of a plant's identification before touching, preparing, or consuming it. Many plants have poisonous lookalikes, and misuse can cause serious harm.

Some plants may interact with prescription medications in unexpected or dangerous ways. Others may not be suitable for people with certain medical conditions, for pregnant or breastfeeding women, or for children. Always consult a qualified professional before using herbs if you have a medical condition, take medication, or are responsible for the health of others in your care.

The creators of this app accept no responsibility or liability for any illness, injury, or adverse effects resulting from the use of the information provided. Always do your own research, consult professionals, and take full responsibility for your choices.

By using this app, you acknowledge that you are solely responsible for your health, safety, and actions.''';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2), // App's cream background
      appBar: AppBar(
        title: Text(
          'Legal & Disclaimer',
          style: context.primaryFont(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5A4E3C),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5A4E3C)),
          onPressed: () => context.pop(),
        ),
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Elegant Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCF9F2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Legal icon in circular container
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4513).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF8B4513).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.gavel,
                        size: 40,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Legal Information',
                      style: context.primaryFont(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5A4E3C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Important disclaimers, terms, and information about Gaiosophy',
                      style: context.secondaryFont(
                        fontSize: 14,
                        color: const Color(0xFF8B7355),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Disclaimer Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCF9F2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B4513).withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF8B4513).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            size: 24,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Important Disclaimer',
                          style: context.primaryFont(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5A4E3C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _disclaimerText,
                      style: context.secondaryFont(
                        fontSize: 14,
                        height: 1.6,
                        color: const Color(0xFF5A4E3C),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // About Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCF9F2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B4513).withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF8B4513).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 24,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'About Gaiosophy',
                          style: context.primaryFont(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5A4E3C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Gaiosophy is an educational platform dedicated to sharing knowledge about plants, foraging, and traditional wisdom. Our mission is to connect people with nature while promoting safe and responsible practices.',
                      style: context.secondaryFont(
                        fontSize: 14,
                        height: 1.6,
                        color: const Color(0xFF5A4E3C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Version: 1.0.0',
                      style: context.secondaryFont(
                        fontSize: 12,
                        color: const Color(0xFF8B7355),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Developer Actions (for testing)
              if (const bool.fromEnvironment('dart.vm.product') == false) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCF9F2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B4513).withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF8B4513).withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.developer_mode,
                              size: 24,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Developer Options',
                            style: context.primaryFont(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF5A4E3C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'These options are only available in debug builds.',
                        style: context.secondaryFont(
                          fontSize: 12,
                          color: const Color(0xFF8B7355),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final service = ref.read(disclaimerServiceProvider);
                              await service.resetDisclaimerAcceptance(user.uid);
                              ref.invalidate(disclaimerAcceptedProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Disclaimer acceptance reset. App will show disclaimer on next launch.'),
                                    backgroundColor: const Color(0xFF8B4513),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B4513),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.refresh),
                          label: Text(
                            'Reset Disclaimer Acceptance',
                            style: context.secondaryFont(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
