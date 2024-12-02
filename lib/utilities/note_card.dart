import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/favorite_controller.dart';
import '../data/model/base_data.dart';


class NoteCard extends StatelessWidget {
  final String title;
  final String region;
  final String type;
  final String branchName;
  final String customer;
  final String siteId;
  final String dateAssigned;
  final String dateReceived;
  final Color color;
  final IconData icon;
  final dynamic data;
  final VoidCallback onFavoriteToggle;
  final bool isFavorited;

  const NoteCard({
    Key? key,
    required this.title,
    required this.region,
    required this.type,
    required this.branchName,
    required this.customer,
    required this.siteId,
    required this.dateAssigned,
    required this.dateReceived,
    required this.color,
    required this.icon,
    required this.data,
    required this.onFavoriteToggle,
    required this.isFavorited,
  }) : super(key: key);

  // Method to determine the color based on type
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'task':
        return Colors.purple;
      case 'incident':
        return Colors.red;
      case 'survey':
        return Colors.blue;
      default:
        return Colors.grey; // Fallback color
    }
  }

  Widget _buildTag({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none, // Allow the banner to overlap outside the container
        children: [
          // Background Image with Rounded Corners
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16), // Apply border radius to the image
              child: Image.asset(
                'assets/images/card-bg.jpg', // Replace with your image path
                fit: BoxFit.cover, // Make the image cover the whole container
              ),
            ),
          ),
          // Gradient Overlay with Rounded Corners
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16), // Apply border radius to the overlay
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getTypeColor(type).withOpacity(0.8),
                      _getTypeColor(type).withOpacity(0.1),
                      // Colors.black.withOpacity(0.8),// End color (bottom)
                      // Colors.black.withOpacity(1), // Start color (top)
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content of the card
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Obx(() {
                            final favoriteController = Get.find<FavoriteController>();
                            final isFavorited = favoriteController.isFavorite(data);
                            return Icon(
                              isFavorited ? Icons.star : Icons.star_border,
                              color: isFavorited ? Colors.yellow : Colors.grey,
                            );
                          }),
                          onPressed: () {
                            final favoriteController = Get.find<FavoriteController>();
                            favoriteController.toggleFavorite(data);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTag(label: siteId, color: Colors.blue[500]!),
                        const SizedBox(width: 8),
                        _buildTag(label: customer, color: Colors.blue[500]!),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          branchName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEEE, MMMM d, yyyy').format(DateTime.parse(dateAssigned)),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm a').format(DateTime.parse(dateAssigned)),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16)
                  ],
                ),
              ),
            ],
          ),
          // Add the corner banner
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: _getTypeColor(type), // Use dynamic color based on type
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                type.toLowerCase(), // Customize the text here
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}