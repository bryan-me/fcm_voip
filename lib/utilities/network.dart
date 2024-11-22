// // ignore_for_file: unrelated_type_equality_checks
//
// import 'dart:io';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// class Network {
//   //  Future<bool> isConnectedToNetwork() async {
//   //   var connectivityResult = await Connectivity().checkConnectivity();
//
//   //   if (connectivityResult == ConnectivityResult.mobile ||
//   //       connectivityResult == ConnectivityResult.wifi) {
//   //     return true;
//   //   } else {
//   //     return false;
//   //   }
//   // }
//   Future<bool> isConnectedToNetwork() async {
//   // Get the current connectivity status
//   List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
//
//   // Check if the device is connected to Wi-Fi or Mobile network
//   if (connectivityResult != ConnectivityResult.none) {
//     try {
//       // Optionally, perform an additional internet check by pinging a server
//       final result = await InternetAddress.lookup('google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   // Return false if there is no network connection
//   return false;
// }
// }


import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

// class ConnectivityUtil {
//   static Future<bool> isConnected() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//
//     // If we are connected to Wi-Fi or mobile, perform a network check
//     if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
//       try {
//         // Check if we can reach a reliable, lightweight server
//         final response = await http.get(Uri.parse('https://www.google.com')).timeout(Duration(seconds: 5));
//         if (response.statusCode == 200) {
//           print("Internet connection confirmed.");
//           return true;
//         }
//       } catch (e) {
//         print("No internet access available.");
//       }
//     }
//
//     print("No internet connection detected.");
//     return false;
//   }
// }


// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
//
// class ConnectivityUtil {
//   static Future<bool> isConnected() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//
//     // Log connectivity status for debugging
//     print('Connectivity result: $connectivityResult');
//
//     if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
//       try {
//         // Attempt to make a lightweight request to check internet availability
//         final response = await http.get(Uri.parse('https://www.bing.com')).timeout(Duration(seconds: 20));
//         if (response.statusCode == 200) {
//           print("Internet connection confirmed.");
//           return true;
//         } else {
//           print("Internet access detected, but response not valid.");
//         }
//       } catch (_) {
//         print("No internet access detected.");
//       }
//     }
//     print("No internet connection detected.");
//     return false;
//   }
// }

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityUtil {
  static Future<bool> isConnected() async {
      // print("Connected to ${connectivityResult == ConnectivityResult.wifi ? 'Wi-Fi' : 'Mobile Data'}");

      try {
        // Attempt to make a lightweight request to check internet availability
        final response = await http.get(Uri.parse('https://www.google.com')).timeout(Duration(seconds: 5));

        print("HTTP response status: ${response.statusCode}");

        if (response.statusCode == 200) {
          print("Internet connection confirmed via HTTP request.");
          return true;
        } else {
          print("Received invalid response (status code: ${response.statusCode})");
        }
      } catch (e) {
        print("Error in HTTP request: $e"); // Log the error details
      }

    print("No internet connection detected.");
    return false;
  }
}