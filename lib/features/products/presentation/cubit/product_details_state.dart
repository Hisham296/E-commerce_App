import '../../data/models/product_model.dart';
import '../../data/models/product_review_model.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsSuccess extends ProductDetailsState {
  final ProductModel product;
  final List<ProductReview> cachedReviews;

  ProductDetailsSuccess(this.product, {this.cachedReviews = const []});
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  ProductDetailsError(this.message);
}
