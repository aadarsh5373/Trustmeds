class MedicineModel {
  final String id;
  final String name;
  final String brand;
  final String genericName;
  final String category;
  final String subCategory;
  final String imageUrl;
  final List<String> images;
  final double mrp;
  final double sellingPrice;
  final int discount;
  final String description;
  final String uses;
  final String sideEffects;
  final String dosage;
  final String composition;
  final String manufacturer;
  final bool requiresPrescription;
  final bool inStock;
  final int stockCount;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final DateTime? createdAt;

  MedicineModel({
    required this.id,
    required this.name,
    required this.brand,
    this.genericName = '',
    required this.category,
    this.subCategory = '',
    this.imageUrl = '',
    this.images = const [],
    required this.mrp,
    required this.sellingPrice,
    this.discount = 0,
    this.description = '',
    this.uses = '',
    this.sideEffects = '',
    this.dosage = '',
    this.composition = '',
    this.manufacturer = '',
    this.requiresPrescription = false,
    this.inStock = true,
    this.stockCount = 100,
    this.rating = 4.0,
    this.reviewCount = 0,
    this.tags = const [],
    this.createdAt,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json, String id) {
    return MedicineModel(
      id: id,
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      genericName: json['genericName'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      mrp: (json['mrp'] ?? 0.0).toDouble(),
      sellingPrice: (json['sellingPrice'] ?? 0.0).toDouble(),
      discount: json['discount'] ?? 0,
      description: json['description'] ?? '',
      uses: json['uses'] ?? '',
      sideEffects: json['sideEffects'] ?? '',
      dosage: json['dosage'] ?? '',
      composition: json['composition'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      requiresPrescription: json['requiresPrescription'] ?? false,
      inStock: json['inStock'] ?? true,
      stockCount: json['stockCount'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'brand': brand,
        'genericName': genericName,
        'category': category,
        'subCategory': subCategory,
        'imageUrl': imageUrl,
        'images': images,
        'mrp': mrp,
        'sellingPrice': sellingPrice,
        'discount': discount,
        'description': description,
        'uses': uses,
        'sideEffects': sideEffects,
        'dosage': dosage,
        'composition': composition,
        'manufacturer': manufacturer,
        'requiresPrescription': requiresPrescription,
        'inStock': inStock,
        'stockCount': stockCount,
        'rating': rating,
        'reviewCount': reviewCount,
        'tags': tags,
      };
}
