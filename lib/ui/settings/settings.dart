import 'package:fcm_voip/utilities/auth_client.dart';
import 'package:fcm_voip/utilities/resources/values/colors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final AuthClient _authClient = AuthClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Menu"),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Container(
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
              child: const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/fcm_logo.png'),
                    ),
                    Text(
                      'Derrick Donkoh',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'derrickdo@stlghana.com',
                      style: TextStyle(
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
            const SizedBox(
              height: 40,
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.black),
              title: const Text('Refresh Setups',
                  style: TextStyle(color: Colors.black)),
              trailing:
                  const Icon(
                    Icons.arrow_forward_ios, 
                    color: Colors.black,
                    size: 15.3,
                    ),
              onTap: () {
                // Navigate to Refresh Setups screen
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0
              ),
              child: Divider(thickness: 0.1),
            ),
            // Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.inventory, color: Colors.black),
              title: const Text('View Inventory',
                  style: TextStyle(color: Colors.black)),
              trailing:
                  const Icon(
                    Icons.arrow_forward_ios,
                     color: Colors.black,
                     size: 15.3
                     ),
              onTap: () {
                
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0
              ),
              child: Divider(thickness: 0.1),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2, color: Colors.black),
              title: const Text('View Faulty Inventory',
                  style: TextStyle(color: Colors.black)),
              trailing:
                  const Icon(
                    Icons.arrow_forward_ios,
                   color: Colors.black,
                   size: 15.3
                   ),
              onTap: () {
                
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0
              ),
              child: Divider(thickness: 0.1),
            ),
            ListTile(
              leading: const Icon(Icons.pin, color: Colors.black),
              title: const Text('Reset Offline Pin',
                  style: TextStyle(color: Colors.black)),
              trailing:
                  const Icon(
                    Icons.arrow_forward_ios,
                     color: Colors.black,
                     size: 15.3
                     ),
              onTap: () {
                
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0
              ),
              child: Divider(thickness: 0.1),
            ),
            ListTile(
              leading: const Icon(Icons.support, color: Colors.black),
              title:
                  const Text('Support', style: TextStyle(color: Colors.black)),
              trailing:
                  const Icon(
                    Icons.arrow_forward_ios,
                   color: Colors.black,
                   size: 15.3
                   ),
              onTap: () {
                
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0
              ),
              child: Divider(thickness: 0.1),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.black),
              title:
                  const Text('Sign out', style: TextStyle(color: Colors.black)),
              trailing:
                  const Icon(
                    Icons.arrow_forward_ios,
                     color: Colors.black,
                     size: 15.3
                     ),
              onTap: () {
                //  _logout(context);
                _authClient.logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingsScreen(),
    theme: ThemeData.dark(), 
  ));
}
