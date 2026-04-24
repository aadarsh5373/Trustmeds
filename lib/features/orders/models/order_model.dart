class OrderItem {
  final String medicineId;
  final String medicineName;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.price,
    this.imageUrl = '',
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        medicineId: json['medicineId'] ?? '',
        medicineName: json['medicineName'] ?? '',
        quantity: json['quantity'] ?? 1,
        price: (json['price'] ?? 0.0).toDouble(),
        imageUrl: json['imageUrl'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'medicineName': medicineName,
        'quantity': quantity,
        'price': price,
        'imageUrl': imageUrl,
      };
}

class OrderModel {
  final String? id;
  final String userId;
  final String orderNumber;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final Map<String, dynamic> address;
  final String? prescriptionUrl;
  final DateTime? estimatedDelivery;
  final DateTime? placedAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    this.paymentStatus = 'pending',
    this.orderStatus = 'placed',
    required this.address,
    this.prescriptionUrl,
    this.estimatedDelivery,
    this.placedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      id: id,
      userId: json['userId'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      orderStatus: json['orderStatus'] ?? 'placed',
      address: Map<String, dynamic>.from(json['address'] ?? {}),
      prescriptionUrl: json['prescriptionUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'orderNumber': orderNumber,
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'discount': discount,
        'total': total,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'orderStatus': orderStatus,
        'address': address,
        'prescriptionUrl': prescriptionUrl,
      };
}
