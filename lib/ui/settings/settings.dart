// import 'package:fcm_voip/services/anydesk_service.dart';
// import 'package:fcm_voip/services/auth_service.dart';
// import 'package:fcm_voip/utilities/auth_client.dart';
// import 'package:fcm_voip/utilities/resources/values/colors.dart';
// import 'package:flutter/material.dart';
//
// class SettingsScreen extends StatelessWidget {
//   final AuthClient _authClient = AuthClient();
//   final AuthService _authService = AuthService();
//   final AnyDeskService _anyDeskService = AnyDeskService();
//
//   SettingsScreen({super.key});
//
//   Future<Map<String, String?>> _fetchUserData() async {
//     final userId = await _authService.getCurrentUserId();
//     if (userId != null) {
//       final name = await _authService.getName(userId);
//       final email = await _authService.getEmail(userId);
//       return {'name': name, 'email': email};
//     }
//     return {'name': null, 'email': null};
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.backgroundColor,
//       ),
//       body: FutureBuilder<Map<String, String?>>(
//         future: _fetchUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final name = snapshot.data?['name'] ?? 'Unknown';
//           final email = snapshot.data?['email'] ?? 'No email available';
//
//           return Container(
//             color: AppColors.backgroundColor,
//             child: ListView(
//               children: [
//                 Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                   elevation: 20,
//                   margin: const EdgeInsets.symmetric(horizontal: 24),
//                   color: Colors.grey.shade200,
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         const CircleAvatar(
//                           backgroundImage: AssetImage('assets/images/fcm_logo.png'),
//                         ),
//                         Text(
//                           name,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         Text(
//                           email,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.normal,
//                             color: Colors.grey,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 ListTile(
//                   leading: const Icon(Icons.refresh, color: Colors.black),
//                   title: const Text('Refresh Setups', style: TextStyle(color: Colors.black)),
//                   trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
//                   onTap: () {
//                     // Implement Refresh Setups functionality
//                   },
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(thickness: 0.1),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.inventory, color: Colors.black),
//                   title: const Text('View Inventory', style: TextStyle(color: Colors.black)),
//                   trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
//                   onTap: () {
//                     // Implement View Inventory functionality
//                   },
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(thickness: 0.1),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.inventory_2, color: Colors.black),
//                   title: const Text('View Faulty Inventory', style: TextStyle(color: Colors.black)),
//                   trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
//                   onTap: () {
//                     // Implement View Faulty Inventory functionality
//                   },
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(thickness: 0.1),
//                 ),
//                 // ListTile(
//                 //   leading: const Icon(Icons.pin, color: Colors.black),
//                 //   title: const Text('Reset Offline Pin', style: TextStyle(color: Colors.black)),
//                 //   trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
//                 //   onTap: () {
//                 //     // Implement Reset Offline Pin functionality
//                 //   },
//                 // ),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(thickness: 0.1),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.support, color: Colors.black),
//                   title: const Text('Support', style: TextStyle(color: Colors.black)),
//                   trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
//                   onTap: () {
//                     _anyDeskService.openAnyDesk();
//                   },
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(thickness: 0.1),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.exit_to_app, color: Colors.black),
//                   title: const Text('Sign out', style: TextStyle(color: Colors.black)),
//                   trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.3),
//                   onTap: () {
//                     _authClient.logout(context);
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// New One

