import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/typography.dart';
import '../../data/services/disclaimer_service.dart';

class DisclaimerScreen extends ConsumerStatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  ConsumerState<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends ConsumerState<DisclaimerScreen> {
  bool _hasReadDisclaimer = false;
  bool _isAccepting = false;

  static const String _disclaimerText = '''
The content in this app is for educational and informational purposes only. It is not medical advice and should never replace the care of a qualified healthcare professional.

Foraging, plant preparation, and consumption always carry risks. You are solely responsible for your own safety and well-being. Always be absolutely certain of a plant's identification before touching, preparing, or consuming it. Many plants have poisonous lookalikes, and misuse can cause serious harm.

Some plants may interact with prescription medications in unexpected or dangerous ways. Others may not be suitable for people with certain medical conditions, for pregnant or breastfeeding women, or for children. Always consult a qualified professional before using herbs if you have a medical condition, take medication, or are responsible for the health of others in your care.

The creators of this app accept no responsibility or liability for any illness, injury, or adverse effects resulting from the use of the information provided. Always do your own research, consult professionals, and take full responsibility for your choices.

By using this app, you acknowledge that you are solely responsible for your health, safety, and actions.''';

  Future<void> _acceptDisclaimer() async {
    if (!_hasReadDisclaimer) return;

    setState(() {
      _isAccepting = true;
    });

    try {
      final service = ref.read(disclaimerServiceProvider);
      await service.acceptDisclaimer();
      
      if (mounted) {
        // Refresh the disclaimer accepted provider
        ref.invalidate(disclaimerAcceptedProvider);
        // Navigate to the intended destination
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error accepting disclaimer. Please try again.'),
            backgroundColor: Color(0xFF8B4513),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAccepting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2), // App's cream background
      appBar: AppBar(
        title: Text(
          'Important Disclaimer',
          style: context.primaryFont(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5A4E3C),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Elegant Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    // Warning icon in circular container
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
                        Icons.warning_amber_rounded,
                        size: 40,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Please Read Carefully',
                      style: context.primaryFont(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5A4E3C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This disclaimer contains important safety information about plant identification and foraging practices',
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

              // Disclaimer Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
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
                  child: SingleChildScrollView(
                    child: Text(
                      _disclaimerText,
                      style: context.secondaryFont(
                        fontSize: 15,
                        height: 1.6,
                        color: const Color(0xFF5A4E3C),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Checkbox Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hasReadDisclaimer 
                        ? const Color(0xFF8B4513).withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: _hasReadDisclaimer,
                        onChanged: (value) {
                          setState(() {
                            _hasReadDisclaimer = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF8B4513),
                        checkColor: Colors.white,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'I have read and understand this disclaimer',
                        style: context.secondaryFont(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5A4E3C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Accept Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _hasReadDisclaimer && !_isAccepting ? _acceptDisclaimer : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: _hasReadDisclaimer 
                        ? const Color(0xFF8B4513)
                        : Colors.grey.shade300,
                    foregroundColor: _hasReadDisclaimer 
                        ? Colors.white 
                        : Colors.grey.shade500,
                    elevation: _hasReadDisclaimer ? 4 : 0,
                    shadowColor: const Color(0xFF8B4513).withOpacity(0.3),
                  ),
                  child: _isAccepting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'I Agree and Accept',
                          style: context.secondaryFont(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
