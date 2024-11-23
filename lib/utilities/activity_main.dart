// import 'package:fcm_voip/ui/incidents/incidents.dart';
// import 'package:fcm_voip/ui/settings/settings.dart';
// import 'package:fcm_voip/ui/surveys/surveys.dart';
// import 'package:fcm_voip/ui/tasks/tasks.dart';
// import 'package:flutter/material.dart';
//
// class CustomBottomNavigationBar extends StatefulWidget {
//   const CustomBottomNavigationBar({super.key});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }
//
// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//      const TasksScreen(),
//      const IncidentsScreen(),
//      const SurveysScreen(),
//      SettingsScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: _screens[_selectedIndex], // Display selected screen
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(50), // Floating margin
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 25), // Adjust spacing before and after icons
//           decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(50),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 20,
//                   offset: Offset(0, 5),
//                 ),
//           ]
//         ),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           selectedFontSize: 10,
//           unselectedFontSize: 10,
//           selectedItemColor: Colors.black,
//           unselectedItemColor: Colors.grey,
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           backgroundColor: Colors.transparent, // Set background color to white
//           items: [
//             _buildNavItem(Icons.home_outlined, 0),
//             _buildNavItem(Icons.calendar_today_outlined, 1),
//             _buildNavItem(Icons.person_outline, 2),
//             _buildNavItem(Icons.settings_outlined, 3),
//           ],
//         ),
//       ),
//     )
//   );
// }
//
//
//   BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
//     return BottomNavigationBarItem(
//       icon: AnimatedContainer(
//         duration: Duration(milliseconds: 300), // Animation duration
//         curve: Curves.easeIn, // Bounce effect
//         width: 70,
//         height: 70,
//         decoration: BoxDecoration(
//           color: _selectedIndex == index ? Colors.white : Colors.transparent,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           icon,
//           color: _selectedIndex == index ? Colors.black : Colors.grey,
//           size: 30,
//         ),
//       ),
//       label: '',
//     );
//   }
// }

import 'package:fcm_voip/ui/incidents/incidents.dart';
import 'package:fcm_voip/ui/settings/settings.dart';
import 'package:fcm_voip/ui/surveys/surveys.dart';
import 'package:fcm_voip/ui/tasks/tasks.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Reduced margin to create a better floating effect
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25), // Adjust spacing before and after icons
          decoration: BoxDecoration(
              color: Colors.black, // Set a semi-transparent background
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 5),
                ),
              ]
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.transparent, // Ensure the background is transparent
            items: [
              _buildNavItem(Icons.construction_outlined, 0),
              _buildNavItem(Icons.warning_amber_outlined, 1),
              _buildNavItem(Icons.explore_outlined, 2),
              _buildNavItem(Icons.settings_outlined, 3),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: Duration(milliseconds: 50), // Animation duration
        curve: Curves.easeIn, // Bounce effect
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: _selectedIndex == index ? Colors.black : Colors.grey,
          size: 30,
        ),
      ),
      label: '',
    );
  }
}