import 'package:flutter/material.dart';
import 'package:teranga_agro/features/marketplace/domain/entities/product.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class FeaturedProductsSlider extends StatelessWidget {
  final List<Product> products;
  final String title;

  const FeaturedProductsSlider({
    Key? key,
    required this.products,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.heading3),
        SizedBox(height: 12),
        Container(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length > 5 ? 5 : products.length,
            itemBuilder: (context, index) {
              return _buildFeaturedProductCard(products[index]);
            },
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFeaturedProductCard(Product product) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: product.imageUrl != null 
                      ? NetworkImage(product.imageUrl!) 
                      : AssetImage('assets/images/tomates.png') as ImageProvider,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${product.price} FCFA',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}