import 'package:flutter/foundation.dart';

class TokenManager {
  static String? accessToken;
  static String? refreshToken;
  static String? sub;

  static void setTokens(String access, String refresh, String sub) {
    accessToken = access;
    refreshToken = refresh;
    sub = sub;
    if (kDebugMode) {
      print('Tokens set. Session State: $sub');
    }
  }

  static void clearTokens() {
    accessToken = null;
    refreshToken = null;
    sub = null;
    if (kDebugMode) {
      print('Tokens cleared.');
    }
  }
}
