import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/base_data_controller.dart';
import '../controllers/favorite_controller.dart';
import '../services/auth_service.dart';
import '../services/websocket_service.dart';
import '../utilities/auth_client.dart';
import '../utilities/form.dart';
import '../utilities/note_card.dart';
import 'favorite.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  final AuthService _authService = AuthService();
  final BaseDataController _baseDataController =
  Get.put(BaseDataController(
    baseUrl: '',
    authService: AuthService(),
    webSocketService: WebSocketService(''),
  ));  final FavoriteController _favoriteController = Get.put(FavoriteController());
  final bool isUserFromActiveDirectory = true;



  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = _getCurrentWeekDates();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar'.toUpperCase(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: PopupMenuButton<String>(
          icon: FutureBuilder<String?>(
            future: _fetchUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              final name = snapshot.data ?? 'User';
              final initials = _getInitials(name);
              return CircleAvatar(
                backgroundColor: Colors.blue[300],
                radius: 50,
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: initials.length > 2 ? 16 : 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          onSelected: (value) {
            switch (value) {
              case 'Profile':
              case 'Settings':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()), // Replace with appropriate screen
                );
                break;
              case 'Logout':
                showLogoutConfirmationDialog(context);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'Profile', child: Text('Profile & Legal')),
            const PopupMenuItem(value: 'Settings', child: Text('Settings')),
            if (!isUserFromActiveDirectory)
              const PopupMenuItem(value: 'Change Password', child: Text('Change Password')),
            const PopupMenuItem(value: 'Logout', child: Text('Logout')),
          ],
        ),
        actions: [
          Obx(() {
            final favoriteCount = _favoriteController.favorites.length;
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
                  },
                ),
                if (favoriteCount > 0)
                  Positioned(
                    right: 8,
                    top: 3,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      child: Text(
                        '$favoriteCount',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today'.toUpperCase(),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.normal,
            ),),
            Text(
              '${DateFormat('EEEE, d MMM').format(_currentDate)}',
              // style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold, // Make the font bold
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weekDates.map((date) {
                bool isSelected = date.day == _selectedDate.day &&
                    date.month == _selectedDate.month &&
                    date.year == _selectedDate.year;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                    _baseDataController.filterDataByDate(_selectedDate);
                  },
                  child: _buildDayButton(date, isSelected),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (_baseDataController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (_baseDataController.filteredData.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/no_data.png', width: 150, height: 150),
                        const SizedBox(height: 16),
                        Text(
                          'No job assigned on ${DateFormat('d MMM yyyy').format(_selectedDate)}.',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: _baseDataController.filteredData.length,
                    itemBuilder: (context, index) {
                      final data = _baseDataController.filteredData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  FormBuild(formId: data.formId!),
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
                          type: data.type ?? 'Unknown type',
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
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _getCurrentWeekDates() {
    DateTime startOfWeek = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  Widget _buildDayButton(DateTime date, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.pink.shade100 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('EEE').format(date),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.pink : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.pink : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

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
                AuthClient().logout(context);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  String _getInitials(String fullName) {
    List<String> nameParts = fullName.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
  }
}