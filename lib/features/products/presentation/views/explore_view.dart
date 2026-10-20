import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/product_card.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductsCubit>()..fetchProducts(),
      child: const _ExploreContent(),
    );
  }
}

class _ExploreContent extends StatefulWidget {
  const _ExploreContent();

  @override
  State<_ExploreContent> createState() => _ExploreContentState();
}

class _ExploreContentState extends State<_ExploreContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore', style: context.textStyles.heading4),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(context.spacing.md),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Product',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state.status == ProductsStatus.loading &&
                      state.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == ProductsStatus.error &&
                      state.products.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(context.spacing.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: context.spacing.md),
                            Text(
                              state.errorMessage ?? 'Failed to load products.',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: context.spacing.md),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ProductsCubit>().fetchProducts();
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final products = state.products.where((product) {
                    if (_searchQuery.isEmpty) return true;

                    return product.name.toLowerCase().contains(_searchQuery) ||
                        product.category.toLowerCase().contains(_searchQuery) ||
                        product.brand.toLowerCase().contains(_searchQuery);
                  }).toList();

                  if (products.isEmpty) {
                    return Center(
                      child: Text(
                        'No products found.',
                        style: context.textStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.all(context.spacing.md),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.responsive(
                        mobile: 2,
                        tablet: 4,
                        desktop: 6,
                      ),
                      mainAxisSpacing: context.spacing.md,
                      crossAxisSpacing: context.spacing.md,
                      childAspectRatio: context.responsive(
                        mobile: 0.65,
                        tablet: 0.7,
                        desktop: 0.75,
                      ),
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
