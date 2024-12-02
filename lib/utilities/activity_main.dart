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

// import 'package:fcm_voip/ui/incidents/incidents.dart';
// import 'package:fcm_voip/ui/settings/settings.dart';
// import 'package:fcm_voip/ui/surveys/surveys.dart';
// import 'package:fcm_voip/ui/tasks/tasks.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../controllers/count_controller.dart';
// import '../ui/dashboard.dart';
//
// class CustomBottomNavigationBar extends StatefulWidget {
//   const CustomBottomNavigationBar({super.key});
//
//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }
//
// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   int _selectedIndex = 0;
//   final CountController _countController = Get
//       .find(); // Access the existing instance of the controller
//
//
//   final List<Widget> _screens = [
//     // const Dashboard(),
//     IncidentsScreen(),
//     TasksScreen(),
//     SurveysScreen(),
//     // SettingsScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex], // Display selected screen
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//         // Reduced margin to create a better floating effect
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           // Adjust spacing before and after icons
//           decoration: BoxDecoration(
//               color: Colors.black, // Set a semi-transparent background
//               borderRadius: BorderRadius.circular(50),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 20,
//                   offset: Offset(0, 5),
//                 ),
//               ]
//           ),
//           child: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             currentIndex: _selectedIndex,
//             onTap: _onItemTapped,
//             selectedFontSize: 10,
//             unselectedFontSize: 10,
//             selectedItemColor: Colors.black,
//             unselectedItemColor: Colors.grey,
//             showSelectedLabels: false,
//             showUnselectedLabels: false,
//             backgroundColor: Colors.transparent,
//             // Ensure the background is transparent
//             items: [
//               _buildNavItem(Icons.warning_amber_outlined, 0,
//                   count: _countController.incidentCount.value),
//               _buildNavItem(Icons.construction_outlined, 1,
//                   count: _countController.taskCount.value),
//               _buildNavItem(Icons.explore_outlined, 2,
//                   count: _countController.surveyCount.value),
//               // _buildNavItem(Icons.settings_outlined, 3),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   BottomNavigationBarItem _buildNavItem(IconData icon, int index,
//       {int count = 2}) {
//     return BottomNavigationBarItem(
//       icon: Stack(
//         clipBehavior: Clip.none, // Allows the badge to overflow
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 50),
//             // Animation duration
//             curve: Curves.easeIn,
//             // Bounce effect
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//               color: _selectedIndex == index ? Colors.white : Colors
//                   .transparent,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: _selectedIndex == index ? Colors.black : Colors.grey,
//               size: 30,
//             ),
//           ),
//           if (count > 0) // Only show the badge if count > 0
//             Positioned(
//               top: -5,
//               right: -3,
//               child: Container(
//                 padding: const EdgeInsets.all(5), // Padding inside the badge
//                 decoration: const BoxDecoration(
//                   color: Colors.green, // Badge background color
//                   shape: BoxShape.circle,
//                 ),
//                 child: Text(
//                   '$count',
//                   style: const TextStyle(
//                     color: Colors.white, // Badge text color
//                     fontSize: 16, // Badge text size
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       label: '',
//     );
//   }
//
// }
  // BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
  //   return BottomNavigationBarItem(
  //     icon: AnimatedContainer(
  //       duration: Duration(milliseconds: 50), // Animation duration
  //       curve: Curves.easeIn, // Bounce effect
  //       width: 70,
  //       height: 70,
  //       decoration: BoxDecoration(
  //         color: _selectedIndex == index ? Colors.white : Colors.transparent,
  //         shape: BoxShape.circle,
  //       ),
  //       child: Icon(
  //         icon,
  //         color: _selectedIndex == index ? Colors.black : Colors.grey,
  //         size: 30,
  //       ),
  //     ),
  //     label: '',
  //   );
  // }

///New
import 'package:fcm_voip/controllers/base_data_controller.dart';
import 'package:fcm_voip/ui/incidents/incidents.dart';
import 'package:fcm_voip/ui/settings/settings.dart';
import 'package:fcm_voip/ui/surveys/surveys.dart';
import 'package:fcm_voip/ui/tasks/tasks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/count_controller.dart';
import '../ui/calendar.dart';
import '../ui/dashboard.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  final BaseDataController _baseDataController = Get.find(); // Access the existing instance of the controller


  final List<Widget> _screens = [
    // const Dashboard(),
    IncidentsScreen(),
    TasksScreen(),
    SurveysScreen(),
    CalendarScreen(),
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
              _buildNavItem(Icons.warning_amber_outlined, 0),
              _buildNavItem(Icons.construction_outlined, 1),
              _buildNavItem(Icons.explore_outlined, 2),
              _buildNavItem(Icons.calendar_month, 3),
            ],
          ),
        ),
      ),
    );
  }

  ///New
  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    // Define type keys matching their respective indices
    final typeKeys = ["incident", "task", "survey", "notification"]; // Add more as needed

    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none, // Allows the badge to overflow
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 50), // Animation duration
            curve: Curves.easeIn, // Bounce effect
            width: 50,
            height: 50,
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
          Obx(() {
            // Fetch count from typeCounts map using the appropriate type key
            final count = _baseDataController.typeCounts[typeKeys[index]] ?? 0;

            // Only show the badge if count > 0
            return Positioned(
              top: -5,
              right: -3,
              child: count > 0
                  ? Container(
                padding: const EdgeInsets.all(5), // Padding inside the badge
                decoration: const BoxDecoration(
                  color: Colors.green, // Badge background color
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white, // Badge text color
                    fontSize: 16, // Badge text size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            );
          }),
        ],
      ),
      label: '',
    );


  ///Old
  // BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
  //   return BottomNavigationBarItem(
  //     icon: Stack(
  //       clipBehavior: Clip.none, // Allows the badge to overflow
  //       children: [
  //         AnimatedContainer(
  //           duration: const Duration(milliseconds: 50), // Animation duration
  //           curve: Curves.easeIn, // Bounce effect
  //           width: 70,
  //           height: 70,
  //           decoration: BoxDecoration(
  //             color: _selectedIndex == index ? Colors.white : Colors.transparent,
  //             shape: BoxShape.circle,
  //           ),
  //           child: Icon(
  //             icon,
  //             color: _selectedIndex == index ? Colors.black : Colors.grey,
  //             size: 30,
  //           ),
  //         ),
  //         Obx(() {
  //           // Listen to changes in the count values from CountController
  //           int count = 0;
  //           switch (index) {
  //             case 0:
  //               count = _countController.incidentCount.value;
  //               break;
  //             case 1:
  //               count = _countController.taskCount.value;
  //               break;
  //             case 2:
  //               count = _countController.surveyCount.value;
  //               break;
  //
  //             case 3:
  //               count = _countController.surveyCount.value;
  //               break;
  //           }
  //           // Only show the badge if count > 0
  //           return Positioned(
  //             top: -5,
  //             right: -3,
  //             child: count > 0
  //                 ? Container(
  //               padding: const EdgeInsets.all(5), // Padding inside the badge
  //               decoration: const BoxDecoration(
  //                 color: Colors.green, // Badge background color
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Text(
  //                 '$count',
  //                 style: const TextStyle(
  //                   color: Colors.white, // Badge text color
  //                   fontSize: 16, // Badge text size
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             )
  //                 : const SizedBox.shrink(),
  //           );
  //         }),
  //       ],
  //     ),
  //     label: '',
  //   );
  }
}
