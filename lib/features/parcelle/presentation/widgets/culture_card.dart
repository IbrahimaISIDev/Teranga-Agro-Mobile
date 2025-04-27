import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/culture.dart';

class CultureCard extends StatelessWidget {
  final Culture culture;

  const CultureCard({super.key, required this.culture});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(Icons.grass, size: 48, color: AppColors.primary),
        title: Text(culture.nom, style: AppTextStyles.bodyMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${culture.type}', style: AppTextStyles.bodyMedium),
            Text('Planté: ${culture.datePlantation}', style: AppTextStyles.bodyMedium),
          ],
        ),
        trailing: const Icon(Icons.info_outline),
        onTap: () => context.push('/culture-details/${culture.id}', extra: culture),
      ),
    );
  }
}