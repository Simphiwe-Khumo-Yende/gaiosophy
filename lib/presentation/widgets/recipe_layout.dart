import 'package:flutter/material.dart';
import '../../data/models/content.dart';
import '../theme/typography.dart';

class RecipeLayout extends StatefulWidget {
  const RecipeLayout({
    super.key,
    required this.content,
  });

  final Content content;

  @override
  State<RecipeLayout> createState() => _RecipeLayoutState();
}

class _RecipeLayoutState extends State<RecipeLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.content.title),
        backgroundColor: const Color(0xFF8B6B47),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFCF9F2),
      body: Column(
        children: [
          // Recipe metadata
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: _buildRecipeMetadata(),
          ),
          
          // Tab bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF8B6B47),
              unselectedLabelColor: const Color(0xFF666666),
              indicatorColor: const Color(0xFF8B6B47),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Ingredients'),
                Tab(text: 'Steps'),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildIngredientsTab(),
                _buildStepsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeMetadata() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMetadataItem(Icons.schedule, '30 min', 'Prep Time'),
        _buildMetadataItem(Icons.restaurant, '4', 'Servings'),
        _buildMetadataItem(Icons.local_fire_department, 'Medium', 'Difficulty'),
      ],
    );
  }

  Widget _buildMetadataItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF8B6B47).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF8B6B47),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.secondaryBodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1612),
          ),
        ),
        Text(
          label,
          style: context.secondaryBodySmall.copyWith(
            color: const Color(0xFF1A1612).withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            'About This Recipe',
            widget.content.summary?.isNotEmpty == true 
                ? widget.content.summary! 
                : 'A nourishing recipe inspired by traditional wisdom and seasonal ingredients.',
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Health Benefits',
            'This recipe combines ingredients known for their therapeutic properties and nutritional value.',
            Icons.favorite_outline,
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Seasonal Notes',
            'Best prepared during specific seasons when ingredients are at their peak freshness and potency.',
            Icons.eco,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: context.primaryTitleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1612),
            ),
          ),
          const SizedBox(height: 16),
          ..._buildIngredientsList(),
        ],
      ),
    );
  }

  Widget _buildStepsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preparation Steps',
            style: context.primaryTitleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1612),
            ),
          ),
          const SizedBox(height: 16),
          ..._buildStepsList(),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, String content, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B6B47).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: const Color(0xFF8B6B47),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: context.primaryTitleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1612),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: context.secondaryBodyMedium.copyWith(
                color: const Color(0xFF1A1612),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIngredientsList() {
    // Demo ingredients with icons - in real app, these would come from content data
    final ingredients = [
      {'name': 'Fresh elderberries', 'amount': '1 cups', 'notes': '', 'icon': Icons.circle},
      {'name': 'Cup raw local honey', 'amount': '1 cups', 'notes': '', 'icon': Icons.opacity},
      {'name': 'Cup raw apple cider vinegar', 'amount': '2/3 cups', 'notes': '', 'icon': Icons.local_drink},
      {'name': 'Thumb sized piece of grated ginger', 'amount': '', 'notes': '', 'icon': Icons.spa},
      {'name': 'Cup of rosehips', 'amount': '1 cup', 'notes': '', 'icon': Icons.local_florist},
      {'name': 'Small handful of pine needles', 'amount': '', 'notes': '', 'icon': Icons.park},
      {'name': 'Cloves or a few pinches of chopped wood aven root', 'amount': '3 cloves', 'notes': '', 'icon': Icons.grass},
    ];

    return ingredients.asMap().entries.map((entry) {
      final ingredient = entry.value;
      final name = ingredient['name'] as String;
      final amount = ingredient['amount'] as String;
      final icon = ingredient['icon'] as IconData;
      
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ingredient icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF8B6B47).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: const Color(0xFF8B6B47),
              ),
            ),
            const SizedBox(width: 16),
            
            // Ingredient details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: context.secondaryBodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1612),
                    ),
                  ),
                  if (amount.isNotEmpty)
                    Text(
                      amount,
                      style: context.secondaryBodySmall.copyWith(
                        color: const Color(0xFF8B6B47),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildStepsList() {
    // Demo steps matching the Figma design
    final steps = [
      'Remove elderberries from stems (stems contain cyanide). Discard stems thoroughly.',
      'Place elderberries in a clean glass jar, filling about 1/3 of the jar.',
      'Add seasonal spices if using.',
      'Pour equal parts honey and apple cider vinegar over elderberries until liquid is an inch from the top.',
      'Stir gently with a wooden spoon to remove air bubbles and distribute ingredients.',
      'Cover with tight-fitting lid and store in dark place for 2-4 weeks.',
      'Large elderberries daily, and strain through cheesecloth.',
      'Store in cool, dark place for 2-4 weeks.',
      'Once extraction period is complete, strain through cheesecloth, squeezing to extract all liquid. Transfer to a clean bottle and store in refrigerator for up to 1 year.',
    ];

    return [
      // Preparation header
      Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF8B6B47).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Preparation',
          style: context.primaryTitleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1612),
          ),
        ),
      ),
      
      // Steps list
      ...steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step number
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6B47),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: context.secondaryBodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Step text
              Expanded(
                child: Text(
                  step,
                  style: context.secondaryBodyMedium.copyWith(
                    color: const Color(0xFF1A1612),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      
      const SizedBox(height: 24),
      
      // Usage section
      Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF8B6B47).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Usage',
          style: context.primaryTitleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1612),
          ),
        ),
      ),
      
      // Usage instructions
      Text(
        'Take 1-2 tablespoons daily during cold and flu season as a preventative. For active illness, take 1 tablespoon every 2-3 hours (adults). May be diluted in warm water or tea.\n\nNot recommended for children under 1 year due to honey content. Reduce dosage proportionally for older children.',
        style: context.secondaryBodyMedium.copyWith(
          color: const Color(0xFF1A1612),
          height: 1.6,
        ),
      ),
    ];
  }
}
