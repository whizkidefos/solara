// lib/models/product_model.dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String vendorId;
  final String vendorName;
  final List<String> images;
  final double rating;
  final int reviews;
  final bool isFeatured;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.vendorId,
    required this.vendorName,
    required this.images,
    required this.rating,
    required this.reviews,
    this.isFeatured = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      vendorId: json['vendorId'] ?? '',
      vendorName: json['vendorName'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'images': images,
      'rating': rating,
      'reviews': reviews,
      'isFeatured': isFeatured,
    };
  }
}