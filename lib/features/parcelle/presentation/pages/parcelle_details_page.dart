import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/parcelle.dart';
import '../providers/parcelle_provider.dart';
import '../widgets/audio_toggle.dart';

class ParcelleDetailsPage extends StatelessWidget {
  final Parcelle parcelle;

  const ParcelleDetailsPage({super.key, required this.parcelle});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<ParcelleProvider>(context);

    // Ensure parcelle.id is not null before using it in routes
    if (parcelle.id == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(loc.detailsTitle, style: AppTextStyles.heading3.copyWith(color: Colors.white)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red[300],
              ),
              SizedBox(height: 16),
              Text(
                loc.errorParcelleNotFound,
                style: TextStyle(color: Colors.red[700], fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back),
                label: Text("Retour"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(loc.detailsTitle, style: AppTextStyles.heading3.copyWith(color: Colors.white)),
        actions: [AudioToggle(instructions: loc.detailsAudio)],
      ),
      body: SingleChildScrollView(
        child: Column(
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
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parcelle.nom,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.landscape, color: Colors.white70, size: 18),
                      SizedBox(width: 8),
                      Text(
                        '${parcelle.surface} ha',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      if (parcelle.latitude != null && parcelle.longitude != null) ...[
                        SizedBox(width: 16),
                        Icon(Icons.location_on, color: Colors.white70, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${parcelle.latitude!.toStringAsFixed(4)}, ${parcelle.longitude!.toStringAsFixed(4)}',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Informations principales
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carte d'informations
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: AppColors.primary),
                              SizedBox(width: 10),
                              Text(
                                loc.detailsTitle,
                                style: AppTextStyles.heading3.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                          Divider(height: 30),
                          _buildInfoRow(
                            context,
                            icon: Icons.eco,
                            title: loc.nomLabel,
                            value: parcelle.nom,
                          ),
                          Divider(height: 24, thickness: 0.5),
                          _buildInfoRow(
                            context,
                            icon: Icons.area_chart,
                            title: loc.surfaceLabel,
                            value: '${parcelle.surface} ha',
                          ),
                          if (parcelle.latitude != null && parcelle.longitude != null) ...[
                            Divider(height: 24, thickness: 0.5),
                            _buildInfoRow(
                              context, 
                              icon: Icons.location_on,
                              title: loc.positionLabel ?? 'Position',
                              value: '(${parcelle.latitude!.toStringAsFixed(6)}, ${parcelle.longitude!.toStringAsFixed(6)})',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Section des cultures
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.agriculture, color: AppColors.primary),
                                  SizedBox(width: 10),
                                  Text(
                                    loc.culturesTitle,
                                    style: AppTextStyles.heading3.copyWith(fontSize: 18),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () => context.push('/cultures/${parcelle.id}'),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add, size: 16, color: AppColors.primary),
                                      SizedBox(width: 4),
                                      Text(
                                        loc.addCulture,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(height: 30),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.grass,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  loc.noCultures,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Section de gestion
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.settings, color: AppColors.primary),
                              SizedBox(width: 10),
                              Text(
                                "Gestion",
                                style: AppTextStyles.heading3.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                          Divider(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  context,
                                  icon: Icons.edit,
                                  label: loc.editParcelle,
                                  color: Colors.orange,
                                  onPressed: () => context.push(
                                    '/edit-parcelle/${parcelle.id}',
                                    extra: parcelle,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildActionButton(
                                  context,
                                  icon: Icons.delete,
                                  label: loc.deleteParcelle,
                                  color: Colors.red,
                                  onPressed: () async {
                                    final bool? confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(loc.deleteParcelle),
                                        content: Text(loc.deleteConfirm),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text(
                                              loc.cancelButton ?? 'Annuler',
                                              style: TextStyle(color: Colors.grey[700]),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(loc.deleteButton ?? 'Supprimer'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      final success = await provider.deleteParcelle(parcelle.id!);
                                      if (success) {
                                        if (context.mounted) {
                                          context.pop();
                                        }
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(provider.errorMessage ?? loc.formError),
                                              behavior: SnackBarBehavior.floating,
                                              margin: EdgeInsets.all(20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: provider.isOffline 
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.red[50],
            child: SafeArea(
              child: Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.red[700], size: 20),
                  SizedBox(width: 8),
                  Text(
                    loc.offlineMessage,
                    style: TextStyle(color: Colors.red[700], fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/cultures/${parcelle.id}'),
        label: Text(loc.addCulture),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
  
  Widget _buildInfoRow(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: color.withOpacity(0.1),
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}