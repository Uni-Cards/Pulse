import 'dart:math' as math;

import 'events_service.dart';
import 'package:flutter/material.dart';

final _mockUsers = [
  User(
    authToken: 'secret',
    userId: 'U111',
  ),
  User(
    authToken: 'secret',
    userId: 'U222',
  ),
  User(
    authToken: 'secret',
    userId: 'U333',
  ),
];

class User {
  final String authToken;
  final String userId;

  User({
    required this.authToken,
    required this.userId,
  });
}

class AuthService extends ChangeNotifier {
  AuthService._();

  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  final _random = math.Random();

  User? _user;

  String? get authToken => _user?.authToken;

  String? get userId => _user?.userId;

  bool get isLoggedIn => _user != null;

  void login() {
    _user = _mockUsers[_random.nextInt(_mockUsers.length)];
    EventsService.instance.setUserId(_user!.userId);

    notifyListeners();
  }

  void logout() {
    _user = null;
    EventsService.instance.logout();

    notifyListeners();
  }
}
