class AddressModel {
  final int id;
  final String label;
  final String recipientName;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? deliveryInstructions;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.deliveryInstructions,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      label: json['label'] as String? ?? 'Home',
      recipientName: json['recipient_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      addressLine1: json['address_line1'] as String? ?? '',
      addressLine2: json['address_line2'] as String?,
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      postalCode: json['postal_code'] as String? ?? '',
      country: json['country'] as String? ?? 'Bangladesh',
      deliveryInstructions: json['delivery_instructions'] as String?,
      isDefault: json['is_default'] is bool ? json['is_default'] : (json['is_default'] == 1 || json['is_default'] == '1'),
    );
  }

  String get fullAddressString {
    final parts = [
      addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2!,
      city,
      if (state.isNotEmpty) state,
      if (postalCode.isNotEmpty) postalCode,
      country,
    ];
    return parts.join(', ');
  }
}

class CheckoutPreviewPricing {
  final double subtotal;
  final double totalMrp;
  final double discount;
  final double shippingFee;
  final double tax;
  final double total;
  final int totalQuantity;

  CheckoutPreviewPricing({
    required this.subtotal,
    required this.totalMrp,
    required this.discount,
    required this.shippingFee,
    required this.tax,
    required this.total,
    required this.totalQuantity,
  });

  factory CheckoutPreviewPricing.fromJson(Map<String, dynamic> json) {
    return CheckoutPreviewPricing(
      subtotal: json['subtotal'] != null ? (double.tryParse(json['subtotal'].toString()) ?? 0.0) : 0.0,
      totalMrp: json['total_mrp'] != null ? (double.tryParse(json['total_mrp'].toString()) ?? 0.0) : 0.0,
      discount: json['discount'] != null ? (double.tryParse(json['discount'].toString()) ?? 0.0) : 0.0,
      shippingFee: json['shipping_fee'] != null ? (double.tryParse(json['shipping_fee'].toString()) ?? 0.0) : 0.0,
      tax: json['tax'] != null ? (double.tryParse(json['tax'].toString()) ?? 0.0) : 0.0,
      total: json['total'] != null ? (double.tryParse(json['total'].toString()) ?? 0.0) : 0.0,
      totalQuantity: json['total_quantity'] is int ? json['total_quantity'] : int.tryParse(json['total_quantity']?.toString() ?? '0') ?? 0,
    );
  }
}

class CheckoutPreviewModel {
  final AddressModel? deliveryAddress;
  final CheckoutPreviewPricing pricing;
  final bool canPlaceOrder;
  final String? unavailableReason;

  CheckoutPreviewModel({
    this.deliveryAddress,
    required this.pricing,
    required this.canPlaceOrder,
    this.unavailableReason,
  });

  factory CheckoutPreviewModel.fromJson(Map<String, dynamic> json) {
    return CheckoutPreviewModel(
      deliveryAddress: json['delivery_address'] != null ? AddressModel.fromJson(json['delivery_address'] as Map<String, dynamic>) : null,
      pricing: CheckoutPreviewPricing.fromJson(json['pricing'] as Map<String, dynamic>? ?? {}),
      canPlaceOrder: json['can_place_order'] as bool? ?? true,
      unavailableReason: json['unavailable_reason'] as String?,
    );
  }
}

class OrderPlacedModel {
  final int orderId;
  final String orderNumber;
  final double totalAmount;
  final int totalQuantity;
  final String paymentStatus;
  final String orderStatus;
  final String paymentMethod;
  final int? paymentId;
  final String? transactionReference;
  final String nextAction;

  OrderPlacedModel({
    required this.orderId,
    required this.orderNumber,
    required this.totalAmount,
    required this.totalQuantity,
    required this.paymentStatus,
    required this.orderStatus,
    required this.paymentMethod,
    this.paymentId,
    this.transactionReference,
    required this.nextAction,
  });

  factory OrderPlacedModel.fromJson(Map<String, dynamic> json) {
    return OrderPlacedModel(
      orderId: json['order_id'] is int ? json['order_id'] : int.tryParse(json['order_id']?.toString() ?? '0') ?? 0,
      orderNumber: json['order_number'] as String? ?? '',
      totalAmount: json['total_amount'] != null ? (double.tryParse(json['total_amount'].toString()) ?? 0.0) : 0.0,
      totalQuantity: json['total_quantity'] is int ? json['total_quantity'] : int.tryParse(json['total_quantity']?.toString() ?? '0') ?? 0,
      paymentStatus: json['payment_status'] as String? ?? 'unpaid',
      orderStatus: json['order_status'] as String? ?? 'placed',
      paymentMethod: json['payment_method'] as String? ?? 'cod',
      paymentId: json['payment_id'] != null ? int.tryParse(json['payment_id'].toString()) : null,
      transactionReference: json['transaction_reference'] as String?,
      nextAction: json['next_action'] as String? ?? 'proceed_to_payment',
    );
  }
}

