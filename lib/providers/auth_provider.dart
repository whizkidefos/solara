// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;
  String? _error;

  AuthProvider({required AuthService authService}) : _authService = authService;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _authService.currentUser != null;
  var get userData => _authService.userData;

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    bool success = await _authService.register(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
    );

    _isLoading = false;
    if (!success) {
      _error = 'Registration failed. Please try again.';
    }
    notifyListeners();
    return success;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    bool success = await _authService.login(email: email, password: password);

    _isLoading = false;
    if (!success) {
      _error = 'Invalid email or password.';
    }
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}

// lib/providers/product_provider.dart
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
}

class ProductProvider extends ChangeNotifier {
  final List<Product> _allProducts = [
    Product(
      id: '1',
      name: 'Premium Wireless Headphones',
      description: 'High-quality noise-cancelling headphones',
      price: 89.99,
      category: 'Electronics',
      vendorId: 'vendor1',
      vendorName: 'TechStore',
      images: ['https://via.placeholder.com/300?text=Headphones'],
      rating: 4.5,
      reviews: 234,
      isFeatured: true,
    ),
    Product(
      id: '2',
      name: 'Organic Cotton T-Shirt',
      description: 'Comfortable and eco-friendly',
      price: 29.99,
      category: 'Fashion',
      vendorId: 'vendor2',
      vendorName: 'FashionHub',
      images: ['https://via.placeholder.com/300?text=TShirt'],
      rating: 4.2,
      reviews: 156,
      isFeatured: true,
    ),
  ];

  List<String> get categories =>
      _allProducts.map((p) => p.category).toSet().toList();

  List<Product> get allProducts => _allProducts;
  List<Product> get featuredProducts =>
      _allProducts.where((p) => p.isFeatured).toList();

  List<Product> searchProducts(String query) {
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

// lib/providers/cart_provider.dart
class CartItem {
  final String productId;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.total);

  void addItem({
    required String productId,
    required String name,
    required double price,
    required String image,
  }) {
    final existingIndex = _items.indexWhere((i) => i.productId == productId);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        productId: productId,
        name: name,
        price: price,
        image: image,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((i) => i.productId == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// lib/providers/order_provider.dart
class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final String paymentMethod;
  final String deliveryAddress;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.paymentMethod,
    required this.deliveryAddress,
  });
}

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }
}