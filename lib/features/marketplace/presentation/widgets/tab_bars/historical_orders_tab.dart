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

class HistoricalOrdersTab extends StatelessWidget {
  final Function refreshData;

  const HistoricalOrdersTab({
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
                loc.ordersHistorySection,
                style: AppTextStyles.heading3,
              ),
              _buildRefreshButton(loc),
            ],
          ),
          SizedBox(height: 16),
          
          // Orders summary
          if (provider.historicalOrders.isNotEmpty)
            _buildOrdersSummary(provider, loc),
          SizedBox(height: 16),
          
          // Historical orders list
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

  Widget _buildOrdersSummary(MarketplaceProvider provider, AppLocalizations loc) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.7), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.completedOrdersTitle ?? "Commandes terminées",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  loc.completedOrdersSubtitle ?? "Merci pour votre service!",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Text(
              provider.historicalOrders.length.toString(),
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
    
    if (provider.historicalOrders.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.history,
        message: loc.noHistoricalOrders,
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 16),
      itemCount: provider.historicalOrders.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: OrderCard(
            order: provider.historicalOrders[index],
          ),
        );
      },
    );
  }
}