// lib/services/message_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> sendMessage({
    required String senderId,
    required String recipientId,
    required String message,
    required String orderId,
  }) async {
    try {
      await _firestore.collection('messages').add({
        'senderId': senderId,
        'recipientId': recipientId,
        'text': message,
        'orderId': orderId,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  static Stream<QuerySnapshot> getMessagesStream(
    String userId,
    String recipientId,
  ) {
    return _firestore
        .collection('messages')
        .where('senderId', whereIn: [userId, recipientId])
        .where('recipientId', whereIn: [userId, recipientId])
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  static Future<void> markAsRead(String messageId) async {
    try {
      await _firestore.collection('messages').doc(messageId).update({
        'isRead': true,
      });
    } catch (e) {
      print('Error marking message as read: $e');
    }
  }
}