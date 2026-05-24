import 'package:flutter/material.dart';
import '../models/area.dart';

/// Maps a cuisine area name to its country flag emoji.
/// Falls back to a globe emoji for unknown areas.
String _flagForArea(String area) {
  const flags = {
    'Afghan': '🇦🇫',
    'Albanian': '🇦🇱',
    'Algerian': '🇩🇿',
    'American': '🇺🇸',
    'Argentine': '🇦🇷',
    'Armenian': '🇦🇲',
    'Australian': '🇦🇺',
    'Austrian': '🇦🇹',
    'Azerbaijani': '🇦🇿',
    'Bangladeshi': '🇧🇩',
    'Belgian': '🇧🇪',
    'Bolivian': '🇧🇴',
    'Brazilian': '🇧🇷',
    'British': '🇬🇧',
    'Bulgarian': '🇧🇬',
    'Burmese': '🇲🇲',
    'Cambodian': '🇰🇭',
    'Canadian': '🇨🇦',
    'Chilean': '🇨🇱',
    'Chinese': '🇨🇳',
    'Colombian': '🇨🇴',
    'Croatian': '🇭🇷',
    'Cuban': '🇨🇺',
    'Czech': '🇨🇿',
    'Danish': '🇩🇰',
    'Dutch': '🇳🇱',
    'Egyptian': '🇪🇬',
    'Estonian': '🇪🇪',
    'Ethiopian': '🇪🇹',
    'Filipino': '🇵🇭',
    'Finnish': '🇫🇮',
    'French': '🇫🇷',
    'Georgian': '🇬🇪',
    'German': '🇩🇪',
    'Ghanaian': '🇬🇭',
    'Greek': '🇬🇷',
    'Guatemalan': '🇬🇹',
    'Haitian': '🇭🇹',
    'Honduran': '🇭🇳',
    'Hungarian': '🇭🇺',
    'Icelander': '🇮🇸',
    'Indian': '🇮🇳',
    'Indonesian': '🇮🇩',
    'Iranian': '🇮🇷',
    'Iraqi': '🇮🇶',
    'Irish': '🇮🇪',
    'Israeli': '🇮🇱',
    'Italian': '🇮🇹',
    'Jamaican': '🇯🇲',
    'Japanese': '🇯🇵',
    'Jordanian': '🇯🇴',
    'Kazakhstani': '🇰🇿',
    'Kenyan': '🇰🇪',
    'Korean': '🇰🇷',
    'South Korean': '🇰🇷',
    'Kuwaiti': '🇰🇼',
    'Latvian': '🇱🇻',
    'Lebanese': '🇱🇧',
    'Lithuanian': '🇱🇹',
    'Malaysian': '🇲🇾',
    'Maltese': '🇲🇹',
    'Mexican': '🇲🇽',
    'Mongolian': '🇲🇳',
    'Moroccan': '🇲🇦',
    'Mozambican': '🇲🇿',
    'Namibian': '🇳🇦',
    'Nepalese': '🇳🇵',
    'Nigerian': '🇳🇬',
    'Norwegian': '🇳🇴',
    'Pakistani': '🇵🇰',
    'Palestinian': '🇵🇸',
    'Peruvian': '🇵🇪',
    'Polish': '🇵🇱',
    'Portuguese': '🇵🇹',
    'Romanian': '🇷🇴',
    'Russian': '🇷🇺',
    'Saudi Arabian': '🇸🇦',
    'Senegalese': '🇸🇳',
    'Serbian': '🇷🇸',
    'Singaporean': '🇸🇬',
    'Slovak': '🇸🇰',
    'Slovene': '🇸🇮',
    'South African': '🇿🇦',
    'Spanish': '🇪🇸',
    'Sri Lankan': '🇱🇰',
    'Swedish': '🇸🇪',
    'Swiss': '🇨🇭',
    'Syrian': '🇸🇾',
    'Taiwanese': '🇹🇼',
    'Tanzanian': '🇹🇿',
    'Thai': '🇹🇭',
    'Tunisian': '🇹🇳',
    'Turkish': '🇹🇷',
    'Ukrainian': '🇺🇦',
    'Uruguayan': '🇺🇾',
    'Venezuelan': '🇻🇪',
    'Vietnamese': '🇻🇳',
    'Yemeni': '🇾🇪',
    'Zambian': '🇿🇲',
    'Zimbabwean': '🇿🇼',
  };
  return flags[area] ?? '🌍';
}

class AreaTile extends StatelessWidget {
  final Area area;
  final VoidCallback onTap;

  const AreaTile({
    super.key,
    required this.area,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          _flagForArea(area.name),
          style: const TextStyle(fontSize: 26),
        ),
      ),
      title: Text(area.name),
      subtitle: Text(
        '${area.name} cuisine',
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
