// parcelles_section.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'section_header.dart';
import 'parcelle_card.dart';
import 'add_parcelle_card.dart';

class ParcellesSection extends StatelessWidget {
  final String title;
  final String viewAllText;
  final String statusGrowing;
  final String statusReadyToHarvest;
  final String addParcelleText;
  final VoidCallback onViewAllTap;
  final VoidCallback onAddParcelleTap;

  const ParcellesSection({
    Key? key,
    required this.title,
    required this.viewAllText,
    required this.statusGrowing,
    required this.statusReadyToHarvest,
    required this.addParcelleText,
    required this.onViewAllTap,
    required this.onAddParcelleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SectionHeader(
            title: title,
            actionText: viewAllText,
            onActionTap: onViewAllTap,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                ParcelleCard(
                  title: 'Maïs',
                  area: '2.5 ha',
                  status: statusGrowing,
                  statusColor: Colors.green,
                  imageAsset: 'assets/images/corn.jpg',
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                ParcelleCard(
                  title: 'Tomates',
                  area: '1.2 ha',
                  status: statusReadyToHarvest,
                  statusColor: Colors.orange,
                  imageAsset: 'assets/images/tomato.jpg',
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                AddParcelleCard(
                  addParcelleText: addParcelleText,
                  onTap: onAddParcelleTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}