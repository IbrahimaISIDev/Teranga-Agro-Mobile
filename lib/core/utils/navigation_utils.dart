// lib/core/utils/navigation_utils.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationUtils {
  static void navigateWithBottomNav(BuildContext context, int index) {
    // Liste des routes correspondant aux onglets (similaire à NavigationRoutes)
    const List<String> routes = [
      '/main',      // Index 0
      '/parcelles', // Index 1
      '/marketplace', // Index 2
      '/profile',   // Index 3
    ];

    // TODO: Ajouter la vérification de connexion ici plus tard
    // Exemple futur :
    // bool isLoggedIn = await checkUserLoggedIn();
    // if (index == 3 && !isLoggedIn) {
    //   context.go('/login'); // Redirige vers la page de connexion
    //   return;
    // }

    // Navigue vers la route correspondante
    context.go(routes[index]);
  }

  // Méthode placeholder pour la vérification de connexion (à implémenter plus tard)
  static Future<bool> checkUserLoggedIn() async {
    // Placeholder : à remplacer par la vraie logique de connexion
    // Par exemple, vérifier un token dans un SharedPreferences ou un état global
    return true; // Pour l'instant, on simule que l'utilisateur est connecté
  }
}