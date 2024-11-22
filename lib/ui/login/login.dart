import 'dart:convert';
import 'package:fcm_voip/services/auth_service.dart';
import 'package:fcm_voip/utilities/activity_main.dart';
// import 'package:fcm_voip/ui/landing_page.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_keycloak/screens/main_screen.dart';
// import 'package:flutter_keycloak/service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();
bool _isLoading = false;
  // Using TextEditingController for better state management
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Future<void> _login() async {
  //   try {
  //     // Attempt to create a client and retrieve tokens
  //     final tokenExchangeStatus = await createClient();
  //
  //     if (tokenExchangeStatus == 200) {
  //       // Navigate to the main screen after successful login
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => const CustomBottomNavigationBar()),
  //       );
  //     } else {
  //       // Handle failed login attempt
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Username or Password incorrect. Please try again.')),
  //       );
  //     }
  //   } catch (e) {
  //     // Display error message in case of an exception
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Show the progress indicator
    });

    try {
      // Attempt to create a client and retrieve tokens
      final tokenExchangeStatus = await createClient();

      if (tokenExchangeStatus == 200) {
        // Navigate to the main screen after successful login
        setState(() {
          _isLoading = false; // Hide the progress indicator
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CustomBottomNavigationBar()),
        );
      } else {
        // Handle failed login attempt
        setState(() {
          _isLoading = false; // Hide the progress indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username or Password incorrect. Please try again.')),
        );
      }
    } catch (e) {
      // Handle exceptions during login
      setState(() {
        _isLoading = false; // Hide the progress indicator
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Future<int> createClient() async {
  //   final tokenEndpoint = Uri.parse(
  //       'http://192.168.250.209:8070/auth/realms/FCM_VoIP/protocol/openid-connect/token');
  //   const clientId = 'mobile_client';
  //   final username = _usernameController.text;
  //   final password = _passwordController.text;

  Future<int> createClient() async {
    final tokenEndpoint = Uri.parse(
        'http://192.168.250.209:8070/auth/realms/Push/protocol/openid-connect/token');
    const clientId = 'frontend';
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

        

        // Decode the access token to get the user ID (subject claim 'sub')
        Map<String, dynamic> payload = Jwt.parseJwt(accessToken);
        final userId = payload['sub']; // Extract the user ID
        final name = payload['name'];
        final email = payload['email'];
        
        print(payload);
        // Store tokens and user ID securely
        await _authService.storeToken(userId, username, name, email, accessToken, refreshToken);

        // Store the hashed password with the user ID
        await _authService.storeHashedPassword(userId, password);  // Pass password correctly here
      } else {
        print(
            'Failed to obtain access token. Status code: ${tokenResponse.statusCode}');
        return tokenResponse.statusCode;
      }
    } catch (e) {
      print('Error during token exchange: $e');
      throw Exception('Failed to obtain access token');
    }

    return 200;
  }

  Future<void> _forgotPassword() async {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your username or email')),
      );
      return;
    }

    final forgotPasswordUrl = Uri.parse(
        'http://10.0.2.2:8080/realms/Push/login-actions/reset-credentials?client_id=push-messenger&username=${_usernameController.text}');

    try {
      final response = await http.get(forgotPasswordUrl);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Password reset link sent to your email')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to send reset link: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error sending reset link')),
      );
    }
  }

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