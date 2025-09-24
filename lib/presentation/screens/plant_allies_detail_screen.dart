import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/content.dart' as content_model;
import '../widgets/firebase_storage_image.dart';
import '../theme/app_theme.dart';
import 'content_block_detail_screen.dart';
import 'plant_overview_screen.dart';
import 'plant_folklore_screen.dart';
import 'plant_harvesting_screen.dart';
import 'folk_medicine_screen.dart';
import 'magic_rituals_screen.dart';

class PlantAlliesDetailScreen extends ConsumerStatefulWidget {
  final content_model.Content content;

  const PlantAlliesDetailScreen({
    super.key,
    required this.content,
  });

  @override
  ConsumerState<PlantAlliesDetailScreen> createState() => _PlantAlliesDetailScreenState();
}

class _PlantAlliesDetailScreenState extends ConsumerState<PlantAlliesDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Image Section
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: widget.content.featuredImageId != null
                    ? FirebaseStorageImage(
                        imageId: widget.content.featuredImageId!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.eco,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
              ),
              // Gradient overlay
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Content Section
          Container(
            color: const Color(0xFFFCF9F2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamically build menu items from content blocks, sorted by order
                ...widget.content.contentBlocks
                    .where((block) {
                      
                      return block.order < 2;
                    }) // Show first 2 blocks
                    .map((block) => _buildContentBlockItem(block))
                    .toList(),
                
                // Folk Medicine section as 3rd option
                ...widget.content.contentBlocks
                    .where((block) => block.type == 'folk_medicine')
                    .map((block) => _buildFolkMedicineSection(block))
                    .toList(),
                
                // Remaining content blocks after folk medicine
                ...widget.content.contentBlocks
                    .where((block) {
                      
                      return block.order >= 2 && block.type != 'folk_medicine';
                    })
                    .map((block) => _buildContentBlockItem(block))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: AppTheme.plantProfileDividerColor,
                  width: 1,
                ),
              )
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          title,
          style: AppTheme.plantProfileHeadingStyle,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: AppTheme.plantProfileSubheadingStyle,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
                            color: const Color(0xFF5A4E3C).withValues(alpha: 0.6),
        ),
        onTap: onTap,
      ),
    );
  }
  
  Widget _buildContentBlockItem(content_model.ContentBlock block) {
    // Create simple menu items for all content blocks
    return _buildMenuItem(
      title: block.data.title ?? 'Untitled',
      subtitle: block.data.subtitle ?? '',
      onTap: () {
        // Route to specialized screens based on content block type or title
        Widget destinationScreen;
        
        String blockType = block.type.toLowerCase();
        String blockTitle = (block.data.title ?? '').toLowerCase();
        
        if (blockType == 'overview' || 
            blockType == 'plant_overview' || 
            blockTitle.contains('overview') ||
            blockTitle.contains('intro')) {
          destinationScreen = PlantOverviewScreen(
            contentBlock: block,
            parentTitle: widget.content.title,
          );
          
        } else if (blockType == 'folklore' ||
                   blockType == 'plant_folklore' ||
                   blockTitle.contains('folklore')) {
          destinationScreen = PlantFolkloreScreen(
            contentBlock: block,
            parentTitle: widget.content.title,
          );
          
        } else if (blockType == 'ritual' ||
                   blockType == 'magic_ritual' ||
                   blockTitle.contains('ritual') ||
                   blockTitle.contains('magic and ritual')) {
          destinationScreen = MagicRitualsScreen(
            contentBlock: block,
            parentTitle: widget.content.title,
          );
          
        } else if (blockType == 'spell' ||
                   blockType == 'spell_work' ||
                   blockTitle.contains('spell')) {
          // For now, use PlantFolkloreScreen for spell works until a dedicated screen is created
          destinationScreen = PlantFolkloreScreen(
            contentBlock: block,
            parentTitle: widget.content.title,
          );
          
        } else if (blockType == 'harvesting' || 
                   blockType == 'plant_harvesting' ||
                   blockType == 'preparation' ||
                   blockTitle.contains('harvesting') ||
                   blockTitle.contains('preparation') ||
                   blockTitle.contains('harvest')) {
          destinationScreen = PlantHarvestingScreen(
            contentBlock: block,
            parentTitle: widget.content.title,
          );
          
        } else if (blockType == 'folk_medicine') {
          destinationScreen = FolkMedicineScreen(
            contentBlock: block,
            parentTitle: widget.content.title,
          );
          
        } else {
          // Fallback to generic content block detail screen
          destinationScreen = ContentBlockDetailScreen(
            contentBlock: block,
            parentTitle: widget.content.title,
          );
          
        }
        
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) => destinationScreen),
        );
      },
      isLast: false,
    );
  }
  
  Widget _buildFolkMedicineSection(content_model.ContentBlock block) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.plantProfileDividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      block.data.title ?? 'Folk Medicine',
                      style: AppTheme.plantProfileHeadingStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap on plant parts below to explore their medicinal uses',
                      style: AppTheme.plantProfileSubheadingStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Show sub_blocks as plant circles if they exist
          if (block.data.subBlocks.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildPlantPartsGrid(block.data.subBlocks, block),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildPlantPartsGrid(List<content_model.SubBlock> subBlocks, content_model.ContentBlock parentBlock) {
    // Create a grid of plant parts (2 per row)
    List<Widget> rows = [];
    for (int i = 0; i < subBlocks.length; i += 2) {
      List<Widget> rowChildren = [];
      
      // Add first item in the row
      rowChildren.add(Expanded(
        child: _buildPlantPartCircle(subBlocks[i], parentBlock),
      ));
      
      // Add second item if it exists, otherwise add empty space
      if (i + 1 < subBlocks.length) {
        rowChildren.add(Expanded(
          child: _buildPlantPartCircle(subBlocks[i + 1], parentBlock),
        ));
      } else {
        rowChildren.add(const Expanded(child: SizedBox()));
      }
      
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      ));
      
      // Add spacing between rows
      if (i + 2 < subBlocks.length) {
        rows.add(const SizedBox(height: 16));
      }
    }
    
    return Column(children: rows);
  }
  
  Widget _buildPlantPartCircle(content_model.SubBlock subBlock, content_model.ContentBlock parentBlock) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Create a modified content block that focuses on this specific plant part
              final focusedBlock = content_model.ContentBlock(
                id: parentBlock.id,
                type: parentBlock.type,
                order: parentBlock.order,
                data: content_model.ContentBlockData(
                  title: parentBlock.data.title,
                  subtitle: parentBlock.data.subtitle,
                  content: parentBlock.data.content,
                  featuredImageId: parentBlock.data.featuredImageId,
                  subBlocks: [subBlock], // Only pass the specific sub-block
                ),
              );
              
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => FolkMedicineScreen(
                    contentBlock: focusedBlock,
                    parentTitle: widget.content.title,
                  ),
                ),
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: subBlock.imageUrl != null && subBlock.imageUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        subBlock.imageUrl!,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF5A4E3C).withValues(alpha: 0.1),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFF5A4E3C),
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          
                          
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF5A4E3C).withValues(alpha: 0.1),
                            ),
                            child: Icon(
                              _getPlantPartIcon(subBlock.plantPartName),
                              size: 40,
                              color: const Color(0xFF5A4E3C),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF5A4E3C).withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        _getPlantPartIcon(subBlock.plantPartName),
                        size: 40,
                        color: const Color(0xFF5A4E3C),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subBlock.plantPartName?.toUpperCase() ?? 'UNKNOWN',
            style: AppTheme.plantPartsHeaderStyle.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getPlantPartIcon(String? partName) {
    switch (partName?.toLowerCase()) {
      case 'berries':
      case 'fruit':
        return Icons.circle;
      case 'blossom':
      case 'flowers':
      case 'flower':
        return Icons.local_florist;
      case 'leaves':
      case 'leaf':
        return Icons.eco;
      case 'roots':
      case 'root':
        return Icons.grass;
      case 'bark':
        return Icons.park;
      case 'seeds':
      case 'seed':
        return Icons.grain;
      default:
        return Icons.nature;
    }
  }
}
