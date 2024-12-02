// import 'package:fcm_voip/ui/settings/settings.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../../controllers/base_data_controller.dart';
// import '../../data/model/base_data.dart';
// import '../../services/auth_service.dart';
// import '../controllers/count_controller.dart';
// import '../utilities/auth_client.dart';
// import '../utilities/form.dart';
// import '../utilities/note_card.dart';
//
// class FilteredScreen extends StatefulWidget {
//   final String type;
//   // Example: Define it in your state or pass it as a parameter to the widget
//
//   const FilteredScreen({required this.type});
//
//   @override
//   _FilteredScreenState createState() => _FilteredScreenState();
// }
//
// class _FilteredScreenState extends State<FilteredScreen> {
//   late Future<List<BaseData>> _filteredDataFuture;
//   late BaseDataController _baseDataController;
//   final AuthService _authService = AuthService();
//
//   final bool isUserFromActiveDirectory = true;
//   final CountController _countController = Get.put(CountController()); // Initialize the GetX controller
//
//   @override
//   void initState() {
//     super.initState();
//
//     _baseDataController = BaseDataController(
//       baseUrl: 'http://192.168.250.209:8060/api/v1/activity-service',
//       authService: _authService,
//     );
//
//     _filteredDataFuture = _initializeFilteredData();
//   }
//
//   Future<List<BaseData>> _initializeFilteredData() async {
//     try {
//       final currentUserId = await _authService.getCurrentUserId();
//       if (currentUserId == null) {
//         throw Exception('No user ID found. Please log in again.');
//       }
//
//       final allData = await _baseDataController.fetchBaseData(currentUserId);
//       return allData.where((data) => data.type == widget.type).toList();
//     } catch (error) {
//       throw Exception('Error fetching ${widget.type}s: $error');
//     }
//   }
//
//   void showFilterBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => const Center(child: Text('Filter options')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text('${widget.type}s', style: const TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: CircleAvatar(
//             backgroundImage: AssetImage('assets/images/fcm_logo.png'),
//           ),
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             icon: const CircleAvatar(
//               backgroundImage: AssetImage('assets/images/fcm_logo.png'), // Replace with dynamic user profile image
//             ),
//             onSelected: (value) {
//               switch (value) {
//                 case 'Profile':
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SettingsScreen()),
//                   );
//                   break;
//                 case 'Settings':
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SettingsScreen()),
//                   );
//                   break;
//                 case 'Change Password':
//                   if (!isUserFromActiveDirectory) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SettingsScreen()),
//                     );
//                   }
//                   break;
//                 case 'Logout':
//                   showLogoutConfirmationDialog(context);
//                   break;
//               }
//             },
//             itemBuilder: (context) {
//               return [
//                 const PopupMenuItem(
//                   value: 'Profile',
//                   child: Text('Profile & Legal'),
//                 ),
//                 const PopupMenuItem(
//                   value: 'Settings',
//                   child: Text('Settings'),
//                 ),
//                 if (!isUserFromActiveDirectory)
//                   const PopupMenuItem(
//                     value: 'Change Password',
//                     child: Text('Change Password'),
//                   ),
//                 const PopupMenuItem(
//                   value: 'Logout',
//                   child: Text('Logout'),
//                 ),
//               ];
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FutureBuilder<List<BaseData>>(
//               future: _filteredDataFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (snapshot.hasData) {
//                   final filteredData = snapshot.data!;
//                   int count = filteredData.length;
//
//                   // Update the count in CountController
//                   _countController.updateCount(widget.type, count);
//
//                   return Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '$count ${widget.type}${count == 1 ? '' : 's'}',
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 16),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: filteredData.length,
//                             itemBuilder: (context, index) {
//                               final data = filteredData[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   // Navigate to the detailed view
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           FormBuild(formId: data.formId),
//                                     ),
//                                   );
//                                 },
//                                 child: NoteCard(
//                                   title: data.title ?? 'Title',
//                                   region: data.client ?? 'Unknown region',
//                                   branchName: data.project ?? 'Unknown branch',
//                                   customer: data.client ?? 'Unknown customer',
//                                   siteId: data.siteId ?? 'N/A',
//                                   dateAssigned: data.dateAssigned != null
//                                       ? data.dateAssigned.toString()
//                                       : 'N/A',
//                                   dateReceived: data.dateReceived != null
//                                       ? data.dateReceived.toString()
//                                       : 'N/A',
//                                   color: Colors.blue.shade100,
//                                   icon: Icons.camera_alt_sharp,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return const Center(child: Text('No data found.'));
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showLogoutConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Logout"),
//           content: const Text("Are you sure you want to log out?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 AuthClient().logout(context); // Replace with your logout logic
//               },
//               child: const Text("Logout"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

