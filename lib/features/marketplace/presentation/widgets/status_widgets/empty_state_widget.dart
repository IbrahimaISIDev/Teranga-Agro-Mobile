import 'package:flutter/material.dart';
import '../../../../../core/theme/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final Widget? actionButton;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.message,
    this.actionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          if (actionButton != null) ...[
            SizedBox(height: 16),
            actionButton!,
          ],
        ],
      ),
    );
  }
}