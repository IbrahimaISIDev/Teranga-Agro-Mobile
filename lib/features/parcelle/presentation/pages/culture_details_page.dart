import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/culture.dart';
import '../providers/parcelle_provider.dart';
import '../widgets/audio_toggle.dart';
import '../widgets/suivi_card.dart';

class CultureDetailsPage extends StatelessWidget {
  final Culture culture;

  const CultureDetailsPage({super.key, required this.culture});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<ParcelleProvider>(context);

    // Fetch suivis on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchSuivis(culture.id);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.cultureDetailsTitle, style: AppTextStyles.heading1),
        actions: [AudioToggle(instructions: loc.cultureDetailsAudio)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.cultureNomLabel, style: AppTextStyles.heading3),
            Text(culture.nom, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Text(loc.cultureTypeLabel, style: AppTextStyles.heading3),
            Text(culture.type, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Text(loc.cultureDateLabel, style: AppTextStyles.heading3),
            Text(culture.datePlantation, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            Text('Suivis', style: AppTextStyles.heading3),
            Expanded(
              child: Consumer<ParcelleProvider>(
                builder: (context, provider, child) {
                  final suivis = provider.getSuivis(culture.id);
                  return provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : suivis.isEmpty
                          ? Center(child: Text('Aucun suivi', style: AppTextStyles.bodyMedium))
                          : ListView.builder(
                              itemCount: suivis.length,
                              itemBuilder: (context, index) {
                                return SuiviCard(suivi: suivis[index]);
                              },
                            );
                },
              ),
            ),
            if (provider.isOffline)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(loc.offlineMessage, style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.push('/edit-culture/${culture.id}', extra: culture),
                  icon: Icon(Icons.edit),
                  label: Text(loc.editCulture),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    bool? confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(loc.deleteCulture),
                        content: Text(loc.deleteCultureConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Supprimer'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      bool success = await provider.deleteCulture(culture.id, culture.parcelleId);
                      if (success) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(provider.errorMessage ?? 'Erreur')),
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.delete),
                  label: Text(loc.deleteCulture),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-suivi/${culture.id}'),
        label: Text(loc.addSuivi),
        icon: Icon(Icons.add),
      ),
    );
  }
}