// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class Network {
  //  Future<bool> isConnectedToNetwork() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();

  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  Future<bool> isConnectedToNetwork() async {
  // Get the current connectivity status
  List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

  // Check if the device is connected to Wi-Fi or Mobile network
  if (connectivityResult != ConnectivityResult.none) {
    try {
      // Optionally, perform an additional internet check by pinging a server
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // Return false if there is no network connection
  return false;
}
}