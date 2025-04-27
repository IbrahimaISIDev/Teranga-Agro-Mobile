// lib/core/widgets/custom_bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teranga_agro/core/utils/navigation_utils.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => NavigationUtils.navigateWithBottomNav(context, index),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(IconlyLight.home),
          label: loc.navHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(IconlyLight.activity),
          label: loc.navParcelles,
        ),
        BottomNavigationBarItem(
          icon: const Icon(IconlyLight.bag),
          label: loc.navMarketplace,
        ),
        BottomNavigationBarItem(
          icon: const Icon(IconlyLight.profile),
          label: loc.navProfile,
        ),
      ],
    );
  }
}