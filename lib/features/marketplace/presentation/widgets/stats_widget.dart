import 'package:flutter/material.dart';

class StatItem {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class StatsWidget extends StatelessWidget {
  final List<StatItem> stats;
  final Color backgroundColor;
  final Color borderColor;

  const StatsWidget({
    Key? key,
    required this.stats,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((stat) => _buildStatItem(stat)).toList(),
      ),
    );
  }

  Widget _buildStatItem(StatItem stat) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: stat.color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(stat.icon, color: stat.color),
        ),
        SizedBox(height: 8),
        Text(
          stat.value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          stat.label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}