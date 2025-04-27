// lib/features/marketplace/presentation/pages/marketplace_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teranga_agro/features/dashboard/presentation/widgets/custom_bottom_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/tab_bars/products_tab.dart';
import '../widgets/tab_bars/pending_orders_tab.dart';
import '../widgets/tab_bars/historical_orders_tab.dart';
import '../widgets/marketplace_header.dart'; // Import du MarketplaceHeader

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage>
    with SingleTickerProviderStateMixin {
  bool _hasFetchedData = false;
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasFetchedData) {
        _fetchInitialData();
        _hasFetchedData = true;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchInitialData() {
    final provider = Provider.of<MarketplaceProvider>(context, listen: false);
    provider.fetchProducts();
    provider.fetchOrders();
  }

  Future<void> _refreshData() async {
    final provider = Provider.of<MarketplaceProvider>(context, listen: false);
    await Future.wait([
      provider.fetchProducts(),
      provider.fetchOrders(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            // Utilisation de MarketplaceHeader
            SliverToBoxAdapter(
              child: MarketplaceHeader(),
            ),

            // Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                        icon: const Icon(Icons.shopping_cart),
                        text: loc.productsSection),
                    Tab(
                        icon: const Icon(Icons.pending_actions),
                        text: loc.ordersPendingSection),
                    Tab(
                        icon: const Icon(Icons.history),
                        text: loc.ordersHistorySection),
                  ],
                ),
              ),
            ),

            // Tab Content
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ProductsTab(refreshData: _refreshData),
                  PendingOrdersTab(refreshData: _refreshData),
                  HistoricalOrdersTab(refreshData: _refreshData),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/add-product');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: Text(loc.addProduct ?? "Ajouter"),
        elevation: 2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const CustomBottomNavigation(
        currentIndex: 2,
      ),
    );
  }
}

// Custom SliverTabBarDelegate for the TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
