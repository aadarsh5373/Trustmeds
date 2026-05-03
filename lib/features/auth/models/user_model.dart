class AddressModel {
  final String id;
  final String label;
  final String fullAddress;
  final String pincode;
  final String city;
  final String state;
  final double? lat;
  final double? lng;

  AddressModel({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.pincode,
    required this.city,
    required this.state,
    this.lat,
    this.lng,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json, String id) {
    return AddressModel(
      id: id,
      label: json['label'] ?? 'Home',
      fullAddress: json['fullAddress'] ?? '',
      pincode: json['pincode'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'fullAddress': fullAddress,
        'pincode': pincode,
        'city': city,
        'state': state,
        'lat': lat,
        'lng': lng,
      };

  AddressModel copyWith({
    String? id,
    String? label,
    String? fullAddress,
    String? pincode,
    String? city,
    String? state,
    double? lat,
    double? lng,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      fullAddress: fullAddress ?? this.fullAddress,
      pincode: pincode ?? this.pincode,
      city: city ?? this.city,
      state: state ?? this.state,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

class SocietyModel {
  final String id;
  final String name;
  final String pincode;
  final bool isSubscribed;

  SocietyModel({
    required this.id,
    required this.name,
    required this.pincode,
    required this.isSubscribed,
  });

  factory SocietyModel.fromJson(Map<String, dynamic> json) {
    return SocietyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      pincode: json['pincode'] ?? '',
      isSubscribed: json['is_subscribed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'pincode': pincode,
        'is_subscribed': isSubscribed,
      };
}

class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String profileImageUrl;
  final DateTime? dateOfBirth;
  final String gender;
  final DateTime? createdAt;
  final String fcmToken;
  final List<AddressModel> addresses;
  final String? societyId;
  final String? societyName;
  final bool isSocietySubscribed;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    this.email = '',
    this.profileImageUrl = '',
    this.dateOfBirth,
    this.gender = '',
    this.createdAt,
    this.fcmToken = '',
    this.addresses = const [],
    this.societyId,
    this.societyName,
    this.isSocietySubscribed = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      gender: json['gender'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      fcmToken: json['fcmToken'] ?? '',
      societyId: json['societyId'],
      societyName: json['societyName'],
      isSocietySubscribed: json['isSocietySubscribed'] ?? false,
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .asMap()
          .entries
          .map(
            (entry) => AddressModel.fromJson(
              Map<String, dynamic>.from(entry.value),
              entry.value['id'] ?? 'addr_${entry.key}',
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'phone': phone,
        'email': email,
        'profileImageUrl': profileImageUrl,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'gender': gender,
        'createdAt': createdAt?.toIso8601String(),
        'fcmToken': fcmToken,
        'societyId': societyId,
        'societyName': societyName,
        'isSocietySubscribed': isSocietySubscribed,
        'addresses': addresses
            .map((address) => {
                  'id': address.id,
                  ...address.toJson(),
                })
            .toList(),
      };

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
    List<AddressModel>? addresses,
    String? societyId,
    String? societyName,
    bool? isSocietySubscribed,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      createdAt: createdAt,
      fcmToken: fcmToken,
      addresses: addresses ?? this.addresses,
      societyId: societyId ?? this.societyId,
      societyName: societyName ?? this.societyName,
      isSocietySubscribed: isSocietySubscribed ?? this.isSocietySubscribed,
    );
  }
}
