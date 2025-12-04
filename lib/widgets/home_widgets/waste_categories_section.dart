import 'package:flutter/material.dart';

class WasteCategoriesSection extends StatelessWidget {
  const WasteCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Cardboard',
        'icon': Icons.inventory_2_outlined,
        'color': 0xFFD4A574
      },
      {'name': 'Glass', 'icon': Icons.wine_bar_outlined, 'color': 0xFF81C784},
      {'name': 'Metal', 'icon': Icons.settings_outlined, 'color': 0xFF90A4AE},
      {
        'name': 'Paper',
        'icon': Icons.description_outlined,
        'color': 0xFF64B5F6
      },
      {
        'name': 'Plastic',
        'icon': Icons.water_drop_outlined,
        'color': 0xFFFFB74D
      },
      {'name': 'Trash', 'icon': Icons.delete_outline, 'color': 0xFFE57373},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Waste Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D5C3A),
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF1D5C3A),
                  width: 0.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    size: 32,
                    color: Color(category['color'] as int),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category['name'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
