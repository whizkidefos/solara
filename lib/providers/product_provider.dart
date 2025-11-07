// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _allProducts = [
    Product(
      id: '1',
      name: 'Premium Wireless Headphones',
      description: 'High-quality noise-cancelling headphones with 30-hour battery',
      price: 89.99,
      category: 'Electronics',
      vendorId: 'vendor1',
      vendorName: 'TechStore',
      images: ['https://via.placeholder.com/400?text=Headphones+1'],
      rating: 4.5,
      reviews: 234,
      isFeatured: true,
    ),
    Product(
      id: '2',
      name: 'Organic Cotton T-Shirt',
      description: 'Comfortable and eco-friendly premium quality',
      price: 29.99,
      category: 'Fashion',
      vendorId: 'vendor2',
      vendorName: 'FashionHub',
      images: ['https://via.placeholder.com/400?text=TShirt+1'],
      rating: 4.2,
      reviews: 156,
      isFeatured: true,
    ),
    Product(
      id: '3',
      name: 'Natural Face Moisturizer',
      description: 'Hypoallergenic moisturizer for all skin types',
      price: 24.99,
      category: 'Beauty',
      vendorId: 'vendor3',
      vendorName: 'BeautyPro',
      images: ['https://via.placeholder.com/400?text=Beauty+1'],
      rating: 4.7,
      reviews: 312,
      isFeatured: true,
    ),
    Product(
      id: '4',
      name: 'Fresh Organic Vegetables Bundle',
      description: 'Weekly fresh vegetables delivered to your door',
      price: 15.99,
      category: 'Groceries',
      vendorId: 'vendor4',
      vendorName: 'FreshFarm',
      images: ['https://via.placeholder.com/400?text=Groceries+1'],
      rating: 4.3,
      reviews: 89,
      isFeatured: false,
    ),
    Product(
      id: '5',
      name: 'Smart Watch Pro',
      description: 'Advanced fitness tracking with heart rate monitor',
      price: 199.99,
      category: 'Electronics',
      vendorId: 'vendor1',
      vendorName: 'TechStore',
      images: ['https://via.placeholder.com/400?text=SmartWatch+1'],
      rating: 4.6,
      reviews: 445,
      isFeatured: true,
    ),
  ];

  List<String> get categories =>
      _allProducts.map((p) => p.category).toSet().toList();

  List<Product> get allProducts => _allProducts;
  List<Product> get featuredProducts =>
      _allProducts.where((p) => p.isFeatured).toList();

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _allProducts;
    return _allProducts
        .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Product> getByCategory(String category) {
    return _allProducts.where((p) => p.category == category).toList();
  }

  Product? getProductById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}