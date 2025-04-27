import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/parcelle_provider.dart';
import '../widgets/audio_toggle.dart';

class AddSuiviPage extends StatefulWidget {
  final int cultureId;

  const AddSuiviPage({super.key, required this.cultureId});

  @override
  _AddSuiviPageState createState() => _AddSuiviPageState();
}

class _AddSuiviPageState extends State<AddSuiviPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  String? _selectedType;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: Localizations.localeOf(context),
      confirmText: loc.saveButton,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<ParcelleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.addSuivi, style: AppTextStyles.heading2),
        actions: [AudioToggle(instructions: loc.suiviAudio)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: loc.suiviTypeLabel,
                  icon: Icon(Icons.task_alt, color: AppColors.primary),
                ),
                value: _selectedType,
                items: [
                  DropdownMenuItem(value: 'Irrigation', child: Text(loc.suiviTypeIrrigation)),
                  DropdownMenuItem(value: 'Fertilisation', child: Text(loc.suiviTypeFertilisation)),
                  DropdownMenuItem(value: 'Traitement phytosanitaire', child: Text(loc.suiviTypePhytosanitaire)),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return loc.formError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: loc.suiviDateLabel,
                    icon: Icon(Icons.calendar_today, color: AppColors.primary),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? loc.suiviDateLabel
                        : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ),
              if (_selectedDate == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(loc.formError, style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: loc.suiviNotesLabel,
                  icon: Icon(Icons.note, color: AppColors.primary),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              provider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && _selectedDate != null) {
                          bool success = await provider.addSuivi(
                            widget.cultureId,
                            _selectedType!,
                            DateFormat('yyyy-MM-dd').format(_selectedDate!),
                            _notesController.text.isEmpty ? null : _notesController.text,
                          );
                          if (success) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(provider.errorMessage ?? 'Erreur')),
                            );
                          }
                        }
                      },
                      child: Text(loc.saveButton),
                    ),
              if (provider.isOffline)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    loc.offlineMessage,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}