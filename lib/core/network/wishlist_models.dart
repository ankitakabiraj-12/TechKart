class WishlistItemModel {
  final int wishlistItemId;
  final int productId;
  final int sellerId;
  final String sellerStoreName;
  final String categoryName;
  final String title;
  final String slug;
  final String description;
  final String? primaryImageUrl;
  final double price;
  final double? mrp;
  final int stockQuantity;
  final bool isInStock;
  final bool isLowStock;
  final bool hasPriceDrop;
  final String savedAt;

  WishlistItemModel({
    required this.wishlistItemId,
    required this.productId,
    required this.sellerId,
    required this.sellerStoreName,
    required this.categoryName,
    required this.title,
    required this.slug,
    required this.description,
    this.primaryImageUrl,
    required this.price,
    this.mrp,
    required this.stockQuantity,
    required this.isInStock,
    required this.isLowStock,
    required this.hasPriceDrop,
    required this.savedAt,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      wishlistItemId: json['wishlist_item_id'] is int ? json['wishlist_item_id'] : int.tryParse(json['wishlist_item_id']?.toString() ?? '0') ?? 0,
      productId: json['product_id'] is int ? json['product_id'] : int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      sellerId: json['seller_id'] is int ? json['seller_id'] : int.tryParse(json['seller_id']?.toString() ?? '0') ?? 0,
      sellerStoreName: json['seller_store_name'] as String? ?? 'Authorized Seller',
      categoryName: json['category_name'] as String? ?? 'Electronics',
      title: json['title'] as String? ?? 'Product',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      primaryImageUrl: json['primary_image_url'] as String?,
      price: json['price'] != null ? (double.tryParse(json['price'].toString()) ?? 0.0) : 0.0,
      mrp: json['mrp'] != null ? double.tryParse(json['mrp'].toString()) : null,
      stockQuantity: json['stock_quantity'] is int ? json['stock_quantity'] : int.tryParse(json['stock_quantity']?.toString() ?? '0') ?? 0,
      isInStock: json['is_in_stock'] as bool? ?? true,
      isLowStock: json['is_low_stock'] as bool? ?? false,
      hasPriceDrop: json['has_price_drop'] as bool? ?? false,
      savedAt: json['saved_at'] as String? ?? '',
    );
  }
}

class WishlistSummaryModel {
  final int totalItems;
  final int inStockCount;
  final int priceDropCount;

  WishlistSummaryModel({
    required this.totalItems,
    required this.inStockCount,
    required this.priceDropCount,
  });

  factory WishlistSummaryModel.fromJson(Map<String, dynamic> json) {
    return WishlistSummaryModel(
      totalItems: json['total_items'] is int ? json['total_items'] : int.tryParse(json['total_items']?.toString() ?? '0') ?? 0,
      inStockCount: json['in_stock_count'] is int ? json['in_stock_count'] : int.tryParse(json['in_stock_count']?.toString() ?? '0') ?? 0,
      priceDropCount: json['price_drop_count'] is int ? json['price_drop_count'] : int.tryParse(json['price_drop_count']?.toString() ?? '0') ?? 0,
    );
  }
}

class WishlistDataModel {
  final List<WishlistItemModel> items;
  final WishlistSummaryModel summary;

  WishlistDataModel({
    required this.items,
    required this.summary,
  });

  factory WishlistDataModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];
    final items = rawItems.map((e) => WishlistItemModel.fromJson(e as Map<String, dynamic>)).toList();
    final summary = WishlistSummaryModel.fromJson(json['summary'] as Map<String, dynamic>? ?? {});

    return WishlistDataModel(
      items: items,
      summary: summary,
    );
  }
}
