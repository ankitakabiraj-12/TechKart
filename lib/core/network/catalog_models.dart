class ProductModel {
  final int id;
  final int sellerId;
  final int categoryId;
  final String title;
  final String slug;
  final String? description;
  final double price;
  final double? mrp;
  final int stockQuantity;
  final String status;
  final String? categoryName;
  final String? categorySlug;
  final int? subcategoryId;
  final String? subcategoryName;
  final String? subcategorySlug;
  final String? sellerStoreName;
  final String? primaryImageUrl;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.sellerId,
    required this.categoryId,
    this.subcategoryId,
    required this.title,
    required this.slug,
    this.description,
    required this.price,
    this.mrp,
    required this.stockQuantity,
    required this.status,
    this.categoryName,
    this.categorySlug,
    this.subcategoryName,
    this.subcategorySlug,
    this.sellerStoreName,
    this.primaryImageUrl,
    this.images = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<String> imgUrls = [];
    if (json['images'] is List) {
      for (final item in json['images']) {
        if (item is Map && item['image_url'] != null) {
          imgUrls.add(item['image_url'].toString());
        } else if (item is String) {
          imgUrls.add(item);
        }
      }
    }

    return ProductModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      sellerId: json['seller_id'] is int ? json['seller_id'] : int.tryParse(json['seller_id']?.toString() ?? '0') ?? 0,
      categoryId: json['category_id'] is int ? json['category_id'] : int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      subcategoryId: json['subcategory_id'] != null ? int.tryParse(json['subcategory_id'].toString()) : null,
      title: json['title'] as String? ?? 'Untitled Product',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      price: json['price'] != null ? (double.tryParse(json['price'].toString()) ?? 0.0) : 0.0,
      mrp: json['mrp'] != null ? double.tryParse(json['mrp'].toString()) : null,
      stockQuantity: json['stock_quantity'] is int ? json['stock_quantity'] : int.tryParse(json['stock_quantity']?.toString() ?? '0') ?? 0,
      status: json['status'] as String? ?? 'published',
      categoryName: json['category_name'] as String?,
      categorySlug: json['category_slug'] as String?,
      subcategoryName: json['subcategory_name'] as String?,
      subcategorySlug: json['subcategory_slug'] as String?,
      sellerStoreName: json['seller_store_name'] as String?,
      primaryImageUrl: json['primary_image_url'] as String?,
      images: imgUrls,
    );
  }
}

class CategoryModel {
  final int id;
  final int? parentId;
  final String name;
  final String slug;
  final String? imageUrl;
  final int? displayOrder;
  final List<CategoryModel>? subcategories;

  CategoryModel({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    this.imageUrl,
    this.displayOrder,
    this.subcategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<CategoryModel>? subs;
    if (json['subcategories'] is List) {
      subs = (json['subcategories'] as List)
          .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    return CategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      parentId: json['parent_id'] != null ? int.tryParse(json['parent_id'].toString()) : null,
      name: json['name'] as String? ?? 'Category',
      slug: json['slug'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      displayOrder: json['display_order'] != null ? int.tryParse(json['display_order'].toString()) : null,
      subcategories: subs,
    );
  }
}
