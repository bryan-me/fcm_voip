import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final _authBox = Hive.box('authBox');
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> storeToken(String userId, String username, String accessToken, String refreshToken) async {
    await _authBox.put('${userId}_accessToken', accessToken);
    await _authBox.put('${userId}_refreshToken', refreshToken);
    await _authBox.put('${userId}_username', username);
  }

  // Hash and store the password associated with the user ID
  Future<void> storeHashedPassword(String userId, String password) async {
    var bytes = utf8.encode(password); // Convert the password to bytes
    var hashedPassword = sha256.convert(bytes); // Hash the password
    await _authBox.put('${userId}_hashedPassword', hashedPassword.toString());
  }

  Future<String?> getToken(String userId) async {
    return _authBox.get('${userId}_accessToken');
  }

//   Future<String?> getToken(String userId) async {
//   String? token = _authBox.get('${userId}_accessToken');

//   // Check if token is expired
//   if (token != null && isTokenExpired(token)) {
//     // If the token is expired, refresh it
//     token = await getRefreshToken(userId);
//   }

//   return token;
// }

  bool isTokenExpired(String token) {
  // Decode and check token expiration
  // This is just a sample; implement according to your JWT library
  final decodedToken = JwtDecoder.decode(token);
  final expiryDate = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
  return DateTime.now().isAfter(expiryDate);
}

Future<String?> getUsername(String userId) async {
  return _authBox.get('${userId}_username');
}

  Future<String?> getRefreshToken(String userId) async {
    return _authBox.get('userId_refreshToken');
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
    // Assuming the userId is part of the keys stored, you can extract it
    // For example, if you store 'userId_accessToken', you can fetch it this way:
    var userIdKey = _authBox.keys.firstWhere((key) => key.endsWith('_accessToken'), orElse: () => null);
    
    if (userIdKey != null) {
      // Extract the userId from the key (userId_accessToken format)
      return userIdKey.split('_')[0]; 
    }
    
    return null; // Return null if no userId is found
  }
  // List all users stored in Hive
  // List getAllUsers() {
  //   return _authBox.keys
  //       .where((key) => key.endsWith('_hashedPassword')) // Filter to find all user IDs
  //       .map((key) => key.split('_')[0]) // Extract user IDs
  //       .toList();
  // }

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