import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/product.dart';
import '../providers/marketplace_provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  String _status = 'En vente';

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
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<MarketplaceProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(loc.addProduct, style: AppTextStyles.heading3.copyWith(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/marketplace'),
        ),
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
                      Icons.shopping_basket,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      loc.addProduct,
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
                          loc.addProduct,
                          style: AppTextStyles.heading3,
                        ),
                        SizedBox(height: 24),
                        
                        // Champ Nom du produit
                        Text(loc.productName, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: loc.enterProductName,
                            prefixIcon: Icon(Icons.shopping_bag, color: AppColors.primary),
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
                              return loc.requiredField;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Champ Quantité
                        Text(loc.quantityKg, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(
                            hintText: loc.enterQuantity,
                            prefixIcon: Icon(Icons.scale, color: AppColors.primary),
                            suffixText: "Kg",
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.requiredField;
                            }
                            if (double.tryParse(value) == null || double.parse(value) <= 0) {
                              return loc.invalidQuantity;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Champ Prix
                        Text(loc.priceFcfaKg, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            hintText: loc.enterPrice,
                            prefixIcon: Icon(Icons.monetization_on, color: AppColors.primary),
                            suffixText: "FCFA/Kg",
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.requiredField;
                            }
                            if (double.tryParse(value) == null || double.parse(value) <= 0) {
                              return loc.invalidPrice;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Champ Statut
                        Text(loc.status, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                            color: Colors.grey[50],
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _status,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.category, color: AppColors.primary),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            items: ['En vente', 'Suspendu'].map((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _status = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return loc.requiredField;
                              }
                              return null;
                            },
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
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
              Row(
                children: [
                  // Bouton Annuler
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => context.go('/marketplace'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey[800],
                          backgroundColor: Colors.grey[200],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          loc.cancel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Bouton Enregistrer
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final product = Product(
                              id: 0, // ID sera assigné par la base de données
                              name: _nameController.text,
                              quantity: double.parse(_quantityController.text),
                              price: double.parse(_priceController.text),
                              status: _status,
                            );
                            final success = await provider.addProduct(product);
                            if (success) {
                              context.go('/marketplace');
                            } else {
                              _showSnackBar(provider.errorMessage ?? loc.errorSavingProduct);
                            }
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
                          loc.save,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}