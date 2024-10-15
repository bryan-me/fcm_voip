// import 'package:fcm_voip/ui/settings/settings.dart';
// import 'package:flutter/material.dart';
// // import 'package:oauth2_test/chatterscreen.dart';
// // import 'package:oauth2_test/screens/form_list.dart';
// // import 'package:oauth2_test/screens/settings.dart';
// // import 'package:oauth2_test/tokenmanager.dart';

// class ActivityMain extends StatefulWidget {
//   const ActivityMain({super.key});

//   @override
//   _ActivityMainState createState() => _ActivityMainState();
// }

// class _ActivityMainState extends State<ActivityMain> {
//   int _selectedIndex = 0;

//   // Ensure the required values are accessible from TokenManager or passed accordingly
//   final List<Widget> _widgetOptions = <Widget>[
//     // ChatterScreen(
//     //   token: TokenManager.accessToken ?? '',
//     //   username: username ?? '',
//     //   email: email ?? '',
//     //   sub: TokenManager.sub ?? '',
//     // ), // Chat screen
//     // FormListScreen(),// MyHomePage(title: 'Home'), // Home screen
//     //  FormListScreen(),
//     //  FormListScreen(),  // Form screen (Uncomment when the form screen is ready)
//       SettingsScreen()
//     // //   ChatterScreen(
//     // //   token: TokenManager.accessToken ?? '',
//     // //   username: username ?? '',
//     // //   email: email ?? '',
//     // //   sub: TokenManager.sub ?? '',
//     // // ),
    
//   ];
  
//   static get email => null;
  
//   static get username => null;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _widgetOptions.isNotEmpty
//           ? _widgetOptions[_selectedIndex]
//           : const Center(child: Text('No screen available')),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'Chat',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.task),
//             label: 'Task',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.alarm),
//             label: 'Incidents',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.poll),
//             label: 'Surveys',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//       selectedItemColor: Colors.blue.shade800,
//       unselectedItemColor: Colors.grey,
//       onTap: _onItemTapped,
//       selectedLabelStyle: const TextStyle(fontSize: 12), // Adjust label font size
//       unselectedLabelStyle: const TextStyle(fontSize: 10), // Smaller font size for unselected items
//       ),
//     );
//   }
// }


import 'package:fcm_voip/ui/incidents/incidents.dart';
import 'package:fcm_voip/ui/settings/settings.dart';
import 'package:fcm_voip/ui/surveys/surveys.dart';
import 'package:fcm_voip/ui/tasks/tasks.dart';
import 'package:flutter/material.dart';
// import 'package:parcel_tracking_poc/screens/home.dart';
// import 'package:parcel_tracking_poc/screens/notifications.dart';
// import 'package:parcel_tracking_poc/screens/order.dart';
// import 'package:parcel_tracking_poc/screens/profile.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
     TasksScreen(),
     IncidentsScreen(),
     SurveysScreen(),
     SettingsScreen(),
    // OrdersScreen(),
    // NotificationsScreen(),
    // AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white, // Set background color to white
        items: [
          _buildNavItem('assets/icons/home.png', "Tasks", 0),
          _buildNavItem('assets/icons/orders.png', "Incidents", 1),
          _buildNavItem('assets/icons/notifications.png', "Surveys", 2),
          _buildNavItem('assets/icons/account.png', "Settings", 3),
        ],
      ),
    );
  }

    BottomNavigationBarItem _buildNavItem(String assetPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: _selectedIndex == index
          ? Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 5,
                  top: 3,
                  child: Container(
                    width: 12, // Reduced size for the background circle
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                ),
                Image.asset(
                  assetPath,
                  width: 24, // Reduced icon size for the selected item
                  height: 24,
                  color: Colors.white,
                ),
                Positioned(
                  child: Image.asset(
                    assetPath,
                    width: 30, // Reduced stroke size for the selected item
                    height: 30,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            )
          : Image.asset(
              assetPath,
              width: 22, // Reduced size for the unselected item
              height: 22,
              color: Colors.black.withOpacity(0.5),
            ),
      label: label,
    );
  }
}