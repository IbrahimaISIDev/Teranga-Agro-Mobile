import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teranga_agro/features/dashboard/domain/entities/dashboard_stats.dart';
import '../../../parcelle/presentation/providers/parcelle_provider.dart';
import '../../../parcelle/presentation/widgets/suivi_card.dart';
import 'section_header.dart';

class SuivisSection extends StatelessWidget {
  final String title;
  final String viewAllText;
  final String noRecentSuivisText;
  final ParcelleProvider provider;
  final VoidCallback onViewAllTap;

  const SuivisSection({
    Key? key,
    required this.title,
    required this.viewAllText,
    required this.noRecentSuivisText,
    required this.provider,
    required this.onViewAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => provider.fetchDashboardStats(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: title,
              actionText: viewAllText,
              onActionTap: onViewAllTap,
            ),
            const SizedBox(height: 16),
            Selector<ParcelleProvider, (bool, String?, DashboardStats?)>(
              selector: (_, provider) => (
                provider.isLoading,
                provider.errorMessage,
                provider.dashboardStats,
              ),
              builder: (_, data, __) {
                final (isLoading, errorMessage, dashboardStats) = data;
                return _buildSuivisContent(
                  isLoading,
                  errorMessage,
                  dashboardStats,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuivisContent(
    bool isLoading,
    String? errorMessage,
    DashboardStats? stats,
  ) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, color: Colors.red[400], size: 32),
              const SizedBox(height: 12),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (stats == null || stats.recentSuivis.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.history, color: Colors.grey[400], size: 32),
              const SizedBox(height: 12),
              Text(
                noRecentSuivisText,
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.recentSuivis.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SuiviCard(suivi: stats.recentSuivis[index]),
          ),
        );
      },
    );
  }
}