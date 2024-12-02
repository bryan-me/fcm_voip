import 'dart:convert';
import 'package:fcm_voip/services/auth_service.dart';
import 'package:fcm_voip/utilities/activity_main.dart';
// import 'package:fcm_voip/ui/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:flutter_keycloak/screens/main_screen.dart';
// import 'package:flutter_keycloak/service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fcm_voip/services/auth_service.dart';
import 'package:fcm_voip/utilities/activity_main.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../controllers/base_data_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Validation methods
  String? validateUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9._]{1,50}$');
    if (!usernameRegex.hasMatch(username)) {
      return 'Username must be alphanumeric, include underscores/periods, and up to 50 characters.';
    }
    return null;
  }

  String? validatePassword(String password) {
    // Require 8-20 characters, including special characters $@_#
    final passwordRegex = RegExp(r'^[a-zA-Z0-9@$#_]{8,20}$');
    if (!passwordRegex.hasMatch(password)) {
      return 'Password must be 8-20 characters long and include only letters, numbers, and \$@_#.';
    }
    return null;
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final usernameError = validateUsername(username);
    final passwordError = validatePassword(password);

    if (usernameError != null || passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              usernameError ?? passwordError ?? 'Invalid input, please correct it.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show the progress indicator
    });

    try {
      final tokenExchangeStatus = await createClient();

      if (tokenExchangeStatus == 200) {
        setState(() {
          _isLoading = false; // Hide the progress indicator
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CustomBottomNavigationBar()),
        );
      } else {
        setState(() {
          _isLoading = false; // Hide the progress indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username or Password incorrect. Please try again.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide the progress indicator
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<int> createClient() async {
    final tokenEndpoint = Uri.parse(
        'http://192.168.250.209:8070/auth/realms/FCM_VoIP/protocol/openid-connect/token');
    const clientId = 'mobile_client';
    final username = _usernameController.text;
    final password = _passwordController.text;

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

      if (tokenResponse.statusCode == 200) {
        final jsonResponse = json.decode(tokenResponse.body);
        final accessToken = jsonResponse['access_token'];
        final refreshToken = jsonResponse['refresh_token'];
        final decodedToken = JwtDecoder.decode(accessToken);
        final sub = decodedToken['sub'];

        if (accessToken == null || refreshToken == null) {
          throw Exception('Access token or refresh token missing from response');
        }

        print('Access token: $accessToken');
        print('Session State: $sub');
        print('Decoded Token: $decodedToken');



        Map<String, dynamic> payload = Jwt.parseJwt(accessToken);
        final userId = payload['sub'];
        final name = payload['name'];
        final email = payload['email'];

        if (userId == null) {
          throw Exception('User ID is missing in the token payload');
        }

        await _authService.storeToken(userId, username, name, email, accessToken, refreshToken);
        await _authService.storeHashedPassword(userId, password);
        // onLoginSuccess();
      } else {
        print(
            'Failed to obtain access token. Status code: ${tokenResponse.statusCode}');
        return tokenResponse.statusCode;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No network connection detected. Please try again later.')),
      );
      print('Error during token exchange: $e');
      throw Exception('Failed to gain access');
    }

    return 200;
  }

  // void onLoginSuccess() async {
  //   final currentUser = await _authService.getCurrentUserId();
  //   final baseDataController = Get.find<BaseDataController>();
  //   baseDataController.fetchBaseData(currentUser!); // Fetch all required data
  //   // Get.off(() => HomeScreen()); // Navigate to the main screen
  // }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: const Color.fromARGB(255, 56, 71, 96),
    body: Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/fcm_logo.png',
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please sign in to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    color: const Color.fromARGB(255, 50, 63, 86),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 24),
                          TextField(
                            key: const Key('usernameField'),
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.grey[850],
                              filled: true,
                              prefixIcon: const Icon(Icons.person, color: Colors.white70),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            key: const Key('passwordField'),
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.grey[850],
                              filled: true,
                              prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                            ),
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            key: const Key('loginButton'),
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color.fromARGB(255, 251, 164, 38),
                            ),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      // Add your 'Forgot password?' navigation logic here
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    ),
  );
}
}