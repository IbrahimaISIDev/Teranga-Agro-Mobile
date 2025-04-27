import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teranga_agro/features/marketplace/presentation/providers/marketplace_provider.dart';
import 'package:teranga_agro/features/marketplace/presentation/widgets/order_card.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../status_widgets/loading_widget.dart';
import '../status_widgets/error_widget.dart';
import '../status_widgets/empty_state_widget.dart';
import '../stats_widget.dart';

class PendingOrdersTab extends StatelessWidget {
  final Function refreshData;

  const PendingOrdersTab({
    Key? key,
    required this.refreshData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<MarketplaceProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Bottom padding for FAB
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.ordersPendingSection,
                style: AppTextStyles.heading3,
              ),
              _buildRefreshButton(loc),
            ],
          ),
          SizedBox(height: 8),
          
          // Order stats
          if (provider.pendingOrders.isNotEmpty)
            _buildOrderStats(provider, loc),
          SizedBox(height: 16),
          
          // Pending orders list
          Expanded(
            child: _buildOrdersList(context, provider, loc),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(AppLocalizations loc) {
    return TextButton.icon(
      onPressed: () => refreshData(),
      icon: Icon(Icons.refresh, size: 16),
      label: Text(loc.refresh ?? "Actualiser"),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildOrderStats(MarketplaceProvider provider, AppLocalizations loc) {
    final stats = [
      StatItem(
        value: provider.pendingOrders.length.toString(),
        label: loc.pendingCount ?? "En attente",
        icon: Icons.pending_actions,
        color: Colors.orange,
      ),
      StatItem(
        value: provider.pendingOrders.where((o) => o.status == 'processing').length.toString(),
        label: loc.processingCount ?? "En cours",
        icon: Icons.hourglass_bottom,
        color: Colors.blue,
      ),
      StatItem(
        value: provider.pendingOrders.where((o) => o.status == 'shipped').length.toString(),
        label: loc.shippedCount ?? "Expédiées",
        icon: Icons.local_shipping,
        color: Colors.green,
      ),
    ];

    return StatsWidget(
      stats: stats,
      backgroundColor: Colors.blue[50]!,
      borderColor: Colors.blue[100]!,
    );
  }

  Widget _buildOrdersList(
    BuildContext context, 
    MarketplaceProvider provider,
    AppLocalizations loc
  ) {
    if (provider.isLoading) {
      return LoadingWidget();
    }
    
    if (provider.errorMessage != null) {
      return ErrorDisplayWidget(
        errorMessage: provider.errorMessage!,
        onRetry: () => refreshData(),
      );
    }
    
    if (provider.pendingOrders.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.inventory_2_outlined,
        message: loc.noPendingOrders,
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 16),
      itemCount: provider.pendingOrders.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: OrderCard(
            order: provider.pendingOrders[index],
            onDeliver: () async {
              await provider.updateOrderStatus(provider.pendingOrders[index].id, 'delivered');
              refreshData();
            },
          ),
        );
      },
    );
  }
}