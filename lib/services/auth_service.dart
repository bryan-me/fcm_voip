import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final _authBox = Hive.box('authBox');
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Store tokens and username for a specific user and save the last authenticated user ID
  Future<void> storeToken(String userId, String username, String name, String email, String accessToken, String refreshToken) async {
    await _authBox.put('${userId}_accessToken', accessToken);
    await _authBox.put('${userId}_refreshToken', refreshToken);
    await _authBox.put('${userId}_username', username);
    await _authBox.put('${userId}_name', name);
    await _authBox.put('${userId}_email', email);
    // Debug print statements to confirm storage
    print('Stored access token: $accessToken');
    print('Stored refresh token: $refreshToken');
    await setCurrentUserId(userId);

    // Debug print for current user
    print('Stored current user ID: $userId');
   }

// Get name 
Future<String?> getName(String userId) async {
  return _authBox.get('${userId}_name');
}

// Get email  
Future<String?> getEmail(String userId) async {
  return _authBox.get('${userId}_email');
}

 // Set the current user ID
  Future<void> setCurrentUserId(String userId) async {
    await _authBox.put('currentUserId', userId);
  }

  // Get the current user ID
  Future<String?> getCurrentUserId() async {
    return _authBox.get('currentUserId');
  }
  // Hash and store the password associated with the user ID
  Future<void> storeHashedPassword(String userId, String password) async {
    var bytes = utf8.encode(password); // Convert the password to bytes
    var hashedPassword = sha256.convert(bytes); // Hash the password
    await _authBox.put('${userId}_hashedPassword', hashedPassword.toString());
  }

  // Get token for the specified user and refresh if expired
  Future<String?> getToken(String userId) async {
    String? token = _authBox.get('${userId}_accessToken');
    if (token == null) {
      print('Token not found for user $userId');
    } else {
      print('Token retrieved for user $userId: $token');
    }

    if (token != null && isTokenExpired(token)) {
      // Refresh the token if it has expired
      print('Token expired for user $userId. Refreshing...');
      token = await getRefreshToken(userId);
      print('New token after refresh: $token');
    }
    return token;
  }



  // Check if token is expired
  bool isTokenExpired(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      print('Error decoding token: $e');
      return true; // Return true if token decoding fails
    }
  }

  Future<String?> getUsername(String userId) async {
    return _authBox.get('${userId}_username');
  }

  Future<String?> getRefreshToken(String userId) async {
    return _authBox.get('${userId}_refreshToken');
  }

  // Retrieve the hashed password associated with the user ID
  Future<String?> getHashedPassword(String userId) async {
    return _authBox.get('${userId}_hashedPassword');
  }

  // Set and get admin password for password resets
  Future<void> setAdminPassword(String password) async {
    await _secureStorage.write(key: 'admin_password', value: password);
  }

  Future<String?> getAdminPassword() async {
    return await _secureStorage.read(key: 'admin_password');
  }

  // Clear session data for a specific user
  Future<void> clearSession(String userId) async {
    await _authBox.delete('${userId}_accessToken');
    await _authBox.delete('${userId}_refreshToken');
    await _authBox.delete('${userId}_hashedPassword');
  }

  // Retrieve userId from Hive based on stored token or any other key
  Future<String?> getUserId() async {
    var userIdKey = _authBox.keys.firstWhere((key) => key.endsWith('_accessToken'), orElse: () => null);
    if (userIdKey != null) {
      return userIdKey.split('_')[0];
    }
    return null; // Return null if no userId is found
  }

  // List all stored users with their user IDs and usernames
  List<Map<String, String?>> getAllUsers() {
    return _authBox.keys
        .where((key) => key.endsWith('_hashedPassword'))
        .map((key) {
          String userId = key.split('_')[0];
          String? username = _authBox.get('${userId}_username');
          return {'userId': userId, 'username': username};
        }).toList();
  }
}