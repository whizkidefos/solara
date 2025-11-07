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
  Map<String, dynamic>? get userData => _authService.userData;

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