import 'package:fcm_voip/ui/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 56, 71, 96), // Dark blue background color
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image at the top
          Container(
            margin: const EdgeInsets.only(top: 50.0),
            child: Image.asset(
              'assets/images/fcm_logo.png', 
              // height: 150,
              // fit: BoxFit.cover,
            ),
          ),
          // Welcome text
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Welcome to the FCM-VoIP Application',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Login button
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Login()), // Navigate to Login page
                );
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 251, 164, 38),
                minimumSize: const Size(double.infinity, 50), // Full width
              ),
            ),
          ),
          // Text under the login button

          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Please login to continue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle floating button press
        },
        backgroundColor: const Color.fromARGB(255, 251, 164, 38),
        child: const Icon(Icons.question_mark_rounded),
      ),
    );
  }
}
