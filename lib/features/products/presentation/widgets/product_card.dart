import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../views/product_details_view.dart';
import '../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final discountPercent = product.price > 0
        ? ((product.price - product.discountPrice) / product.price * 100)
              .round()
        : 0;

    return Material(
      color: AppColors.background,
      borderRadius: AppRadius.card,
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ProductDetailsView(productId: product.id),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(context.spacing.sm),
          decoration: BoxDecoration(
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadius.card,
                  child: SizedBox(
                    width: double.infinity,
                    child:
                        product.imageUrl.isEmpty ||
                            product.imageUrl == 'placeholder'
                        ? Container(
                            color: AppColors.surface,
                            child: const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 50,
                                color: AppColors.border,
                              ),
                            ),
                          )
                        : Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.surface,
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 50,
                                  color: AppColors.border,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: context.spacing.sm),
              Text(
                product.name,
                style: context.textStyles.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.spacing.xs),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.star, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: context.textStyles.title,
                  ),
                ],
              ),
              SizedBox(height: context.spacing.xs),
              Text(
                '\$${product.discountPrice.toStringAsFixed(2)}',
                style: context.textStyles.price,
              ),
              SizedBox(height: context.spacing.xs),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: context.textStyles.oldPrice,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: context.spacing.xs),
                  Flexible(
                    child: Text(
                      '$discountPercent% Off',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.discount,
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
