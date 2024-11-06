import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fcm_voip/services/auth_service.dart';
import 'package:fcm_voip/ui/login/login.dart';
import 'package:fcm_voip/utilities/activity_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// This class, handles the user authentication process in the application. 
// It allows users to select their account from a list of stored users in Hive, prompts for 
// their password, and verifies the password using hashed values. If the authentication 
// is successful, it navigates to the main application interface. If no users are found, 
// it redirects to a login screen for new account creation. The class also manages failed 
// login attempts and provides feedback to the user in case of incorrect password entries.
//
// Author: Bryan Danquah


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  String _selectedUser = '';
  String _password = '';
  String? _errorText;
  List<Map<String, String?>> _users = [];
  int _failedAttempts = 0;
  final int _maxAttempts = 3;

  bool _isUserSelectionVisible = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Set admin password during app initialization if needed
    await _authService.setAdminPassword('SuperSecretAdminPassword123!');

    // Get all users stored in Hive
    _users = _authService.getAllUsers().cast<Map<String, String?>>();

    if (_users.isNotEmpty) {
      // If users exist, prompt user to select an account
      _showUserSelection();
    } else {
      // No users found, navigate to login screen for a new account
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  void _showUserSelection() {
    if (_isUserSelectionVisible) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              // Exit the app when the back button is pressed
              SystemNavigator.pop();
              return false; // Prevents the modal from being dismissed
            },
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/fcm_logo.png',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'back',
                            style: TextStyle(
                              color: Color(0xFFFFC107),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (_users.isNotEmpty)
                    ..._users.map((user) => Column(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[850],
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon:
                                  const Icon(Icons.person, color: Colors.white),
                              label: Text(
                                user['username'] ?? 'Unknown User',
                                style: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _selectedUser = user['userId']!;
                                _promptForPassword();
                              },
                            ),
                            const SizedBox(
                                height: 16.0), // Add space between buttons
                          ],
                        )),
                  const SizedBox(height: 16.0),
                  Divider(color: Colors.grey[700]),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: const Text(
                      "Log in as a new user",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          );
        },
      ).whenComplete(() {
        // Reset the visibility flag when the user selection is dismissed
        _isUserSelectionVisible = true;
      });
    }
  }

  void _promptForPassword() {
  // Close the user selection before showing the password prompt
  Navigator.pop(context);
  _isUserSelectionVisible = false; // Set visibility to false

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) { // Local setState for modal
          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              top: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                    'assets/images/fcm_logo.png',
                    height: 100,
                    width: 100,
                  ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  "Enter your password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                      _errorText = null; // Clear error message when typing
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[850],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: _errorText != null ? Colors.red : Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: _errorText != null ? Colors.red : Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: _errorText != null ? Colors.red : Colors.blue,
                      ),
                    ),
                  ),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 8.0),
                  Text(
                    _errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () => _checkPassword(setState),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          );
        }
      );
    },
  ).whenComplete(() {
    // Reset the visibility flag when the password prompt is dismissed
    _isUserSelectionVisible = true;
  });
}

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }


  // Check password function with error handling for incorrect password
Future<void> _checkPassword(StateSetter setState) async {
  final savedPasswordHash = await _authService.getHashedPassword(_selectedUser);
  final enteredPasswordHash = _hashPassword(_password);

  if (enteredPasswordHash == savedPasswordHash) {
    // Password matches, reset failed attempts and navigate to main screen
    _failedAttempts = 0;
    await _authService.setCurrentUserId(_selectedUser); // Save current user ID
    Navigator.of(context).pop(); 
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => const CustomBottomNavigationBar()),
    );
  } else {
    // Incorrect password
    _failedAttempts++;
    if (_failedAttempts >= _maxAttempts) {
      // After max failed attempts, force re-login
      _promptReLogin();
    } else {
      // Set error message and red border in the modal
      setState(() {
        _errorText = "Incorrect password, please try again.";
      });
    }
  }
}


  // Prompt for re-login after too many failed attempts
  void _promptReLogin() {
    Navigator.of(context).pop(); // Close the password dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Too many failed attempts"),
          content: const Text("Please log in again."),
          actions: [
            TextButton(
              child: const Text("Re-Login"),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
