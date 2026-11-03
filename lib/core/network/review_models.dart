class RatingBreakdownItem {
  final int stars;
  final int count;
  final double percentage;

  RatingBreakdownItem({
    required this.stars,
    required this.count,
    required this.percentage,
  });

  factory RatingBreakdownItem.fromJson(Map<String, dynamic> json) {
    return RatingBreakdownItem(
      stars: json['stars'] is int ? json['stars'] : int.tryParse(json['stars']?.toString() ?? '0') ?? 0,
      count: json['count'] is int ? json['count'] : int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      percentage: json['percentage'] != null ? (double.tryParse(json['percentage'].toString()) ?? 0.0) : 0.0,
    );
  }
}

class RatingSummaryModel {
  final double averageRating;
  final int totalReviews;
  final int recommendPercentage;
  final Map<int, RatingBreakdownItem> distribution;

  RatingSummaryModel({
    required this.averageRating,
    required this.totalReviews,
    required this.recommendPercentage,
    required this.distribution,
  });

  factory RatingSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawDist = json['distribution'] as Map<String, dynamic>? ?? {};
    final distMap = <int, RatingBreakdownItem>{};
    for (int i = 1; i <= 5; i++) {
      if (rawDist.containsKey(i.toString())) {
        distMap[i] = RatingBreakdownItem.fromJson(rawDist[i.toString()] as Map<String, dynamic>);
      } else {
        distMap[i] = RatingBreakdownItem(stars: i, count: 0, percentage: 0.0);
      }
    }

    return RatingSummaryModel(
      averageRating: json['average_rating'] != null ? (double.tryParse(json['average_rating'].toString()) ?? 0.0) : 0.0,
      totalReviews: json['total_reviews'] is int ? json['total_reviews'] : int.tryParse(json['total_reviews']?.toString() ?? '0') ?? 0,
      recommendPercentage: json['recommend_percentage'] is int ? json['recommend_percentage'] : int.tryParse(json['recommend_percentage']?.toString() ?? '0') ?? 0,
      distribution: distMap,
    );
  }
}

class ReviewEligibilityModel {
  final bool isAuthenticated;
  final bool isVerifiedBuyer;
  final bool hasReviewed;
  final Map<String, dynamic>? userReview;

  ReviewEligibilityModel({
    required this.isAuthenticated,
    required this.isVerifiedBuyer,
    required this.hasReviewed,
    this.userReview,
  });

  factory ReviewEligibilityModel.fromJson(Map<String, dynamic> json) {
    return ReviewEligibilityModel(
      isAuthenticated: json['is_authenticated'] as bool? ?? false,
      isVerifiedBuyer: json['is_verified_buyer'] as bool? ?? false,
      hasReviewed: json['has_reviewed'] as bool? ?? false,
      userReview: json['user_review'] as Map<String, dynamic>?,
    );
  }
}

class ProductReviewItemModel {
  final int id;
  final int productId;
  final int customerId;
  final String customerName;
  final String initials;
  final String? customerAvatar;
  final int rating;
  final String title;
  final String reviewText;
  final List<String> standoutTags;
  final List<String> photos;
  final String variantText;
  final bool wouldRecommend;
  final bool isVerifiedPurchase;
  final int helpfulCount;
  final bool hasVotedHelpful;
  final String createdAt;

  ProductReviewItemModel({
    required this.id,
    required this.productId,
    required this.customerId,
    required this.customerName,
    required this.initials,
    this.customerAvatar,
    required this.rating,
    required this.title,
    required this.reviewText,
    required this.standoutTags,
    required this.photos,
    required this.variantText,
    required this.wouldRecommend,
    required this.isVerifiedPurchase,
    required this.helpfulCount,
    required this.hasVotedHelpful,
    required this.createdAt,
  });

  factory ProductReviewItemModel.fromJson(Map<String, dynamic> json) {
    final rawTags = json['standout_tags'] as List? ?? [];
    final tags = rawTags.map((e) => e.toString()).toList();

    final rawPhotos = json['photos'] as List? ?? [];
    final photos = rawPhotos.map((e) => e.toString()).toList();

    return ProductReviewItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: json['product_id'] is int ? json['product_id'] : int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      customerId: json['customer_id'] is int ? json['customer_id'] : int.tryParse(json['customer_id']?.toString() ?? '0') ?? 0,
      customerName: json['customer_name'] as String? ?? 'Verified Buyer',
      initials: json['initials'] as String? ?? 'VB',
      customerAvatar: json['customer_avatar'] as String?,
      rating: json['rating'] is int ? json['rating'] : int.tryParse(json['rating']?.toString() ?? '5') ?? 5,
      title: json['title'] as String? ?? '',
      reviewText: json['review_text'] as String? ?? '',
      standoutTags: tags,
      photos: photos,
      variantText: json['variant_text'] as String? ?? 'Grade 5 Titanium • 49mm Cellular',
      wouldRecommend: json['would_recommend'] as bool? ?? true,
      isVerifiedPurchase: json['is_verified_purchase'] as bool? ?? true,
      helpfulCount: json['helpful_count'] is int ? json['helpful_count'] : int.tryParse(json['helpful_count']?.toString() ?? '0') ?? 0,
      hasVotedHelpful: json['has_voted_helpful'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  ProductReviewItemModel copyWith({
    int? helpfulCount,
    bool? hasVotedHelpful,
  }) {
    return ProductReviewItemModel(
      id: id,
      productId: productId,
      customerId: customerId,
      customerName: customerName,
      initials: initials,
      customerAvatar: customerAvatar,
      rating: rating,
      title: title,
      reviewText: reviewText,
      standoutTags: standoutTags,
      photos: photos,
      variantText: variantText,
      wouldRecommend: wouldRecommend,
      isVerifiedPurchase: isVerifiedPurchase,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      hasVotedHelpful: hasVotedHelpful ?? this.hasVotedHelpful,
      createdAt: createdAt,
    );
  }
}

class ProductReviewsDataModel {
  final Map<String, dynamic> product;
  final RatingSummaryModel summary;
  final ReviewEligibilityModel eligibility;
  final List<ProductReviewItemModel> reviews;

  ProductReviewsDataModel({
    required this.product,
    required this.summary,
    required this.eligibility,
    required this.reviews,
  });

  factory ProductReviewsDataModel.fromJson(Map<String, dynamic> json) {
    final rawReviews = json['reviews'] as List? ?? [];
    final reviews = rawReviews.map((e) => ProductReviewItemModel.fromJson(e as Map<String, dynamic>)).toList();

    return ProductReviewsDataModel(
      product: json['product'] as Map<String, dynamic>? ?? {},
      summary: RatingSummaryModel.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
      eligibility: ReviewEligibilityModel.fromJson(json['eligibility'] as Map<String, dynamic>? ?? {}),
      reviews: reviews,
    );
  }
}
