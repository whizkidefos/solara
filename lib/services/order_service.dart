// lib/services/order_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double total,
    required String paymentMethod,
    required String deliveryAddress,
  }) async {
    try {
      final orderId = _firestore.collection('orders').doc().id;
      await _firestore.collection('orders').doc(orderId).set({
        'id': orderId,
        'userId': userId,
        'items': items,
        'total': total,
        'status': 'pending',
        'paymentMethod': paymentMethod,
        'deliveryAddress': deliveryAddress,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return orderId;
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      return doc.data();
    } catch (e) {
      print('Error fetching order: $e');
      return null;
    }
  }

  static Stream<QuerySnapshot> getUserOrdersStream(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }
}