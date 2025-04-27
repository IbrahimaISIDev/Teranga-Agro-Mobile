import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onDeliver;

  const OrderCard({super.key, required this.order, this.onDeliver});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Commande #${order.orderNumber}', style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Client: ${order.clientName}', style: AppTextStyles.bodyMedium),
                  Text('${order.productName} - ${order.quantity} kg', style: AppTextStyles.bodyMedium),
                  Text('${order.price} FCFA', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 4),
                  Text(order.date, style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                ],
              ),
            ),
            if (onDeliver != null)
              ElevatedButton(
                onPressed: onDeliver,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('Livrer'),
              ),
          ],
        ),
      ),
    );
  }
}