import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fcm_voip/services/auth_service.dart';
import 'package:fcm_voip/ui/login/login.dart';
import 'package:fcm_voip/utilities/activity_main.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  String _selectedUser = '';
  String _password = '';
  List<Map<String, String?>> _users = [];
  int _failedAttempts = 0;
  final int _maxAttempts = 3;

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

  // Show dialog to choose existing user or new login
  void _showUserSelection() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Continue with:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_users.isNotEmpty)
                ..._users.map((user) => ListTile(
                      title: Text('• ${user['username'] ?? 'Unknown User'}'), 
                      onTap: () {
                        _selectedUser = user[
                            'userId']!; 
                        _promptForPassword();
                      },
                    )),
              const Divider(),
              ListTile(
                title: const Text("Log in as a new user"),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _promptForPassword() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter your password"),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              _password = value;
            },
            decoration: const InputDecoration(hintText: "Password"),
          ),
          actions: [
            TextButton(
              onPressed: _checkPassword,
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Check if entered password is correct
  Future<void> _checkPassword() async {
    final savedPasswordHash =
        await _authService.getHashedPassword(_selectedUser);
    final enteredPasswordHash = _hashPassword(_password);

    if (enteredPasswordHash == savedPasswordHash) {
      // Password matches, reset failed attempts and navigate to main screen
      _failedAttempts = 0;
      Navigator.of(context).pop(); // Close dialog
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()),
      );
    } else {
      // Incorrect password
      _failedAttempts++;
      if (_failedAttempts >= _maxAttempts) {
        // After max failed attempts, force re-login
        _promptReLogin();
      } else {
        // Provide feedback for incorrect password and allow retry
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Incorrect password, please try again.")),
        );
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
