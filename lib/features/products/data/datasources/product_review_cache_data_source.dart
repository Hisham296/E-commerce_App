import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_review_model.dart';

class ProductReviewCacheDataSource {
  final SharedPreferences sharedPreferences;

  ProductReviewCacheDataSource({required this.sharedPreferences});

  String _key(String productId) => 'product_reviews_$productId';

  Future<List<ProductReview>> getReviews(String productId) async {
    final jsonString = sharedPreferences.getString(_key(productId));

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonString);

      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map(
            (item) => ProductReview.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveReview(String productId, ProductReview review) async {
    final reviews = await getReviews(productId);
    reviews.add(review);

    final encoded = jsonEncode(reviews.map((item) => item.toJson()).toList());

    final saved = await sharedPreferences.setString(_key(productId), encoded);

    if (!saved) {
      throw Exception('Failed to save review locally.');
    }
  }
}
