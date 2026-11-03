class CartItemModel {
  final int cartItemId;
  final int productId;
  final int sellerId;
  final String sellerStoreName;
  final String? categoryName;
  final String title;
  final String slug;
  final String? primaryImageUrl;
  final double unitPrice;
  final double? mrp;
  final int quantity;
  final double lineTotal;
  final int stockQuantity;
  final bool isInStock;
  final bool isAvailable;
  final bool isQuantityAvailable;
  final String addedAt;

  CartItemModel({
    required this.cartItemId,
    required this.productId,
    required this.sellerId,
    required this.sellerStoreName,
    this.categoryName,
    required this.title,
    required this.slug,
    this.primaryImageUrl,
    required this.unitPrice,
    this.mrp,
    required this.quantity,
    required this.lineTotal,
    required this.stockQuantity,
    required this.isInStock,
    required this.isAvailable,
    required this.isQuantityAvailable,
    required this.addedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartItemId: json['cart_item_id'] is int ? json['cart_item_id'] : int.tryParse(json['cart_item_id']?.toString() ?? '0') ?? 0,
      productId: json['product_id'] is int ? json['product_id'] : int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      sellerId: json['seller_id'] is int ? json['seller_id'] : int.tryParse(json['seller_id']?.toString() ?? '0') ?? 0,
      sellerStoreName: json['seller_store_name'] as String? ?? 'Authorized Seller',
      categoryName: json['category_name'] as String?,
      title: json['title'] as String? ?? 'Product',
      slug: json['slug'] as String? ?? '',
      primaryImageUrl: json['primary_image_url'] as String?,
      unitPrice: json['unit_price'] != null ? (double.tryParse(json['unit_price'].toString()) ?? 0.0) : 0.0,
      mrp: json['mrp'] != null ? double.tryParse(json['mrp'].toString()) : null,
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      lineTotal: json['line_total'] != null ? (double.tryParse(json['line_total'].toString()) ?? 0.0) : 0.0,
      stockQuantity: json['stock_quantity'] is int ? json['stock_quantity'] : int.tryParse(json['stock_quantity']?.toString() ?? '0') ?? 0,
      isInStock: json['is_in_stock'] as bool? ?? true,
      isAvailable: json['is_available'] as bool? ?? true,
      isQuantityAvailable: json['is_quantity_available'] as bool? ?? true,
      addedAt: json['added_at'] as String? ?? '',
    );
  }
}

class CartSummaryModel {
  final int totalUniqueItems;
  final int totalQuantity;
  final double subtotal;
  final double totalMrp;
  final double totalDiscount;
  final String currency;
  final bool hasUnavailableItems;

  CartSummaryModel({
    required this.totalUniqueItems,
    required this.totalQuantity,
    required this.subtotal,
    required this.totalMrp,
    required this.totalDiscount,
    required this.currency,
    required this.hasUnavailableItems,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    return CartSummaryModel(
      totalUniqueItems: json['total_unique_items'] is int ? json['total_unique_items'] : int.tryParse(json['total_unique_items']?.toString() ?? '0') ?? 0,
      totalQuantity: json['total_quantity'] is int ? json['total_quantity'] : int.tryParse(json['total_quantity']?.toString() ?? '0') ?? 0,
      subtotal: json['subtotal'] != null ? (double.tryParse(json['subtotal'].toString()) ?? 0.0) : 0.0,
      totalMrp: json['total_mrp'] != null ? (double.tryParse(json['total_mrp'].toString()) ?? 0.0) : 0.0,
      totalDiscount: json['total_discount'] != null ? (double.tryParse(json['total_discount'].toString()) ?? 0.0) : 0.0,
      currency: json['currency'] as String? ?? 'INR',
      hasUnavailableItems: json['has_unavailable_items'] as bool? ?? false,
    );
  }
}

class CartDataModel {
  final List<CartItemModel> items;
  final CartSummaryModel summary;

  CartDataModel({
    required this.items,
    required this.summary,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];
    final items = rawItems.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList();
    final summary = CartSummaryModel.fromJson(json['summary'] as Map<String, dynamic>? ?? {});

    return CartDataModel(
      items: items,
      summary: summary,
    );
  }
}
