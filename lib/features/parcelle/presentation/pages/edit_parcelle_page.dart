import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teranga_agro/features/parcelle/domain/entities/parcelle.dart';
import 'package:teranga_agro/features/parcelle/presentation/providers/parcelle_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class EditParcellePage extends StatefulWidget {
  final Parcelle parcelle;

  const EditParcellePage({super.key, required this.parcelle});

  @override
  State<EditParcellePage> createState() => _EditParcellePageState();
}

class _EditParcellePageState extends State<EditParcellePage> {
  late TextEditingController _nameController;
  late TextEditingController _surfaceController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing parcelle data
    _nameController = TextEditingController(text: widget.parcelle.nom);
    _surfaceController = TextEditingController(text: widget.parcelle.surface.toString());
    _latitudeController = TextEditingController(
      text: widget.parcelle.latitude?.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: widget.parcelle.longitude?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surfaceController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _updateParcelle(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final updatedParcelle = Parcelle(
        id: widget.parcelle.id, // Keep the existing ID
        nom: _nameController.text,
        surface: double.parse(_surfaceController.text),
        latitude: _latitudeController.text.isNotEmpty
            ? double.tryParse(_latitudeController.text)
            : null,
        longitude: _longitudeController.text.isNotEmpty
            ? double.tryParse(_longitudeController.text)
            : null,
      );

      final provider = Provider.of<ParcelleProvider>(context, listen: false);
      final success = await provider.updateParcelle(updatedParcelle);
      if (success && context.mounted) {
        context.pop(true); // Return true to indicate success
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? AppLocalizations.of(context)!.formError),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editParcelle, style: AppTextStyles.heading3),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.nomLabel,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.formError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _surfaceController,
                decoration: InputDecoration(
                  labelText: l10n.surfaceLabel,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.formError;
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return l10n.formError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude (facultatif)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return l10n.formError;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(
                  labelText: 'Longitude (facultatif)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return l10n.formError;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _updateParcelle(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.saveButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}