///New
import 'package:fcm_voip/ui/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/base_data_controller.dart';
import '../../data/model/base_data.dart';
import '../../services/auth_service.dart';
import '../controllers/count_controller.dart';
import '../controllers/favorite_controller.dart';
import '../services/websocket_service.dart';
import '../utilities/auth_client.dart';
import '../utilities/filter.dart';
import '../utilities/form.dart';
import '../utilities/note_card.dart';
import 'favorite.dart';

class FilteredScreen extends StatefulWidget {
  final String type;

  const FilteredScreen({required this.type});

  @override
  _FilteredScreenState createState() => _FilteredScreenState();
}

class _FilteredScreenState extends State<FilteredScreen> {
  late BaseDataController _baseDataController;
  final AuthService _authService = AuthService();
  final bool isUserFromActiveDirectory = true;
  final WebSocketService _webSocketService = WebSocketService('wss://smpp.stlghana.com/connection/websocket');
  final CountController _countController = Get.put(CountController());
  final FavoriteController _favoriteController = Get.put(FavoriteController());

  @override
  void initState() {
    super.initState();
    // Initialize the BaseDataController
    _baseDataController = Get.put(BaseDataController(
      baseUrl: 'http://192.168.250.209:8060/api/v1/activity-service',
      authService: _authService,
      webSocketService: _webSocketService, // Pass WebSocketService here

    ));

    // Fetch data initially for the specific type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _baseDataController.fetchBaseDataByType(widget.type);
    });
  }

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const FilterOptionsModal(), // Define your filter options modal
    );
  }

  @override
  Widget build(BuildContext context) {
    // final favoriteCount = _favoriteController.favorites.length;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          '${widget.type}s'.toUpperCase(),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, // Make the font bold
            ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading:
          PopupMenuButton<String>(
            icon: Container(
              width: 100,
              height: 100,
              child: FutureBuilder<String?>(
                future: _fetchUserName(), // This is fine; `FutureBuilder` dynamically evaluates it
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Loading indicator
                  }

                  final name = snapshot.data ?? 'User';
                  final initials =_getInitials(name);// Fallback name if `null`
                  return CircleAvatar(
                    backgroundColor: Colors.blue[300], // Light gray background
                    radius: 50,
                    child: Text(
                      initials, // Extract initials
                      style: TextStyle(
                        fontSize: initials.length > 2 ? 16 : 17, // Dynamically adjust font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text color
                      ),
                    ),
                  );
                },
              ),
            ),
            onSelected: (value) {
              switch (value) {
                case 'Profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                  break;
                case 'Settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                  break;
                case 'Change Password':
                  if (!isUserFromActiveDirectory) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  }
                  break;
                case 'Logout':
                  showLogoutConfirmationDialog(context);
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'Profile',
                  child: Text('Profile & Legal'),
                ),
                const PopupMenuItem(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                if (!isUserFromActiveDirectory)
                  const PopupMenuItem(
                    value: 'Change Password',
                    child: Text('Change Password'),
                  ),
                const PopupMenuItem(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        actions: [
          Obx(() {
            final favoriteCount = Get.find<FavoriteController>().favorites.length; // Observing the favorite count
            return Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.star_border_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoriteScreen()),
                    );
                    // Navigator.push(
                    //   context,
                    //   PageRouteBuilder(
                    //     pageBuilder: (context, animation, secondaryAnimation) => FavoriteScreen(),
                    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    //       const begin = Offset(1.0, 0.0);
                    //       const end = Offset.zero;
                    //       const curve = Curves.easeInOut;
                    //
                    //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    //       var offsetAnimation = animation.drive(tween);
                    //
                    //       return SlideTransition(position: offsetAnimation, child: child);
                    //     },
                    //   ),
                    // );
                  },
                ),
                if (favoriteCount > 0) // Only show the circle if there are favorites
                  Positioned(
                    right: 8, // Adjust position as needed
                    top: 3,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$favoriteCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Obx(() {
        if (_baseDataController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (_baseDataController.filteredData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
              children: [
                Image.asset('assets/images/no_data.png', width: 150, height: 150), // Use Image.asset
                const SizedBox(height: 16), // Add some spacing between the image and text
                Text(
                  'No ${widget.type} assigned.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _baseDataController.filteredData.length,
            itemBuilder: (context, index) {
              final data = _baseDataController.filteredData[index];
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => FormBuild(formId: data.formId),
                  //   ),
                  // );

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => FormBuild(formId: data.formId!),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(position: offsetAnimation, child: child);
                      },
                    ),
                  );
                },
                child: NoteCard(
                  title: data.title ?? 'Title',
                  region: data.client ?? 'Unknown region',
                  type: data.type ?? 'Uknown type',
                  branchName: data.project ?? 'Unknown branch',
                  customer: data.client ?? 'Unknown customer',
                  siteId: data.siteId ?? 'N/A',
                  dateAssigned: data.dateAssigned?.toString() ?? 'N/A',
                  dateReceived: data.dateReceived?.toString() ?? 'N/A',
                  color: Colors.black,
                  icon: Icons.camera_alt_sharp,
                  isFavorited: _favoriteController.isFavorite(data),
                  onFavoriteToggle: () => _favoriteController.toggleFavorite(data),
                  data: data,
                ),
              );
            },
          );
        }
      }),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.grey[100],
  //     appBar: AppBar(
  //       title: Text('${widget.type}s'.toUpperCase(),
  //           style: const TextStyle(color: Colors.black)),
  //       backgroundColor: Colors.white,
  //       elevation: 0,
  //       centerTitle: true,
  //       leading: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: PopupMenuButton<String>(
  //           icon: const SizedBox(
  //             width: 100, // Set the desired width
  //             height: 100, // Set the desired height
  //             child: CircleAvatar(
  //               radius: 50, // Adjust the radius as needed
  //               backgroundImage: AssetImage('assets/images/profile.jpg'), // Path to your image
  //             ),
  //           ),
  //           onSelected: (value) {
  //             switch (value) {
  //               case 'Profile':
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => SettingsScreen()),
  //                 );
  //                 break;
  //               case 'Settings':
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => SettingsScreen()),
  //                 );
  //                 break;
  //               case 'Change Password':
  //                 if (!isUserFromActiveDirectory) {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => SettingsScreen()),
  //                   );
  //                 }
  //                 break;
  //               case 'Logout':
  //                 showLogoutConfirmationDialog(context);
  //                 break;
  //             }
  //           },
  //           itemBuilder: (context) {
  //             return [
  //               const PopupMenuItem(
  //                 value: 'Profile',
  //                 child: Text('Profile & Legal'),
  //               ),
  //               const PopupMenuItem(
  //                 value: 'Settings',
  //                 child: Text('Settings'),
  //               ),
  //               if (!isUserFromActiveDirectory)
  //                 const PopupMenuItem(
  //                   value: 'Change Password',
  //                   child: Text('Change Password'),
  //                 ),
  //               const PopupMenuItem(
  //                 value: 'Logout',
  //                 child: Text('Logout'),
  //               ),
  //             ];
  //           },
  //         ),
  //       ),
  //       actions: [
  //         IconButton(
  //           icon: const Icon(Icons.filter_list),
  //           onPressed: () {
  //             showModalBottomSheet(
  //               context: context,
  //               builder: (BuildContext context) {
  //                 return const FilterOptionsModal(); // Use the filter modal widget
  //               },
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Obx(() {
  //             final filteredData = _baseDataController.filteredData;
  //
  //             if (_baseDataController.isLoading.value) {
  //               return const Center(child: CircularProgressIndicator());
  //             }
  //
  //             if (filteredData.isEmpty) {
  //               return Center(child: Text('No ${widget.type} data currently.'));
  //             }
  //
  //             int count = filteredData.length;
  //             _countController.updateCount(widget.type, count);
  //
  //             return Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     '$count ${widget.type}${count == 1 ? '' : 's'}',
  //                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Expanded(
  //                     child: ListView.builder(
  //                       itemCount: filteredData.length,
  //                       itemBuilder: (context, index) {
  //                         final data = filteredData[index];
  //                         return GestureDetector(
  //                           onTap: () {
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                 builder: (context) => FormBuild(formId: data.formId),
  //                               ),
  //                             );
  //                           },
  //                           child: NoteCard(
  //                             title: data.title ?? 'Title',
  //                             region: data.client ?? 'Unknown region',
  //                             branchName: data.project ?? 'Unknown branch',
  //                             customer: data.client ?? 'Unknown customer',
  //                             siteId: data.siteId ?? 'N/A',
  //                             dateAssigned: data.dateAssigned?.toString() ?? 'N/A',
  //                             dateReceived: data.dateReceived?.toString() ?? 'N/A',
  //                             color: Colors.blue.shade100,
  //                             icon: Icons.camera_alt_sharp,
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Future<String?> _fetchUserName() async {
    final userId = await _authService.getCurrentUserId();
    if (userId != null) {
      return await _authService.getName(userId);
    }
    return null;
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                AuthClient().logout(context); // Replace with your logout logic
              },
              child: const Text("Logout"),
            ),
          ],
        );
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