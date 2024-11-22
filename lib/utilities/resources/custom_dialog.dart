import 'package:flutter/cupertino.dart';

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const int zigzagCount = 20; // Number of zigzags
    final double zigzagWidth = size.width / zigzagCount;
    final double zigzagHeight = 10; // Height of each zigzag
    const double cutoutRadius = 35; // Radius of the side cutouts
    const double cutoutOffset = 210; // Distance from the top to the start of the cutout
    final Path path = Path();

    // Start at the top-left corner
    path.moveTo(0, zigzagHeight);

    // Create the top zigzag
    for (int i = 0; i < zigzagCount; i++) {
      final double x1 = zigzagWidth * i;
      final double x2 = zigzagWidth * (i + 0.5);
      final double x3 = zigzagWidth * (i + 1);

      path.lineTo(x2, 0);
      path.lineTo(x3, zigzagHeight);
    }

        // Continue down the right side until just above the cutout
    path.lineTo(size.width, cutoutOffset);

        // Right-side cutout (concave circular indentation)
    path.arcToPoint(
      Offset(size.width - cutoutRadius, cutoutOffset + cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    path.arcToPoint(
      Offset(size.width, cutoutOffset + cutoutRadius * 2),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    // Continue down the right side after the cutout
    path.lineTo(size.width, size.height - cutoutOffset - cutoutRadius * 2);

    // Continue along the right edge
    path.lineTo(size.width, size.height - zigzagHeight);

    // Create the bottom zigzag
    for (int i = zigzagCount - 1; i >= 0; i--) {
      final double x1 = zigzagWidth * i;
      final double x2 = zigzagWidth * (i + 0.5);
      final double x3 = zigzagWidth * (i + 1);

      path.lineTo(x2, size.height);
      path.lineTo(x1, size.height - zigzagHeight);
    }

        // Continue up the left side after the cutout
    path.lineTo(0, cutoutOffset + cutoutRadius * 2);

    // Left-side cutout near the top
    path.arcToPoint(
      Offset(cutoutRadius, cutoutOffset + cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    path.arcToPoint(
      Offset(0, cutoutOffset),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );


    // Close the path along the left edge
    path.lineTo(0, zigzagHeight);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// import 'package:flutter/cupertino.dart';
//
// class ZigZagClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     const int zigzagCount = 20; // Number of zigzags
//     final double zigzagWidth = size.width / zigzagCount;
//     const double zigzagHeight = 10; // Height of each zigzag
//     const double cutoutRadius = 30; // Radius of the side cutouts
//     const double cutoutOffset = 120; // Distance from the top to the start of the cutout
//     final Path path = Path();
//
//     // Start at the top-left corner
//     path.moveTo(0, zigzagHeight);
//
//     // Create the top zigzag pattern
//     for (int i = 0; i < zigzagCount; i++) {
//       final double x1 = zigzagWidth * i;
//       final double x2 = zigzagWidth * (i + 0.5);
//       final double x3 = zigzagWidth * (i + 1);
//
//       path.lineTo(x2, 0);
//       path.lineTo(x3, zigzagHeight);
//     }
//
//     // Continue down the right side until just above the cutout
//     path.lineTo(size.width, cutoutOffset);
//
//     // Right-side cutout (concave circular indentation)
//     path.arcToPoint(
//       Offset(size.width - cutoutRadius, cutoutOffset + cutoutRadius),
//       radius: Radius.circular(cutoutRadius),
//       clockwise: false,
//     );
//     path.arcToPoint(
//       Offset(size.width, cutoutOffset + cutoutRadius * 2),
//       radius: Radius.circular(cutoutRadius),
//       clockwise: false,
//     );
//
//     // Continue down the right side after the cutout
//     path.lineTo(size.width, size.height - cutoutOffset - cutoutRadius * 2);
//
//     // Right-side cutout near the bottom
//     // path.arcToPoint(
//     //   Offset(size.width - cutoutRadius, size.height - cutoutOffset - cutoutRadius),
//     //   radius: Radius.circular(cutoutRadius),
//     //   clockwise: false,
//     // );
//     // path.arcToPoint(
//     //   Offset(size.width, size.height - cutoutOffset),
//     //   radius: Radius.circular(cutoutRadius),
//     //   clockwise: false,
//     // );
//
//     // Continue to the bottom edge with zigzag
//     for (int i = zigzagCount - 1; i >= 0; i--) {
//       final double x1 = zigzagWidth * i;
//       final double x2 = zigzagWidth * (i + 0.5);
//       final double x3 = zigzagWidth * (i + 1);
//
//       path.lineTo(x2, size.height - zigzagHeight);
//       path.lineTo(x1, size.height);
//     }
//
//     // Continue up the left side until just above the cutout
//     path.lineTo(0, size.height - cutoutOffset);
//
//     // Left-side cutout near the bottom
//     // path.arcToPoint(
//     //   Offset(cutoutRadius, size.height - cutoutOffset - cutoutRadius),
//     //   radius: Radius.circular(cutoutRadius),
//     //   clockwise: false,
//     // );
//     // path.arcToPoint(
//     //   Offset(0, size.height - cutoutOffset - cutoutRadius * 2),
//     //   radius: Radius.circular(cutoutRadius),
//     //   clockwise: false,
//     // );
//
//     // Continue up the left side after the cutout
//     path.lineTo(0, cutoutOffset + cutoutRadius * 2);
//
//     // Left-side cutout near the top
//     path.arcToPoint(
//       Offset(cutoutRadius, cutoutOffset + cutoutRadius),
//       radius: Radius.circular(cutoutRadius),
//       clockwise: false,
//     );
//     path.arcToPoint(
//       Offset(0, cutoutOffset),
//       radius: Radius.circular(cutoutRadius),
//       clockwise: false,
//     );
//
//     // Close the path
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }