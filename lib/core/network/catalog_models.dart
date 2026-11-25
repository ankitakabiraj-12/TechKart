class ProductVariantModel {
  final int id;
  final int productId;
  final String variantName;
  final String sku;
  final String? colour;
  final String? ram;
  final String? storage;
  final String? configuration;
  final Map<String, dynamic>? variantAttributes;
  final int? listingId;
  final double? mrp;
  final double? sellingPrice;
  final int stockQuantity;
  final String? dispatchInformation;
  final String? shippingInformation;
  final String listingStatus;

  ProductVariantModel({
    required this.id,
    required this.productId,
    required this.variantName,
    required this.sku,
    this.colour,
    this.ram,
    this.storage,
    this.configuration,
    this.variantAttributes,
    this.listingId,
    this.mrp,
    this.sellingPrice,
    this.stockQuantity = 0,
    this.dispatchInformation,
    this.shippingInformation,
    this.listingStatus = 'active',
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: json['product_id'] is int ? json['product_id'] : int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      variantName: json['variant_name'] as String? ?? 'Standard',
      sku: json['sku'] as String? ?? '',
      colour: json['colour'] as String?,
      ram: json['ram'] as String?,
      storage: json['storage'] as String?,
      configuration: json['configuration'] as String?,
      variantAttributes: json['variant_attributes'] is Map ? Map<String, dynamic>.from(json['variant_attributes'] as Map) : null,
      listingId: json['listing_id'] != null ? int.tryParse(json['listing_id'].toString()) : null,
      mrp: json['mrp'] != null ? double.tryParse(json['mrp'].toString()) : null,
      sellingPrice: json['selling_price'] != null ? double.tryParse(json['selling_price'].toString()) : null,
      stockQuantity: json['stock_quantity'] is int ? json['stock_quantity'] : int.tryParse(json['stock_quantity']?.toString() ?? '0') ?? 0,
      dispatchInformation: json['dispatch_information'] as String?,
      shippingInformation: json['shipping_information'] as String?,
      listingStatus: json['listing_status'] as String? ?? 'active',
    );
  }
}

class ProductSpecificationModel {
  final String attributeName;
  final String attributeKey;
  final String? unit;
  final String attributeValue;

  ProductSpecificationModel({
    required this.attributeName,
    required this.attributeKey,
    this.unit,
    required this.attributeValue,
  });

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) {
    return ProductSpecificationModel(
      attributeName: json['attribute_name'] as String? ?? 'Specification',
      attributeKey: json['attribute_key'] as String? ?? '',
      unit: json['unit'] as String?,
      attributeValue: json['attribute_value'] as String? ?? '',
    );
  }
}

class BrandModel {
  final int id;
  final String brandName;
  final String brandSlug;
  final String? officialWebsite;
  final String? brandLogo;
  final String verificationStatus;

  BrandModel({
    required this.id,
    required this.brandName,
    required this.brandSlug,
    this.officialWebsite,
    this.brandLogo,
    this.verificationStatus = 'verified',
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      brandName: json['brand_name'] as String? ?? '',
      brandSlug: json['brand_slug'] as String? ?? '',
      officialWebsite: json['official_website'] as String?,
      brandLogo: json['brand_logo'] as String?,
      verificationStatus: json['verification_status'] as String? ?? 'verified',
    );
  }
}

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
  final DateTime? publishedAt;
  final String? categoryName;
  final String? categorySlug;
  final int? subcategoryId;
  final String? subcategoryName;
  final String? subcategorySlug;
  final String? sellerStoreName;
  final String? primaryImageUrl;
  final List<String> images;
  final String? brandName;
  final String? brandSlug;
  final String? brandLogo;
  final String? modelNumber;
  final String? manufacturer;
  final String? countryOfOrigin;
  final String? warrantyInformation;
  final String? gtinUpcEan;
  final List<ProductVariantModel> variants;
  final List<ProductSpecificationModel> specifications;

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
    this.publishedAt,
    this.categoryName,
    this.categorySlug,
    this.subcategoryName,
    this.subcategorySlug,
    this.sellerStoreName,
    this.primaryImageUrl,
    this.images = const [],
    this.brandName,
    this.brandSlug,
    this.brandLogo,
    this.modelNumber,
    this.manufacturer,
    this.countryOfOrigin,
    this.warrantyInformation,
    this.gtinUpcEan,
    this.variants = const [],
    this.specifications = const [],
  });

  bool get isNewArrival {
    if (publishedAt == null) return false;
    final diff = DateTime.now().difference(publishedAt!);
    return diff.inDays >= 0 && diff.inDays < 7;
  }

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

    DateTime? pubDate;
    if (json['published_at'] != null && json['published_at'].toString().isNotEmpty) {
      pubDate = DateTime.tryParse(json['published_at'].toString());
    }

    List<ProductVariantModel> parsedVariants = [];
    if (json['variants'] is List) {
      for (final v in json['variants']) {
        if (v is Map) {
          parsedVariants.add(ProductVariantModel.fromJson(Map<String, dynamic>.from(v)));
        }
      }
    }

    List<ProductSpecificationModel> parsedSpecs = [];
    if (json['specifications'] is List) {
      for (final s in json['specifications']) {
        if (s is Map) {
          parsedSpecs.add(ProductSpecificationModel.fromJson(Map<String, dynamic>.from(s)));
        }
      }
    }

    return ProductModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
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
      publishedAt: pubDate,
      categoryName: json['category_name'] as String?,
      categorySlug: json['category_slug'] as String?,
      subcategoryName: json['subcategory_name'] as String?,
      subcategorySlug: json['subcategory_slug'] as String?,
      sellerStoreName: json['seller_store_name'] as String?,
      primaryImageUrl: json['primary_image_url'] as String?,
      images: imgUrls,
      brandName: json['brand_name'] as String?,
      brandSlug: json['brand_slug'] as String?,
      brandLogo: json['brand_logo'] as String?,
      modelNumber: json['model_number'] as String?,
      manufacturer: json['manufacturer'] as String?,
      countryOfOrigin: json['country_of_origin'] as String?,
      warrantyInformation: json['warranty_information'] as String?,
      gtinUpcEan: json['gtin_upc_ean'] as String?,
      variants: parsedVariants,
      specifications: parsedSpecs,
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
  final int? productCount;
  final List<CategoryModel>? subcategories;

  CategoryModel({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    this.imageUrl,
    this.displayOrder,
    this.productCount,
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
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      parentId: json['parent_id'] != null ? int.tryParse(json['parent_id'].toString()) : null,
      name: json['name'] as String? ?? 'Category',
      slug: json['slug'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      displayOrder: json['display_order'] != null ? int.tryParse(json['display_order'].toString()) : null,
      productCount: json['product_count'] != null ? int.tryParse(json['product_count'].toString()) : null,
      subcategories: subs,
    );
  }
}
