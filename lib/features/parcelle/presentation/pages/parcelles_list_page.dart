import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teranga_agro/features/dashboard/presentation/widgets/custom_bottom_navigation.dart';
import 'package:teranga_agro/features/parcelle/presentation/providers/parcelle_provider.dart';
import 'package:teranga_agro/features/parcelle/presentation/widgets/language_toggle.dart';
import 'package:teranga_agro/features/parcelle/presentation/widgets/parcelle_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ParcellesListPage extends StatefulWidget {
  const ParcellesListPage({super.key});

  @override
  State<ParcellesListPage> createState() => _ParcellesListPageState();
}

class _ParcellesListPageState extends State<ParcellesListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ParcelleProvider>(context, listen: false).fetchParcelles();
    });
  }

  Future<void> _refreshParcelles() async {
    await Provider.of<ParcelleProvider>(context, listen: false)
        .fetchParcelles();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.parcellesTitle,
          style: AppTextStyles.heading3.copyWith(color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: LanguageToggle(),
          ),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec design
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appTitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.parcellesTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.eco,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Corps principal avec liste de parcelles
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshParcelles,
              color: AppColors.primary,
              child: Consumer<ParcelleProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    );
                  }
                  if (provider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            provider.errorMessage!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _refreshParcelles,
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.retryButton ?? "Réessayer"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (provider.parcelles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.yard_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noParcelles,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.addParcellePrompt ??
                                "Ajoutez votre première parcelle en appuyant sur le bouton +",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => context.push('/add-parcelle'),
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addParcelle),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.parcelles.length,
                      itemBuilder: (context, index) {
                        final parcelle = provider.parcelles[index];
                        // Ensure parcelle.id is not null for Dismissible key
                        if (parcelle.id == null) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Dismissible(
                            key: Key(parcelle.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              final bool? confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(l10n.deleteParcelle),
                                  content: Text(l10n.deleteConfirm),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child:
                                          Text(l10n.cancelButton ?? 'Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(
                                          l10n.deleteButton ?? 'Supprimer'),
                                    ),
                                  ],
                                ),
                              );
                              return confirm ?? false;
                            },
                            onDismissed: (direction) async {
                              final success =
                                  await provider.deleteParcelle(parcelle.id!);
                              if (!success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      provider.errorMessage ?? l10n.formError,
                                    ),
                                  ),
                                );
                                await _refreshParcelles();
                              }
                            },
                            child: ParcelleCard(
                              parcelle: parcelle,
                              onEdit: () {
                                context
                                    .push(
                                  '/edit-parcelle/${parcelle.id}',
                                  extra: parcelle,
                                )
                                    .then((result) {
                                  if (result == true) {
                                    _refreshParcelles();
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // Message hors-ligne si nécessaire
          Consumer<ParcelleProvider>(
            builder: (context, provider, child) {
              if (provider.isOffline) {
                return Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.orange[100],
                  child: Row(
                    children: [
                      Icon(
                        Icons.wifi_off,
                        color: Colors.orange[800],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.offlineMessage,
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-parcelle').then((result) {
          if (result == true) {
            _refreshParcelles();
          }
        }),
        label: Text(l10n.addParcelle),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentIndex: 1, // Marketplace est à l'index 2
      ),
    );
  }
}
