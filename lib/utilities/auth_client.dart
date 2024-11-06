import 'dart:convert';
import 'package:fcm_voip/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fcm_voip/utilities/activity_main.dart';
import 'package:fcm_voip/utilities/token_manager.dart';
import 'package:fcm_voip/ui/login/login.dart';

class AuthClient {
  final String tokenEndpointUrl = dotenv.env['TOKEN_ENDPOINT_URL'] ?? 'default_token_endpoint_url';
  final String logoutEndpointUrl = dotenv.env['LOGOUT_ENDPOINT_URL'] ?? 'default_logout_endpoint_url';
  final String clientId = dotenv.env['CLIENT_ID'] ?? 'default_client_id';
AuthService authService = AuthService();
  Future<void> createClient(BuildContext context, String username, String password) async {
    final tokenEndpoint = Uri.parse(tokenEndpointUrl);

    try {
      final tokenResponse = await http.post(
        tokenEndpoint,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'client_id': clientId,
          'username': username,
          'password': password,
        },
      );

      print('Token response: ${tokenResponse.body}');
      final tokenData = json.decode(tokenResponse.body);
      final accessToken = tokenData['access_token'];
      final refreshToken = tokenData['refresh_token'];
      final decodedToken = JwtDecoder.decode(accessToken);
      final session_state = decodedToken['session_state'];

      if (accessToken != null && accessToken.isNotEmpty) {
        TokenManager.setTokens(accessToken, refreshToken, session_state);

        if (kDebugMode) {
          print('Access token: $accessToken');
          print('Session State: $session_state');
          print('Decoded Token: $decodedToken');
        }

        // Navigate to the main activity
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()),
        );
      } else {
        _showErrorDialog(context, 'Access token is empty');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during token exchange: $e');
      }
      _showErrorDialog(context, 'Failed to obtain access token');
    }
  }

  // Method to show error dialogs
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text("Invalid Username or Password"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> logout(BuildContext context) async {
  //   try {
  //     final accessToken = await TokenManager.accessToken;
  //     final refreshToken = await TokenManager.refreshToken;

  //     if (accessToken != null && refreshToken != null) {
  //       final logoutResponse = await http.get(Uri.parse(logoutEndpointUrl),
  //           headers: {'Content-Type': 'application/x-www-form-urlencoded'});

  //       if (logoutResponse.statusCode == 200) {
  //         if (kDebugMode) {
  //           print('Successfully logged out from Keycloak.');
  //         }

  //         TokenManager.clearTokens();

  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const Login()),
  //         );
  //       } else {
  //         throw Exception('Failed to log out from Keycloak.');
  //       }
  //     } else {
  //       throw Exception('No tokens found for logout.');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error during logout: $e');
  //     }

  //     // Show error alert to the user
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Logout Failed'),
  //           content: const Text('An error occurred during logout.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

   Future<void> logout(BuildContext context) async {
      //user ID or token is needed for the clearSession method
      // final userId = await authService.getUserId(); // Fetch userId or token from AuthService
  String? userId = await authService.getCurrentUserId(); // Fetch current user ID


      await authService.clearSession(userId!); // Pass the userId or required argument
      print("Signing out from: $userId account");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
}