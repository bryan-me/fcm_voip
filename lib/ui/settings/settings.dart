import 'package:fcm_voip/services/anydesk_service.dart';
import 'package:fcm_voip/services/auth_service.dart';
import 'package:fcm_voip/utilities/auth_client.dart';
import 'package:fcm_voip/utilities/resources/values/colors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final AuthClient _authClient = AuthClient();
  final AuthService _authService = AuthService();
  final AnyDeskService _anyDeskService = AnyDeskService();

  SettingsScreen({super.key});

  Future<Map<String, String?>> _fetchUserData() async {
    final userId = await _authService.getCurrentUserId();
    if (userId != null) {
      final name = await _authService.getName(userId);
      final email = await _authService.getEmail(userId);
      return {'name': name, 'email': email};
    }
    return {'name': null, 'email': null};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final name = snapshot.data?['name'] ?? 'Unknown';
          final email = snapshot.data?['email'] ?? 'No email available';

          return Container(
            color: AppColors.backgroundColor,
            child: ListView(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/images/fcm_logo.png'),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ListTile(
                  leading: const Icon(Icons.refresh, color: Colors.black),
                  title: const Text('Refresh Setups', style: TextStyle(color: Colors.black)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
                  onTap: () {
                    // Implement Refresh Setups functionality
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(thickness: 0.1),
                ),
                ListTile(
                  leading: const Icon(Icons.inventory, color: Colors.black),
                  title: const Text('View Inventory', style: TextStyle(color: Colors.black)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
                  onTap: () {
                    // Implement View Inventory functionality
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(thickness: 0.1),
                ),
                ListTile(
                  leading: const Icon(Icons.inventory_2, color: Colors.black),
                  title: const Text('View Faulty Inventory', style: TextStyle(color: Colors.black)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
                  onTap: () {
                    // Implement View Faulty Inventory functionality
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(thickness: 0.1),
                ),
                ListTile(
                  leading: const Icon(Icons.pin, color: Colors.black),
                  title: const Text('Reset Offline Pin', style: TextStyle(color: Colors.black)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
                  onTap: () {
                    // Implement Reset Offline Pin functionality
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(thickness: 0.1),
                ),
                ListTile(
                  leading: const Icon(Icons.support, color: Colors.black),
                  title: const Text('Support', style: TextStyle(color: Colors.black)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
                  onTap: () {
                    _anyDeskService.openAnyDesk();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(thickness: 0.1),
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.black),
                  title: const Text('Sign out', style: TextStyle(color: Colors.black)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
                  onTap: () {
                    _authClient.logout(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}