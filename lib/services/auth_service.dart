import 'dart:convert';

import 'package:multi_screen_app/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();

  static const _usersKey = 'registered_users';
  static const _currentUserEmailKey = 'current_user_email';
  static final List<AppUser> _users = [];
  static AppUser? _currentUser;

  static AppUser? get currentUser => _currentUser;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final usersRaw = prefs.getString(_usersKey);

    if (usersRaw != null && usersRaw.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(usersRaw) as List<dynamic>;
      _users
        ..clear()
        ..addAll(
          decoded.map((item) => AppUser.fromJson(item as Map<String, dynamic>)),
        );
    }

    final currentUserEmail = prefs.getString(_currentUserEmailKey);
    if (currentUserEmail != null) {
      try {
        _currentUser = _users.firstWhere((user) => user.email == currentUserEmail);
      } catch (_) {
        _currentUser = null;
      }
    }
  }

  static Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final exists = _users.any((user) => user.email == normalizedEmail);
    if (exists) {
      return false;
    }

    _users.add(
      AppUser(
        name: name.trim(),
        email: normalizedEmail,
        password: password,
      ),
    );
    await _persistUsers();
    return true;
  }

  static Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    try {
      final user = _users.firstWhere(
        (item) => item.email == normalizedEmail && item.password == password,
      );
      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserEmailKey, user.email);
      return user;
    } catch (_) {
      return null;
    }
  }

  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserEmailKey);
  }

  static Future<void> _persistUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersRaw = jsonEncode(_users.map((user) => user.toJson()).toList());
    await prefs.setString(_usersKey, usersRaw);
  }
}
