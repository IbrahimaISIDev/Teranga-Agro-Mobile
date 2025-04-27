import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/product.dart';
import '../providers/marketplace_provider.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _quantity;
  late double _price;
  late String _status;

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _quantity = widget.product.quantity;
    _price = widget.product.price;
    _status = widget.product.status;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<MarketplaceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.editProduct),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/marketplace'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.productName, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    hintText: loc.enterProductName,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.requiredField;
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                const SizedBox(height: 16),

                Text(loc.quantityKg, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                TextFormField(
                  initialValue: _quantity.toString(),
                  decoration: InputDecoration(
                    hintText: loc.enterQuantity,
                    border: const OutlineInputBorder(),
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
                  onSaved: (value) => _quantity = double.parse(value!),
                ),
                const SizedBox(height: 16),

                Text(loc.priceFcfaKg, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                TextFormField(
                  initialValue: _price.toString(),
                  decoration: InputDecoration(
                    hintText: loc.enterPrice,
                    border: const OutlineInputBorder(),
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
                  onSaved: (value) => _price = double.parse(value!),
                ),
                const SizedBox(height: 16),

                Text(loc.status, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
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
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.go('/marketplace'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      child: Text(loc.cancel),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final product = Product(
                            id: widget.product.id,
                            name: _name,
                            quantity: _quantity,
                            price: _price,
                            status: _status,
                          );
                          final success = await provider.updateProduct(product);
                          if (success) {
                            context.go('/marketplace');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(provider.errorMessage ?? loc.errorSavingProduct)),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text(loc.save),
                    ),
                  ],
                ),

                if (provider.isOffline)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(loc.offlineMessage, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}