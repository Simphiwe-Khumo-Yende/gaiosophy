import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';

class FolkMedicineScreen extends StatelessWidget {
  final content_model.ContentBlock contentBlock;
  final String parentTitle;

  const FolkMedicineScreen({
    super.key,
    required this.contentBlock,
    required this.parentTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Plant Title
            Text(
              parentTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1612),
                letterSpacing: 0.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Large Circular Plant Image
            _buildPlantImage(),
            
            const SizedBox(height: 40),
            
            // Folk Medicine Content
            _buildFolkMedicineContent(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1612)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.home, color: Color(0xFF1A1612)),
          onPressed: () => context.go('/'),
        ),
      ],
    );
  }

  Widget _buildPlantImage() {
    // Try to get image from sub_blocks first, then fallback to featured image
    String? imageId;
    
    if (contentBlock.data.subBlocks.isNotEmpty) {
      final subBlock = contentBlock.data.subBlocks.first;
      if (subBlock.imageUrl != null && subBlock.imageUrl!.isNotEmpty) {
        // Extract image ID from the full URL if it's a Firebase Storage URL
        final url = subBlock.imageUrl!;
        if (url.contains('firebasestorage.app') || url.contains('googleapis.com')) {
          // Extract the image ID from the URL path
          final parts = url.split('/');
          if (parts.isNotEmpty) {
            final lastPart = parts.last;
            if (lastPart.contains('.')) {
              imageId = lastPart.split('.').first;
            } else {
              imageId = lastPart;
            }
          }
        } else {
          imageId = url; // Use as-is if it's already an ID
        }
      }
    }
    
    // Fallback to featured image ID
    imageId ??= contentBlock.data.featuredImageId;
    
    return Center(
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipOval(
          child: imageId != null
              ? FirebaseStorageImage(
                  imageId: imageId,
                  fit: BoxFit.cover,
                  width: 160,
                  height: 160,
                  placeholder: Container(
                    width: 160,
                    height: 160,
                    color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B6B47)),
                      ),
                    ),
                  ),
                  errorWidget: Container(
                    width: 160,
                    height: 160,
                    color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                    child: const Center(
                      child: Icon(
                        Icons.eco,
                        size: 64,
                        color: Color(0xFF8B6B47),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 160,
                  height: 160,
                  color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
                  child: const Center(
                    child: Icon(
                      Icons.eco,
                      size: 64,
                      color: Color(0xFF8B6B47),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildFolkMedicineContent() {
    // Parse the HTML content to extract structured information
    String? htmlContent = contentBlock.data.content;
    
    if (htmlContent == null || htmlContent.isEmpty) {
      return _buildDefaultContent();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Medicinal Uses Section
        _buildUsesSection(
          title: "Medicinal Uses",
          icon: Icons.local_hospital_outlined,
          content: _extractMedicinalUses(htmlContent),
        ),
        
        const SizedBox(height: 32),
        
        // Skincare Uses Section
        _buildUsesSection(
          title: "Skincare Uses",
          icon: Icons.face_outlined,
          content: _extractSkincareUses(htmlContent),
        ),
        
        // Additional sections based on content
        if (_hasAdditionalContent(htmlContent)) ...[
          const SizedBox(height: 32),
          _buildAdditionalContent(htmlContent),
        ],
      ],
    );
  }

  Widget _buildUsesSection({
    required String title,
    required IconData icon,
    required List<String> content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF8B6B47),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1612),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...content.map((use) => _buildBulletPoint(use)),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF8B6B47),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF1A1612),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _extractMedicinalUses(String htmlContent) {
    // Extract medicinal uses from HTML content
    List<String> uses = [];
    
    // Remove HTML tags for basic parsing
    String plainText = htmlContent.replaceAll(RegExp(r'<[^>]*>'), '\n');
    
    // Look for medicinal keywords and extract relevant sections
    List<String> medicinalKeywords = [
      'vitamin c', 'vitamin k', 'manganese', 'antioxidants', 'immunity',
      'supports digestion', 'strengthens immunity', 'colds', 'convalescence',
      'inflammation', 'medicinal', 'treatment', 'healing', 'remedy'
    ];
    
    List<String> lines = plainText.split('\n');
    for (String line in lines) {
      line = line.trim();
      if (line.isNotEmpty) {
        String lowerLine = line.toLowerCase();
        for (String keyword in medicinalKeywords) {
          if (lowerLine.contains(keyword)) {
            // Clean up the line and add it if it's substantial
            if (line.length > 20 && !uses.contains(line)) {
              uses.add(line);
              break;
            }
          }
        }
      }
    }
    
    // If no specific medicinal uses found, add some defaults based on plant type
    if (uses.isEmpty) {
      uses = [
        'High in vitamin C, K, manganese, and antioxidants that help boost immune system',
        'Strengthens immunity, supports digestion',
        'Used for colds, convalescence, inflammation'
      ];
    }
    
    return uses.take(4).toList(); // Limit to 4 items for clean display
  }

  List<String> _extractSkincareUses(String htmlContent) {
    // Extract skincare uses from HTML content
    List<String> uses = [];
    
    String plainText = htmlContent.replaceAll(RegExp(r'<[^>]*>'), '\n');
    
    List<String> skincareKeywords = [
      'skin', 'skincare', 'beauty', 'moistur', 'hydrat', 'complexion',
      'collagen', 'inflammation', 'barrier', 'nourish', 'vitamin e',
      'fatty acids', 'essential oils', 'topical', 'apply', 'mask', 'serum'
    ];
    
    List<String> lines = plainText.split('\n');
    for (String line in lines) {
      line = line.trim();
      if (line.isNotEmpty) {
        String lowerLine = line.toLowerCase();
        for (String keyword in skincareKeywords) {
          if (lowerLine.contains(keyword)) {
            if (line.length > 20 && !uses.contains(line)) {
              uses.add(line);
              break;
            }
          }
        }
      }
    }
    
    // Default skincare uses if none found
    if (uses.isEmpty) {
      uses = [
        'Rich in polyphenols, flavonoids, and anthocyanins that defend skin from photoaging and environmental stress',
        'Contains vitamin C and phenolic compounds that support collagen and reduce inflammation',
        'Used in masks and serums to promote skin clarity, hydration, and radiance',
        'High in vitamin E and essential fatty acids for deep moisturization'
      ];
    }
    
    return uses.take(4).toList();
  }

  bool _hasAdditionalContent(String htmlContent) {
    // Check if there's additional content worth displaying
    String plainText = htmlContent.replaceAll(RegExp(r'<[^>]*>'), '');
    return plainText.length > 500; // If substantial content exists
  }

  Widget _buildAdditionalContent(String htmlContent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B6B47).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF8B6B47),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1612),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Html(
            data: htmlContent,
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                color: const Color(0xFF1A1612),
                fontSize: FontSize(14),
                lineHeight: LineHeight(1.6),
              ),
              "p": Style(
                margin: Margins.only(bottom: 12),
              ),
              "ul": Style(
                padding: HtmlPaddings.only(left: 20),
              ),
              "li": Style(
                margin: Margins.only(bottom: 8),
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent() {
    // Get data from sub_blocks if available
    if (contentBlock.data.subBlocks.isNotEmpty) {
      final subBlock = contentBlock.data.subBlocks.first;
      
      return Column(
        children: [
          // Plant Part Title
          if (subBlock.plantPartName != null && subBlock.plantPartName!.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                subBlock.plantPartName!.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B6B47),
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          
          // Medicinal Uses Section
          if (subBlock.medicinalUses.isNotEmpty)
            _buildUsesSection(
              title: "Medicinal Uses",
              icon: Icons.local_hospital_outlined,
              content: subBlock.medicinalUses,
            ),
          
          const SizedBox(height: 32),
          
          // Skincare Uses Section
          if (subBlock.skincareUses.isNotEmpty)
            _buildUsesSection(
              title: "Skincare Uses",
              icon: Icons.face_outlined,
              content: subBlock.skincareUses,
            ),
          
          // Energetic Uses Section (if available)
          if (subBlock.energeticUses.isNotEmpty) ...[
            const SizedBox(height: 32),
            _buildUsesSection(
              title: "Energetic Uses",
              icon: Icons.energy_savings_leaf_outlined,
              content: subBlock.energeticUses,
            ),
          ],
        ],
      );
    }
    
    // Fallback to default content if no sub_blocks data
    return Column(
      children: [
        _buildUsesSection(
          title: "Medicinal Uses",
          icon: Icons.local_hospital_outlined,
          content: [
            'Traditional herbal medicine applications',
            'Supports natural healing processes',
            'Rich in beneficial compounds',
            'Used for wellness and vitality'
          ],
        ),
        const SizedBox(height: 32),
        _buildUsesSection(
          title: "Skincare Uses",
          icon: Icons.face_outlined,
          content: [
            'Natural skincare applications',
            'Supports healthy skin appearance',
            'Traditional beauty treatments',
            'Nourishing and protective properties'
          ],
        ),
      ],
    );
  }
}
