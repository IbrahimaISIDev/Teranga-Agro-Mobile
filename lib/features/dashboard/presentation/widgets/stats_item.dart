// stats_item.dart
import 'package:flutter/material.dart';

class StatsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final int value;
  final bool isCurrency;
  final VoidCallback onTap;

  const StatsItem({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.isCurrency = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isCurrency ? '${value.toString()} F' : value.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}