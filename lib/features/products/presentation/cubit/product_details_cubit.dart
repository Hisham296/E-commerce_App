import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_review_model.dart';
import '../../data/repositories/product_details_repository.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductDetailsRepository repository;

  ProductDetailsCubit({required this.repository})
    : super(ProductDetailsInitial());

  Future<void> fetchProductDetails(String id) async {
    emit(ProductDetailsLoading());

    try {
      final product = await repository.getProductDetails(id);
      final cachedReviews = await repository.getCachedReviews(id);

      emit(ProductDetailsSuccess(product, cachedReviews: cachedReviews));
    } catch (_) {
      emit(
        ProductDetailsError(
          'Failed to load product details. Please try again.',
        ),
      );
    }
  }

  Future<void> addReview({
    required String reviewerName,
    required String comment,
    required int rating,
  }) async {
    final currentState = state;

    if (currentState is! ProductDetailsSuccess) return;

    final name = reviewerName.trim();
    final reviewComment = comment.trim();

    if (name.isEmpty || reviewComment.isEmpty) {
      throw ArgumentError('Name and comment are required.');
    }

    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5.');
    }

    final review = ProductReview(
      rating: rating,
      comment: reviewComment,
      reviewerName: name,
      date: DateTime.now().toIso8601String(),
      isLocal: true,
    );

    await repository.saveReview(currentState.product.id, review);

    if (isClosed) return;

    emit(
      ProductDetailsSuccess(
        currentState.product,
        cachedReviews: [...currentState.cachedReviews, review],
      ),
    );
  }
}
