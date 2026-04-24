class LabTestModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discountedPrice;
  final List<String> parameters;
  final String preparation;
  final String reportTime;
  final bool isHomeCollection;
  final String category;
  final String imageUrl;
  final bool isPopular;

  LabTestModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    required this.discountedPrice,
    this.parameters = const [],
    this.preparation = '',
    this.reportTime = '24 hours',
    this.isHomeCollection = true,
    this.category = '',
    this.imageUrl = '',
    this.isPopular = false,
  });

  int get discount =>
      price > 0 ? ((price - discountedPrice) / price * 100).round() : 0;

  factory LabTestModel.fromJson(Map<String, dynamic> json, String id) {
    return LabTestModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0.0).toDouble(),
      parameters: List<String>.from(json['parameters'] ?? []),
      preparation: json['preparation'] ?? '',
      reportTime: json['reportTime'] ?? '24 hours',
      isHomeCollection: json['isHomeCollection'] ?? true,
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'discountedPrice': discountedPrice,
        'parameters': parameters,
        'preparation': preparation,
        'reportTime': reportTime,
        'isHomeCollection': isHomeCollection,
        'category': category,
        'imageUrl': imageUrl,
        'isPopular': isPopular,
      };
}
