class ProductReview {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;
  final bool isLocal;

  const ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    this.reviewerEmail = '',
    this.isLocal = false,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      rating: _toInt(json['rating']).clamp(1, 5).toInt(),
      comment: json['comment']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      reviewerName: json['reviewerName']?.toString() ?? 'Anonymous',
      reviewerEmail: json['reviewerEmail']?.toString() ?? '',
      isLocal: json['isLocal'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date,
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
      'isLocal': isLocal,
    };
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
