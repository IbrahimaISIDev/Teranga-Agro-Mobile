// dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teranga_agro/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:teranga_agro/features/dashboard/presentation/widgets/parcelles_section.dart';
import '../../../parcelle/presentation/providers/parcelle_provider.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/suivis_section.dart';
import '../widgets/offline_status_banner.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Appeler fetchDashboardStats une seule fois à l'initialisation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParcelleProvider>().fetchDashboardStats(debounce: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Selector<ParcelleProvider, DashboardStats?>(
                selector: (_, provider) => provider.dashboardStats,
                builder: (_, dashboardStats, __) {
                  return DashboardHeader(
                    userName: 'Ibrahima',
                    welcomeMessage: loc.welcomeMessage,
                    activityOverview: loc.activityOverview,
                    dashboardAudio: loc.dashboardAudio,
                    dashboardStats: dashboardStats,
                    parcellesLabel: loc.dashboardParcellesCount,
                    culturesLabel: loc.dashboardCulturesCount,
                    salesLabel: loc.dashboardSales,
                    onParcellesTap: () => context.go('/parcelles'),
                    onCulturesTap: () => context.go('/parcelles'),
                  );
                },
              ),

              // Parcelles Section
              ParcellesSection(
                title: loc.yourParcelles,
                viewAllText: loc.viewAll,
                statusGrowing: loc.statusGrowing,
                statusReadyToHarvest: loc.statusReadyToHarvest,
                addParcelleText: loc.addParcelle,
                onViewAllTap: () => context.go('/parcelles'),
                onAddParcelleTap: () => context.go('/add_parcelle'),
              ),

              // Recent Suivis Section
              SuivisSection(
                title: loc.dashboardSuivisCount,
                viewAllText: loc.viewAll,
                noRecentSuivisText: loc.noRecentSuivis,
                provider: context.read<ParcelleProvider>(),
                onViewAllTap: () => context.go('/parcelles'),
              ),

              // Offline Status
              Selector<ParcelleProvider, bool>(
                selector: (_, provider) => provider.isOffline,
                builder: (_, isOffline, __) {
                  return isOffline
                      ? OfflineStatusBanner(message: loc.offlineMessage)
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}