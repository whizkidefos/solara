// lib/services/complaint_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> createComplaint({
    required String userId,
    required String orderId,
    required String category,
    required String title,
    required String description,
  }) async {
    try {
      final complaintId = _firestore.collection('complaints').doc().id;
      await _firestore.collection('complaints').doc(complaintId).set({
        'id': complaintId,
        'userId': userId,
        'orderId': orderId,
        'category': category,
        'title': title,
        'description': description,
        'status': 'open',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return complaintId;
    } catch (e) {
      print('Error creating complaint: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getUserComplaints(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('complaints')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching complaints: $e');
      return [];
    }
  }

  static Stream<QuerySnapshot> getUserComplaintsStream(String userId) {
    return _firestore
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> updateComplaintStatus(
    String complaintId,
    String status,
  ) async {
    try {
      await _firestore.collection('complaints').doc(complaintId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating complaint status: $e');
      rethrow;
    }
  }
}