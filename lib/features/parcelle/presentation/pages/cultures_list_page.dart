import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/parcelle_provider.dart';
import '../widgets/audio_toggle.dart';

class CulturesListPage extends StatelessWidget {
  final int parcelleId;

  const CulturesListPage({super.key, required this.parcelleId});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<ParcelleProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(loc.culturesTitle, style: AppTextStyles.heading3.copyWith(color: Colors.white)),
        actions: [AudioToggle(instructions: loc.detailsAudio)],
      ),
      body: Column(
        children: [
          // En-tête décoratif
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.only(bottom: 30, left: 20, right: 20),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.culturesTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FutureBuilder<String>(
                              future: _getParcelleNom(provider, parcelleId),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data ?? "Chargement...",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.agriculture,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Indicateur hors ligne
          if (provider.isOffline)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.orange[100],
              child: Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.orange[800], size: 18),
                  SizedBox(width: 8),
                  Text(
                    loc.offlineMessage,
                    style: TextStyle(color: Colors.orange[800], fontSize: 14),
                  ),
                ],
              ),
            ),
            
          // Contenu principal
          Expanded(
            child: provider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.spa_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        loc.noCultures,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Ajoutez une culture pour cette parcelle",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/add-culture/$parcelleId'),
                        icon: Icon(Icons.add),
                        label: Text(loc.addCulture),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1,
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-culture/$parcelleId'),
        label: Text(loc.addCulture),
        icon: Icon(Icons.add),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  Future<String> _getParcelleNom(ParcelleProvider provider, int parcelleId) async {
    try {
      final parcelle = provider.parcelles.firstWhere((p) => p.id == parcelleId);
      return parcelle.nom;
    } catch (e) {
      return "Parcelle #$parcelleId";
    }
  }
}