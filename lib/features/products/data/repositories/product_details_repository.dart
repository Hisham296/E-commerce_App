import '../datasources/product_details_data_source.dart';
import '../datasources/product_review_cache_data_source.dart';
import '../models/product_model.dart';
import '../models/product_review_model.dart';

class ProductDetailsRepository {
  final ProductDetailsDataSource dataSource;
  final ProductReviewCacheDataSource reviewCacheDataSource;

  ProductDetailsRepository({
    required this.dataSource,
    required this.reviewCacheDataSource,
  });

  Future<ProductModel> getProductDetails(String id) {
    return dataSource.getProductDetails(id);
  }

  Future<List<ProductReview>> getCachedReviews(String productId) {
    return reviewCacheDataSource.getReviews(productId);
  }

  Future<void> saveReview(String productId, ProductReview review) {
    return reviewCacheDataSource.saveReview(productId, review);
  }
}
