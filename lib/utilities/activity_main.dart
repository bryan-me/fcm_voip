import 'package:fcm_voip/ui/incidents/incidents.dart';
import 'package:fcm_voip/ui/settings/settings.dart';
import 'package:fcm_voip/ui/surveys/surveys.dart';
import 'package:fcm_voip/ui/tasks/tasks.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
     const TasksScreen(),
     const IncidentsScreen(),
     const SurveysScreen(),
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
                    width: 12, 
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                ),
                Image.asset(
                  assetPath,
                  width: 24, 
                  height: 24,
                  color: Colors.white,
                ),
                Positioned(
                  child: Image.asset(
                    assetPath,
                    width: 30, 
                    height: 30,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            )
          : Image.asset(
              assetPath,
              width: 22, 
              height: 22,
              color: Colors.black.withOpacity(0.5),
            ),
      label: label,
    );
  }
}