// dashboard_header.dart
import 'package:flutter/material.dart';
import 'package:teranga_agro/features/dashboard/presentation/widgets/stats_item.dart';
import 'package:teranga_agro/features/parcelle/presentation/widgets/language_toggle.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../parcelle/presentation/widgets/audio_toggle.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String welcomeMessage;
  final String activityOverview;
  final String dashboardAudio;
  final dynamic dashboardStats;
  final String parcellesLabel;
  final String culturesLabel;
  final String salesLabel;
  final VoidCallback onParcellesTap;
  final VoidCallback onCulturesTap;
  final VoidCallback? onSalesTap;

  const DashboardHeader({
    Key? key,
    required this.userName,
    required this.welcomeMessage,
    required this.activityOverview,
    required this.dashboardAudio,
    this.dashboardStats,
    required this.parcellesLabel,
    required this.culturesLabel,
    required this.salesLabel,
    required this.onParcellesTap,
    required this.onCulturesTap,
    this.onSalesTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Welcoming Header with Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: AppColors.primary, size: 32),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$welcomeMessage, $userName 👋',
                        style: AppTextStyles.heading2.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activityOverview,
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  AudioToggle(instructions: dashboardAudio),
                  const LanguageToggle(),
                  const SizedBox(width: 1),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Overview Cards
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatsItem(
                  icon: Icons.landscape,
                  iconColor: Colors.green,
                  title: parcellesLabel,
                  value: dashboardStats?.parcellesCount ?? 0,
                  onTap: onParcellesTap,
                ),
                const VerticalDivider(),
                StatsItem(
                  icon: Icons.grass,
                  iconColor: Colors.orange,
                  title: culturesLabel,
                  value: dashboardStats?.culturesCount ?? 0,
                  onTap: onCulturesTap,
                ),
                const VerticalDivider(),
                StatsItem(
                  icon: Icons.monetization_on,
                  iconColor: Colors.blue,
                  title: salesLabel,
                  value: 120000,
                  isCurrency: true,
                  onTap: onSalesTap ?? () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}