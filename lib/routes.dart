import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teranga_agro/features/marketplace/domain/entities/product.dart';
import 'package:teranga_agro/features/marketplace/presentation/pages/add_product_page.dart';
import 'package:teranga_agro/features/marketplace/presentation/pages/edit_product_page.dart';
import 'package:teranga_agro/features/marketplace/presentation/pages/marketplace_page.dart';
import 'package:teranga_agro/features/parcelle/domain/entities/parcelle.dart';
import 'package:teranga_agro/features/parcelle/domain/entities/culture.dart';
import 'package:teranga_agro/features/parcelle/presentation/pages/main_page.dart';
import 'package:teranga_agro/features/parcelle/presentation/pages/parcelles_list_page.dart';
import 'package:teranga_agro/features/parcelle/presentation/pages/add_parcelle_page.dart';
import 'package:teranga_agro/features/parcelle/presentation/pages/parcelle_details_page.dart';
import 'package:teranga_agro/features/parcelle/presentation/pages/cultures_list_page.dart';
import 'package:teranga_agro/features/parcelle/presentation/pages/add_culture_page.dart';
import 'package:teranga_agro/features/parcelle/presentation/pages/culture_details_page.dart';
import 'package:teranga_agro/features/parcelle/presentation/pages/add_suivi_page.dart';
import 'package:teranga_agro/features/profile/presentation/pages/profile_page.dart';

final router = GoRouter(
  initialLocation: '/main',
  debugLogDiagnostics: true, // Activer les journaux pour déboguer
  routes: [
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/parcelles',
      builder: (context, state) => const ParcellesListPage(),
    ),
    GoRoute(
      path: '/add-parcelle',
      builder: (context, state) => const AddParcellePage(),
    ),
    GoRoute(
      path: '/edit-parcelle/:id',
      builder: (context, state) => AddParcellePage(
        parcelle: state.extra as Parcelle?,
      ),
    ),
    GoRoute(
      path: '/parcelle-details/:id',
      builder: (context, state) => ParcelleDetailsPage(
        parcelle: state.extra as Parcelle,
      ),
    ),
    GoRoute(
      path: '/cultures/:parcelleId',
      builder: (context, state) => CulturesListPage(
        parcelleId: int.parse(state.pathParameters['parcelleId']!),
      ),
    ),
    GoRoute(
      path: '/add-culture/:parcelleId',
      builder: (context, state) => AddCulturePage(
        parcelleId: int.parse(state.pathParameters['parcelleId']!),
      ),
    ),
    GoRoute(
      path: '/culture-details/:id',
      builder: (context, state) => CultureDetailsPage(
        culture: state.extra as Culture,
      ),
    ),
    GoRoute(
      path: '/edit-culture/:id',
      builder: (context, state) => AddCulturePage(
        parcelleId: (state.extra as Culture).parcelleId,
        culture: state.extra as Culture,
      ),
    ),
    GoRoute(
      path: '/add-suivi/:cultureId',
      builder: (context, state) => AddSuiviPage(
        cultureId: int.parse(state.pathParameters['cultureId']!),
      ),
    ),
    GoRoute(
      path: '/marketplace',
      builder: (context, state) => const MarketplacePage(),
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductPage(),
    ),
    GoRoute(
      path: '/edit-product/:id',
      builder: (context, state) =>
          EditProductPage(product: state.extra as Product),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Erreur de navigation : ${state.error}'),
    ),
  ),
);
