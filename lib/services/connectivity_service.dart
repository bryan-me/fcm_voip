import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity connectivity = Connectivity();

  ConnectivityService() {
    // Start monitoring connectivity changes
    connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      for (var result in results) {
        if (result != ConnectivityResult.none) {
          print('Internet connected');
          // Trigger actions such as fetching tasks or submitting pending forms
          // Add your code here to handle reconnection
        } else {
          print('Internet disconnected');
        }
      }
    });
  }

  // Check current connectivity status
  Future<bool> isConnected() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