// import 'package:fcm_voip/services/anydesk_service.dart';
// import 'package:fcm_voip/services/auth_service.dart';
// import 'package:fcm_voip/utilities/auth_client.dart';
// import 'package:fcm_voip/utilities/resources/values/colors.dart';
// import 'package:flutter/material.dart';
//
// class SettingsScreen extends StatelessWidget {
//   final AuthClient _authClient = AuthClient();
//   final AuthService _authService = AuthService();
//   final AnyDeskService _anyDeskService = AnyDeskService();
//
//   SettingsScreen({super.key});
//
//   Future<Map<String, String?>> _fetchUserData() async {
//     final userId = await _authService.getCurrentUserId();
//     if (userId != null) {
//       final name = await _authService.getName(userId);
//       final email = await _authService.getEmail(userId);
//       return {'name': name, 'email': email};
//     }
//     return {'name': null, 'email': null};
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text("Settings", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: FutureBuilder<Map<String, String?>>(
//         future: _fetchUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final name = snapshot.data?['name'] ?? 'Unknown User';
//           final email = snapshot.data?['email'] ?? 'No email available';
//
//           return ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//             children: [
//               // Profile Section
//               // Row(
//               //   children: [
//               //     const CircleAvatar(
//               //       radius: 30,
//               //       backgroundImage: AssetImage('assets/images/fcm_logo.png'),
//               //     ),
//               //     const SizedBox(width: 12),
//               //     Column(
//               //       crossAxisAlignment: CrossAxisAlignment.start,
//               //       children: [
//               //         Text(
//               //           name,
//               //           style: const TextStyle(
//               //             fontSize: 18,
//               //             fontWeight: FontWeight.w600,
//               //           ),
//               //         ),
//               //         const Text(
//               //           "Edit your profile",
//               //           style: TextStyle(
//               //             fontSize: 14,
//               //             color: Colors.grey,
//               //           ),
//               //         ),
//               //       ],
//               //     ),
//               //     const Spacer(),
//               //     ElevatedButton(
//               //       style: ElevatedButton.styleFrom(
//               //         backgroundColor: Colors.blue,
//               //         shape: RoundedRectangleBorder(
//               //           borderRadius: BorderRadius.circular(8),
//               //         ),
//               //       ),
//               //       onPressed: () {
//               //         // Edit profile action
//               //       },
//               //       child: const Text("Edit"),
//               //     ),
//               //   ],
//               // ),
//
//               Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                   elevation: 20,
//                   margin: const EdgeInsets.symmetric(horizontal: 24),
//                   // color: Colors.grey.shade200,
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         const CircleAvatar(
//                           backgroundImage: AssetImage('assets/images/fcm_logo.png'),
//                         ),
//                         Text(
//                           name,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         Text(
//                           email,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.normal,
//                             color: Colors.grey,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 30),
//
//               // General Settings Card
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "General Settings",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SwitchListTile(
//                         title: const Text("Location Settings"),
//                         subtitle: const Text(
//                           "Allow apps to use location settings for your profile",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         value: true,
//                         onChanged: (bool value) {
//                           // Handle toggle for Location Settings
//                         },
//                       ),
//
//                                       const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(thickness: 0.1),
//                 ),
//                       SwitchListTile(
//                         title: const Text("Push Notifications"),
//                         subtitle: const Text(
//                           "Receive alerts about push notifications",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         value: true,
//                         onChanged: (bool value) {
//                           // Handle toggle for Push Notifications
//                         },
//                       ),
//                                       const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(thickness: 0.1),
//                 ),
//                       SwitchListTile(
//                         title: const Text("Email Notifications"),
//                         subtitle: const Text(
//                           "Receive updates via email",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         value: false,
//                         onChanged: (bool value) {
//                           // Handle toggle for Email Notifications
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Support Card
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Support",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       _buildSupportItem("Terms of Service"),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Divider(thickness: 0.1),
//                       ),
//                       _buildSupportItem("Data Policy"),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Divider(thickness: 0.1),
//                       ),
//                       _buildSupportItem("About"),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Divider(thickness: 0.1),
//                       ),
//                       _buildSupportItem("Help / FAQ"),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Divider(thickness: 0.1),
//                       ),
//                       _buildSupportItem("Contact us"),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Logout Button
//               Center(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: () {
//                     _authClient.logout(context);
//                   },
//                   child: const Text("Log out"),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildSupportItem(String title) {
//     return ListTile(
//       title: Text(title, style: const TextStyle(fontSize: 14)),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
//       onTap: () {
//         _anyDeskService.openAnyDesk();
//       },
//     );
//   }
// }


import 'package:fcm_voip/services/anydesk_service.dart';
import 'package:fcm_voip/services/auth_service.dart';
import 'package:fcm_voip/utilities/auth_client.dart';
import 'package:fcm_voip/utilities/resources/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  final AuthClient _authClient = AuthClient();
  final AuthService _authService = AuthService();
  final AnyDeskService _anyDeskService = AnyDeskService();

  // Initialize SettingsController
  final SettingsController _controller = Get.put(SettingsController());

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
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Settings",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final name = snapshot.data?['name'] ?? 'Unknown User';
          final email = snapshot.data?['email'] ?? 'No email available';

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 20,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Extract initials from the full name
                      CircleAvatar(
                        backgroundColor: Colors.grey[300], // Light gray background
                        radius: 30, // Adjust the size of the circle
                        child: Text(
                          _getInitials(name), // Call the method to get initials
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white
                          )
                        ),
                      ),
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        email,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
,
              const SizedBox(height: 30),

              // General Settings Card with GetX state management
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        "General Settings",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Obx(() {
                        return SwitchListTile(
                          title: Text("Location Settings", style: GoogleFonts.poppins(),),
                          subtitle: Text(
                            "Allow apps to use location settings",
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          value: _controller.locationSettings.value,
                          onChanged: (bool value) async {
                            _controller.locationSettings.value = value;
                            if (value) {
                              // Request permission to use location
                              LocationPermission permission = await Geolocator.requestPermission();
                              if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                                // Handle permission denial
                                print('Location permission denied');
                              } else {
                                // Enable location services
                                bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                                if (!serviceEnabled) {
                                  // Ask the user to enable location services
                                  print('Location services are not enabled');
                                } else {
                                  print('Location permission granted');
                                }
                              }
                            } else {
                              // Disable location services or update the setting accordingly
                              print('Location services disabled');
                            }
                          },
                        );
                      }),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(thickness: 0.1),
                      ),
                      Obx(() {
                        return SwitchListTile(
                          title: Text("Push Notifications",
                               style: GoogleFonts.poppins()
                          ),
                          subtitle: Text(
                            "Receive alerts about push notifications",
                              style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          value: _controller.pushNotifications.value,
                          onChanged: (bool value) {
                            _controller.pushNotifications.value = value;
                          },
                        );
                      }),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(thickness: 0.1),
                      ),
                      Obx(() {
                        return SwitchListTile(
                          title: Text("Email Notifications",
                              style: GoogleFonts.poppins()),
                          subtitle: Text(
                            "Receive updates via email",
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          value: _controller.emailNotifications.value,
                          onChanged: (bool value) {
                            _controller.emailNotifications.value = value;
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Support Card
              // Support Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        "Support", style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _buildSupportItem("Terms of Service", context),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(thickness: 0.1),
                      ),
                      _buildSupportItem("Data Policy", context),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(thickness: 0.1),
                      ),
                      _buildSupportItem("About", context),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(thickness: 0.1),
                      ),
                      _buildSupportItem("Contact us", context),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(thickness: 0.1),
                      ),
                      _buildHelpItem("AnyDesk Support", context),

                    ],
                  ),
                ),
              ),

              // const SizedBox(height: 30),
              //
              // // Logout Button
              // Center(
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.red,
              //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     onPressed: () {
              //       _authClient.logout(context);
              //     },
              //     child: const Text("Log out"),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }

  // Function to show the bottom sheet
  void _showSupportBottomSheet(BuildContext context, String title) {
    String content = '';

    // Customize content based on the title of the tapped item
    switch (title) {
      case "Terms of Service":
        content = '''
      Welcome to our application! By using our services, you agree to the following terms and conditions:

      1. User Account: You are responsible for maintaining the confidentiality of your account and password.
      2. Data Usage: We may collect personal data for the purpose of enhancing your user experience.
      3. Content Ownership: All content provided by the app remains the intellectual property of the service provider.
      4. Service Limitations: The app may undergo maintenance, causing temporary interruptions in service.

      Please review these terms thoroughly before continuing to use our services. If you disagree with any part of these terms, please refrain from using the app.
      ''';
        break;
      case "Data Policy":
        content = '''

      Your privacy is important to us, and we are committed to protecting the information you share with us. This policy outlines the types of data we collect and how we use it:

      1. Personal Information: We may collect details like your name, email, and preferences to improve your user experience.
      2. Usage Data: Information such as your device type, location, and app interactions may be collected to enhance app functionality.
      3. Cookies: We may use cookies to personalize your experience and analyze usage patterns.
      4. Data Security: We implement security measures to protect your data from unauthorized access or disclosure.

      By using the app, you consent to the collection and use of your data in accordance with this policy. For further inquiries, please contact support.
      ''';
        break;
      case "About":
        content = '''

      This app is designed to provide seamless communication and management of tasks within your organization. Some of the core features include:

      - Real-time Notifications: Stay up to date with task assignments and updates.
      - Secure Authentication: Log in securely using modern authentication methods.
      - Task Management: View and manage tasks, with the ability to filter and track their progress.
      - Support: Easy access to support options in case you encounter any issues.

      Our mission is to make your work more efficient and organized. We hope you find the app helpful in your daily activities.
      ''';
        break;
      case "AnyDesk Support":
        content = 'Remote assistance...';
        break;
      case "Contact us":
        content = '''

      If you have any questions, concerns, or feedback, feel free to reach out to our support team:

      - Email: support@stlghana.com
      - Phone: +233 30-274-5104
      - Website: www.stlghana.com/contact

      Our team is available from Monday to Friday, 9 AM to 6 PM (UTC). We strive to respond to all inquiries within 24 hours.
      ''';
        break;
    }

    // Open the bottom sheet with the corresponding content
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
               style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(content, style: GoogleFonts.poppins(fontSize: 14)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to build each support item
  // Widget _buildSupportItem(String title, BuildContext context) {
  //   return InkWell(
  //     onTap: () => _showSupportBottomSheet(context, title),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 10),
  //       child: Text(
  //         title,
  //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSupportItem(String title, BuildContext context) {
    return ListTile(
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      // trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () => _showSupportBottomSheet(context, title)

    );
  }

  Widget _buildHelpItem(String title, BuildContext context) {
    return ListTile(
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: () {
        _anyDeskService.openAnyDesk();
      },
    );
  }

  // Method to get the initials from the full name
  String _getInitials(String fullName) {
    List<String> nameParts = fullName.split(' ');
    if (nameParts.length > 1) {
      // Return the first letter of the first and last name
      return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}';
    }
    // In case there's no last name (single name), return just the first letter
    return '${nameParts[0][0]}';
  }
}

