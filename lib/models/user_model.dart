// lib/models/user_model.dart
class User {
  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final String profileImage;
  final List<String> addresses;
  final double rating;
  final DateTime createdAt;

  User({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    this.profileImage = '',
    this.addresses = const [],
    this.rating = 0.0,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      addresses: List<String>.from(json['addresses'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt']
          : DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'profileImage': profileImage,
      'addresses': addresses,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}