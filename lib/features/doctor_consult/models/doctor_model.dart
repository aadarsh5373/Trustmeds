class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final String qualification;
  final int experience;
  final String profileImageUrl;
  final double consultationFee;
  final double rating;
  final int reviewCount;
  final List<String> languages;
  final bool isAvailableNow;
  final String bio;
  final List<DateTime> availableSlots;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    this.qualification = '',
    this.experience = 0,
    this.profileImageUrl = '',
    required this.consultationFee,
    this.rating = 4.0,
    this.reviewCount = 0,
    this.languages = const ['English', 'Hindi'],
    this.isAvailableNow = true,
    this.bio = '',
    this.availableSlots = const [],
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json, String id) {
    return DoctorModel(
      id: id,
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      qualification: json['qualification'] ?? '',
      experience: json['experience'] ?? 0,
      profileImageUrl: json['profileImageUrl'] ?? '',
      consultationFee: (json['consultationFee'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      languages: List<String>.from(json['languages'] ?? ['English']),
      isAvailableNow: json['isAvailableNow'] ?? false,
      bio: json['bio'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'specialization': specialization,
        'qualification': qualification,
        'experience': experience,
        'profileImageUrl': profileImageUrl,
        'consultationFee': consultationFee,
        'rating': rating,
        'reviewCount': reviewCount,
        'languages': languages,
        'isAvailableNow': isAvailableNow,
        'bio': bio,
      };
}
