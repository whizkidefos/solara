// lib/services/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();
      return doc.data();
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  static Stream<QuerySnapshot> getProductsStream() {
    return _firestore.collection('products').snapshots();
  }
}