import 'package:fcm_voip/main.dart';
import 'package:fcm_voip/utilities/auth_client.dart';
import 'package:fcm_voip/utilities/activity_main.dart';
import 'package:fcm_voip/utilities/network.dart';
import 'package:fcm_voip/utilities/token_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthClient _authClient = AuthClient();
  final Network _network = Network();
  bool _isLoading = false;
  // final UpdateService _updateService = UpdateService();

  @override
  void initState() {
    super.initState();
    // _updateService.initUpdateChecker(context);

    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    _loadSavedCredentials();
  }

  @override
  void dispose() {
    // _updateService.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await retrieveCredentials();
    if (credentials['username'] != null && credentials['password'] != null) {
      _usernameController.text = credentials['username']!;
      _passwordController.text = credentials['password']!;
    }
  }

  Future<void> storeCredentials(String username, String password) async {
    await secureStorage.write(key: 'username', value: username);
    await secureStorage.write(key: 'password', value: password);
  }

  Future<Map<String, String?>> retrieveCredentials() async {
    String? username = await secureStorage.read(key: 'username');
    String? password = await secureStorage.read(key: 'password');
    return {'username': username, 'password': password};
  }

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    if (await _network.isConnectedToNetwork()) {
      await Future.delayed(const Duration(milliseconds: 500));
      // Online login
      try {
        final username = _usernameController.text;
        final password = _passwordController.text;
        // ignore: use_build_context_synchronously
        await _authClient.createClient(context, username, password);
      } catch (e) {
        if (kDebugMode) {
          print('Error during login: $e');
        }
      }
    } else {
      // Offline login
      final credentials = await retrieveCredentials();
      if (credentials['username'] == _usernameController.text &&
          credentials['password'] == _passwordController.text) {
        // Allow offline access
        final lastAccessToken = await secureStorage.read(key: 'access_token');
        final lastRefreshToken = await secureStorage.read(key: 'refresh_token');
        final lastSub = await secureStorage.read(key: 'sub');

        if (lastAccessToken != null &&
            lastRefreshToken != null &&
            lastSub != null) {
          setState(() {
            TokenManager.setTokens(lastAccessToken, lastRefreshToken, lastSub);
          });

          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => CustomBottomNavigationBar()),
          );
        } else {
          if (kDebugMode) {
            print('No valid tokens available for offline use');
          }
        }
      } else {
        if (kDebugMode) {
          print('No stored credentials or invalid credentials');
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 56, 71, 96),
      body: Center(
        child: _isLoading // Show loading wheel while logging in
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/fcm_logo.png',
                  ),
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      color: Color.fromARGB(255, 50, 63, 86),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Check internet status
                            // InternetStatusWidget(),
                            // Text(
                            //   'Login',
                            //   style: TextStyle(
                            //     fontSize: 24,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.black,
                            //   ),
                            //   textAlign: TextAlign.center,
                            // ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextField(
                              key: const Key('usernameField'),
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: "Username",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 40),
                            TextField(
                              key: const Key('passwordField'),
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: const Icon(Icons.lock),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 50),
                            ElevatedButton(
                              key: const Key('loginButton'),
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor:
                                    const Color.fromARGB(255, 251, 164, 38),
                              ),
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
