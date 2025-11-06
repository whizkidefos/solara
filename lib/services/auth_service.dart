// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  Map<String, dynamic>? _userData;

  User? get currentUser => _currentUser;
  Map<String, dynamic>? get userData => _userData;

  AuthService() {
    _auth.authStateChanges().listen((User? user) async {
      _currentUser = user;
      if (user != null) {
        await _loadUserData(user.uid);
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userData = doc.data();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'profileImage': '',
        'addresses': [],
        'createdAt': FieldValue.serverTimestamp(),
        'rating': 0.0,
      });

      _currentUser = result.user;
      await _loadUserData(result.user!.uid);
      notifyListeners();
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _currentUser = result.user;
      await _loadUserData(result.user!.uid);
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    _userData = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    try {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'fullName': fullName,
        'phone': phone,
      });
      _userData = {
        ..._userData!,
        'fullName': fullName,
        'phone': phone,
      };
      notifyListeners();
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  Future<void> addAddress({required Map<String, dynamic> address}) async {
    try {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'addresses': FieldValue.arrayUnion([address]),
      });
      await _loadUserData(_currentUser!.uid);
      notifyListeners();
    } catch (e) {
      print('Error adding address: $e');
    }
  }
}