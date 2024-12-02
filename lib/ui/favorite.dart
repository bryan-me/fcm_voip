import 'package:fcm_voip/data/model/base_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/favorite_controller.dart';
import '../utilities/form.dart';
import '../utilities/note_card.dart';

class FavoriteScreen extends StatelessWidget {
  final FavoriteController _favoriteController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Favorites',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
          ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Display message if no favorites are present
        if (_favoriteController.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
              children: [
                Image.asset('assets/images/no_fav.png', width: 150, height: 150), // Use Image.asset
                const SizedBox(height: 16), // Add some spacing between the image and text
                const Text(
                  'No favorites yet.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        // Display the list of favorite items
        return Padding(padding: EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: _favoriteController.favorites.length,
          itemBuilder: (context, index) {
            final task = _favoriteController.favorites[index];

            return GestureDetector(
                onTap:() {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => FormBuild(formId: task.formId),
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
              data: task,
              title: task.title ?? 'Unknown Title',
              region: task.client ?? 'Unknown Region',
                type: task.type ?? 'Uknown type',
              branchName: task.project ?? 'Unknown Branch',
              customer: task.client ?? 'Unknown Customer',
              siteId: task.siteId ?? 'N/A',
              dateAssigned: task.dateAssigned?.toString() ?? 'N/A',
              dateReceived: task.dateReceived?.toString() ?? 'N/A',
              color: Colors.black,
              icon: Icons.favorite, // Customize icon for favorite screen
              isFavorited: true, // Mark as favorited by default in this screen
              onFavoriteToggle: () {
                _favoriteController.toggleFavorite(task);
              },
            )
            );
          },
        )
        );
      }),
    );
  }
}