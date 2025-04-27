// lib/features/main/presentation/pages/main_page.dart
import 'package:flutter/material.dart';
import 'package:teranga_agro/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:teranga_agro/features/dashboard/presentation/widgets/custom_bottom_navigation.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DashboardPage(), // Affiche uniquement le contenu de DashboardPage
      bottomNavigationBar: const CustomBottomNavigation(
        currentIndex: 0, // MainPage est à l'index 0 (onglet "Home")
      ),
    );
  }
}