class OrderListItemModel {
  final int id;
  final String orderNumber;
  final double totalAmount;
  final String paymentStatus;
  final String orderStatus;
  final String? paymentMethod;
  final String? transactionReference;
  final int itemsCount;
  final String createdAt;
  final List<dynamic> previewItems;

  OrderListItemModel({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    this.paymentMethod,
    this.transactionReference,
    required this.itemsCount,
    required this.createdAt,
    this.previewItems = const [],
  });

  factory OrderListItemModel.fromJson(Map<String, dynamic> json) {
    return OrderListItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderNumber: json['order_number'] as String? ?? '',
      totalAmount: json['total_amount'] != null ? (double.tryParse(json['total_amount'].toString()) ?? 0.0) : 0.0,
      paymentStatus: json['payment_status'] as String? ?? 'unpaid',
      orderStatus: json['order_status'] as String? ?? 'placed',
      paymentMethod: json['payment_method'] as String?,
      transactionReference: json['transaction_reference'] as String?,
      itemsCount: json['items_count'] is int ? json['items_count'] : int.tryParse(json['items_count']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      previewItems: json['preview_items'] as List? ?? [],
    );
  }
}

class ShipmentEventModel {
  final int id;
  final String status;
  final String title;
  final String description;
  final String? location;
  final String? tagLabel;
  final String? actorRole;
  final String dateTime;
  final String timestamp;

  ShipmentEventModel({
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    this.location,
    this.tagLabel,
    this.actorRole,
    required this.dateTime,
    required this.timestamp,
  });

  factory ShipmentEventModel.fromJson(Map<String, dynamic> json) {
    return ShipmentEventModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      status: json['status'] as String? ?? 'placed',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String?,
      tagLabel: json['tag_label'] as String?,
      actorRole: json['actor_role'] as String?,
      dateTime: json['date_time'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class ShipmentTrackingModel {
  final int orderId;
  final String orderNumber;
  final String trackingNumber;
  final String orderStatus;
  final String currentStatus;
  final String paymentStatus;
  final String estimatedDelivery;
  final String estimatedTime;
  final String currentLocation;
  final String nextStop;
  final String courierName;
  final String courierPhone;
  final String recipientName;
  final String recipientAddress;
  final String stepText;
  final int progressPercent;
  final double progressFactor;
  final int itemsCount;
  final List<dynamic> items;
  final List<ShipmentEventModel> timeline;
  final String createdAt;
  final String updatedAt;

  ShipmentTrackingModel({
    required this.orderId,
    required this.orderNumber,
    required this.trackingNumber,
    required this.orderStatus,
    required this.currentStatus,
    required this.paymentStatus,
    required this.estimatedDelivery,
    required this.estimatedTime,
    required this.currentLocation,
    required this.nextStop,
    required this.courierName,
    required this.courierPhone,
    required this.recipientName,
    required this.recipientAddress,
    required this.stepText,
    required this.progressPercent,
    required this.progressFactor,
    required this.itemsCount,
    this.items = const [],
    this.timeline = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShipmentTrackingModel.fromJson(Map<String, dynamic> json) {
    final rawTimeline = json['timeline'] as List? ?? [];
    return ShipmentTrackingModel(
      orderId: json['order_id'] is int ? json['order_id'] : int.tryParse(json['order_id']?.toString() ?? '0') ?? 0,
      orderNumber: json['order_number'] as String? ?? '',
      trackingNumber: json['tracking_number'] as String? ?? '',
      orderStatus: json['order_status'] as String? ?? 'placed',
      currentStatus: json['current_status'] as String? ?? 'In Transit',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      estimatedDelivery: json['estimated_delivery'] as String? ?? 'Tomorrow',
      estimatedTime: json['estimated_time'] as String? ?? 'By 6:00 PM • On Schedule',
      currentLocation: json['current_location'] as String? ?? 'Sorting Facility',
      nextStop: json['next_stop'] as String? ?? 'North Banani Dispatch Center',
      courierName: json['courier_name'] as String? ?? 'Apex Courier Express',
      courierPhone: json['courier_phone'] as String? ?? '+880 1700-112233',
      recipientName: json['recipient_name'] as String? ?? '',
      recipientAddress: json['recipient_address'] as String? ?? '',
      stepText: json['step_text'] as String? ?? 'Step 3 of 4',
      progressPercent: json['progress_percent'] is int ? json['progress_percent'] : int.tryParse(json['progress_percent']?.toString() ?? '75') ?? 75,
      progressFactor: json['progress_factor'] != null ? (double.tryParse(json['progress_factor'].toString()) ?? 0.75) : 0.75,
      itemsCount: json['items_count'] is int ? json['items_count'] : int.tryParse(json['items_count']?.toString() ?? '0') ?? 0,
      items: json['items'] as List? ?? [],
      timeline: rawTimeline.map((e) => ShipmentEventModel.fromJson(e as Map<String, dynamic>)).toList(),
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}

