import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:teranga_agro/features/parcelle/domain/entities/culture.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/parcelle_provider.dart';
import '../widgets/audio_toggle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCulturePage extends StatefulWidget {
  final int parcelleId;
  final Culture? culture; // For editing

  const AddCulturePage({super.key, required this.parcelleId, this.culture});

  @override
  _AddCulturePageState createState() => _AddCulturePageState();
}

class _AddCulturePageState extends State<AddCulturePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  String? _selectedType;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.culture != null) {
      _nomController.text = widget.culture!.nom;
      _selectedType = widget.culture!.type;
      _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.culture!.datePlantation);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<ParcelleProvider>(context);
    final isEditing = widget.culture != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isEditing ? loc.editCulture : loc.addCulture, 
          style: AppTextStyles.heading2.copyWith(color: Colors.white)
        ),
        actions: [AudioToggle(instructions: loc.cultureAudio)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Entête décoratif
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.grass,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      isEditing ? loc.editCulture : loc.addCulture,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Formulaire dans une Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? loc.editCulture : loc.addCulture,
                          style: AppTextStyles.heading3,
                        ),
                        SizedBox(height: 24),
                        // Champ Nom
                        TextFormField(
                          controller: _nomController,
                          decoration: InputDecoration(
                            labelText: loc.cultureNomLabel,
                            hintText: "Exemple: Mil",
                            prefixIcon: Icon(Icons.local_florist, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.formError;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Type de culture
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: loc.cultureTypeLabel,
                            prefixIcon: Icon(Icons.category, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          value: _selectedType,
                          items: [
                            DropdownMenuItem(value: 'Céréale', child: Text(loc.cultureTypeCereale)),
                            DropdownMenuItem(value: 'Légumineuse', child: Text(loc.cultureTypeLegumineuse)),
                            DropdownMenuItem(value: 'Tubercule', child: Text(loc.cultureTypeTubercule)),
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
                          icon: Icon(Icons.arrow_drop_down_circle, color: AppColors.primary),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                        ),
                        SizedBox(height: 24),
                        // Date de plantation
                        Text(
                          loc.cultureDateLabel,
                          style: AppTextStyles.heading3.copyWith(fontSize: 16),
                        ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedDate == null ? Colors.red : Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _selectedDate == null
                                        ? loc.cultureDatePlaceholder ?? "Sélectionnez une date"
                                        : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: _selectedDate == null ? Colors.grey : Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_selectedDate == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 12),
                            child: Text(
                              loc.formError,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (provider.isOffline)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          loc.offlineMessage,
                          style: TextStyle(color: Colors.red[700], fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: provider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && _selectedDate != null) {
                          setState(() {
                            _isLoading = true;
                          });
                          
                          bool success;
                          if (isEditing) {
                            success = await provider.updateCulture(
                              Culture(
                                id: widget.culture!.id,
                                parcelleId: widget.parcelleId,
                                nom: _nomController.text,
                                type: _selectedType!,
                                datePlantation: DateFormat('yyyy-MM-dd').format(_selectedDate!),
                              ),
                            );
                          } else {
                            success = await provider.addCulture(
                              widget.parcelleId,
                              _nomController.text,
                              _selectedType!,
                              DateFormat('yyyy-MM-dd').format(_selectedDate!),
                            );
                          }
                          
                          setState(() {
                            _isLoading = false;
                          });
                          
                          if (success) {
                            Navigator.pop(context);
                          } else {
                            _showSnackBar(provider.errorMessage ?? 'Erreur');
                          }
                        } else if (_selectedDate == null) {
                          _showSnackBar(loc.dateRequired ?? "Veuillez sélectionner une date");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        loc.saveButton,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}