import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teranga_agro/features/marketplace/presentation/providers/marketplace_provider.dart';
import 'package:teranga_agro/features/marketplace/presentation/widgets/product_card.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../status_widgets/loading_widget.dart';
import '../status_widgets/error_widget.dart';
import '../status_widgets/empty_state_widget.dart';
import '../featured_products_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsTab extends StatelessWidget {
  final Function refreshData;

  const ProductsTab({
    Key? key,
    required this.refreshData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<MarketplaceProvider>(context);

    return Padding(
      padding:
          const EdgeInsets.fromLTRB(16, 16, 16, 80), // Bottom padding for FAB
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured products section
          if (provider.products.isNotEmpty)
            FeaturedProductsSlider(
              products: provider.products,
              title: loc.featuredProducts ?? "Produits en vedette",
            ),

          // All products header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.allProducts ?? "Tous les produits",
                style: AppTextStyles.heading3,
              ),
              _buildRefreshButton(loc),
            ],
          ),
          SizedBox(height: 8),

          // Products list
          Expanded(
            child: _buildProductsList(context, provider, loc),
          ),

          // Offline message
          if (provider.isOffline) _buildOfflineMessage(loc),
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

  Widget _buildProductsList(BuildContext context, MarketplaceProvider provider,
      AppLocalizations loc) {
    if (provider.isLoading) {
      return LoadingWidget();
    }

    if (provider.errorMessage != null) {
      return ErrorDisplayWidget(
        errorMessage: provider.errorMessage!,
        onRetry: () => refreshData(),
      );
    }

    if (provider.products.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.shopping_basket,
        message: loc.noProducts,
        actionButton: ElevatedButton.icon(
          onPressed: () {
            // TODO: Navigate to add product page
          },
          icon: Icon(Icons.add),
          label: Text(loc.addProduct ?? "Ajouter un produit"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 16),
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ProductCard(
            product: provider.products[index],
            onEdit: () {
              context.go('/edit-product/${provider.products[index].id}',
                  extra: provider.products[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildOfflineMessage(AppLocalizations loc) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              loc.offlineMessage,
              style: TextStyle(color: Colors.red[700], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
