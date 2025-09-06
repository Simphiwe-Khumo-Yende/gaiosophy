import 'package:flutter/material.dart';

class ContentIconMapper {
  static const Map<String, IconData> iconMap = {
    // Plant & Nature Icons
    'tree': Icons.park,
    'flower': Icons.local_florist,
    'grass': Icons.grass,
    'leaf': Icons.eco,
    'herb': Icons.spa,
    'mushroom': Icons.agriculture,
    'vine': Icons.nature,
    'bush': Icons.forest,
    'fern': Icons.park_outlined,
    'moss': Icons.texture,
    
    // Plant Parts
    'root': Icons.account_tree,
    'stem': Icons.height,
    'branch': Icons.call_split,
    'bark': Icons.texture,
    'seed': Icons.scatter_plot,
    'fruit': Icons.apple,
    'berry': Icons.circle,
    'nut': Icons.egg,
    'pod': Icons.lens,
    'bulb': Icons.lightbulb_outline,
    
    // Seasons & Weather
    'spring': Icons.wb_sunny,
    'summer': Icons.wb_sunny,
    'autumn': Icons.ac_unit,
    'winter': Icons.ac_unit,
    'snowflake': Icons.ac_unit,
    'rain': Icons.water_drop,
    'sun': Icons.wb_sunny,
    'cloud': Icons.cloud,
    'wind': Icons.air,
    'frost': Icons.ac_unit,
    
    // Scientific & Educational
    'scientific': Icons.science,
    'botanical': Icons.biotech,
    'medicinal': Icons.local_pharmacy,
    'edible': Icons.restaurant,
    'toxic': Icons.dangerous,
    'rare': Icons.star,
    'common': Icons.check_circle,
    'endangered': Icons.warning,
    'protected': Icons.shield,
    'native': Icons.home,
    
    // Research & Tools
    'microscope': Icons.search,
    'magnify': Icons.zoom_in,
    'book': Icons.menu_book,
    'study': Icons.school,
    'research': Icons.assignment,
    'note': Icons.note,
    'bookmark': Icons.bookmark,
    'favorite': Icons.favorite,
    'share': Icons.share,
    'download': Icons.download,
    
    // Health & Safety
    'healing': Icons.healing,
    'medicine': Icons.medication,
    'vitamin': Icons.health_and_safety,
    'antioxidant': Icons.shield,
    'antibiotic': Icons.vaccines,
    'painkiller': Icons.local_hospital,
    'digestive': Icons.restaurant_menu,
    'respiratory': Icons.air,
    'cardiac': Icons.favorite,
    'immune': Icons.security,
    
    // Safety Levels
    'safe': Icons.check_circle,
    'caution': Icons.warning,
    'danger': Icons.dangerous,
    'poison': Icons.report,
    'allergic': Icons.error,
    'pregnancy_warning': Icons.pregnant_woman,
    'child_warning': Icons.child_care,
    'dosage': Icons.medication_liquid,
    'first_aid': Icons.local_hospital,
    'emergency': Icons.emergency,
    
    // Environments
    'forest': Icons.forest,
    'meadow': Icons.grass,
    'mountain': Icons.terrain,
    'water': Icons.water,
    'wetland': Icons.water_drop,
    'desert': Icons.wb_sunny,
    'garden': Icons.yard,
    'wild': Icons.nature_people,
    'urban': Icons.location_city,
    'coastal': Icons.waves,
    
    // Geographic Regions
    'tropical': Icons.wb_sunny,
    'temperate': Icons.thermostat,
    'arctic': Icons.ac_unit,
    'mediterranean': Icons.wb_sunny,
    'alpine': Icons.terrain,
    'riverside': Icons.water,
    'woodland': Icons.park,
    'prairie': Icons.grass,
    'swamp': Icons.water_drop,
    'cliff': Icons.landscape,
    
    // Preparation Methods
    'tea': Icons.local_cafe,
    'extract': Icons.science,
    'oil': Icons.opacity,
    'powder': Icons.grain,
    'fresh': Icons.eco,
    'dried': Icons.dry,
    'cooked': Icons.local_fire_department,
    'raw': Icons.nature,
    'fermented': Icons.bubble_chart,
    'distilled': Icons.water_drop,
    
    // Application Methods
    'topical': Icons.touch_app,
    'oral': Icons.medication,
    'inhale': Icons.air,
    'bath': Icons.bathtub,
    'compress': Icons.compress,
    'massage': Icons.spa,
    'gargle': Icons.water_drop,
    'eye_wash': Icons.remove_red_eye,
    'wound': Icons.healing,
    'skin': Icons.face,
    
    // Harvest & Growth
    'harvest': Icons.agriculture,
    'blooming': Icons.local_florist,
    'fruiting': Icons.apple,
    'seeding': Icons.scatter_plot,
    'germination': Icons.eco,
    'growth': Icons.trending_up,
    'mature': Icons.check,
    'young': Icons.child_friendly,
    'old': Icons.history,
    'seasonal': Icons.calendar_today,
    
    // Time Indicators
    'morning': Icons.wb_sunny,
    'noon': Icons.wb_sunny,
    'evening': Icons.wb_twilight,
    'night': Icons.nights_stay,
    'dawn': Icons.wb_twilight,
    'dusk': Icons.wb_twilight,
    'daily': Icons.today,
    'weekly': Icons.date_range,
    'monthly': Icons.calendar_month,
    'yearly': Icons.event,
    
    // Traditional Usage & Instructions
    'pour': Icons.water_drop,
    'wash': Icons.wash,
    'rinse': Icons.water_drop,
    'gently': Icons.touch_app,
    'scalp': Icons.face,
    'hair': Icons.face,
    'store': Icons.storage,
    'fridge': Icons.kitchen,
    'days': Icons.calendar_today,
    'time': Icons.schedule,
    'every': Icons.repeat,
    'best': Icons.star,
    'results': Icons.check_circle,
    'traditional': Icons.history_edu,
    'usage': Icons.info,
    'sprayed': Icons.water_drop,
    'roots': Icons.account_tree,
    'between': Icons.more_horiz,
    'washes': Icons.wash,

    
    // Default fallback
    'default': Icons.help_outline,
  };
  
  /// Get icon data for a given key
  static IconData getIcon(String iconKey) {
    return iconMap[iconKey.toLowerCase()] ?? iconMap['default']!;
  }
  
  /// Build an icon widget for a given key
  static Widget buildIcon(String iconKey, {Color? color, double? size}) {
    return Icon(
      getIcon(iconKey),
      color: color ?? const Color(0xFF5A4E3C),
      size: size ?? 20,
    );
  }
  
  /// Extract icon keys from content text (e.g., "[morning]" -> "morning")
  static List<String> extractIconKeys(String content) {
    final RegExp regex = RegExp(r'\[([^\]]+)\]');
    final matches = regex.allMatches(content);
    return matches.map((match) => match.group(1)!.toLowerCase()).toList();
  }
  
  /// Check if an icon key exists in the map
  static bool hasIcon(String iconKey) {
    return iconMap.containsKey(iconKey.toLowerCase());
  }
  
  /// Get all available icon keys
  static List<String> getAllIconKeys() {
    return iconMap.keys.toList()..sort();
  }
}
