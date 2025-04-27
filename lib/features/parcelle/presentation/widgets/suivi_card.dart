import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/suivi.dart';

class SuiviCard extends StatelessWidget {
  final Suivi suivi;

  const SuiviCard({super.key, required this.suivi});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(Icons.task_alt, size: 48, color: AppColors.primary),
        title: Text(suivi.type, style: AppTextStyles.bodyMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${suivi.date}', style: AppTextStyles.bodyMedium),
            if (suivi.notes != null) Text('Notes: ${suivi.notes}', style: AppTextStyles.bodyMedium),
          ],
        ),
        trailing: const Icon(Icons.info_outline),
        onTap: () {
          // Placeholder: Navigate to suivi details (future)
        },
      ),
    );
  }
}