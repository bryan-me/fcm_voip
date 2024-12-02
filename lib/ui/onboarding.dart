import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _locationEnabled = false;
  bool _locationPermissionGranted = false;
  bool _notificationsPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  // Check initial permissions
  Future<void> _checkPermissions() async {
    await _checkLocationPermission();
    await _checkNotificationPermission();
    setState(() {});
  }

  // Request and re-check location permission
  Future<void> _checkLocationPermission() async {
    PermissionStatus locationPermission = await Permission.location.status;

    if (locationPermission.isGranted) {
      _locationPermissionGranted = true;
      _locationEnabled = await Geolocator.isLocationServiceEnabled();
    } else {
      _locationPermissionGranted = false;
      _locationEnabled = false;
    }
  }

  // Request location permission
  Future<void> _requestLocationPermission() async {
    PermissionStatus locationPermission = await Permission.location.request();

    if (locationPermission.isGranted) {
      _locationPermissionGranted = true;
      _locationEnabled = await Geolocator.isLocationServiceEnabled();

      if (!_locationEnabled) {
        _showEnableLocationDialog();
      }
    } else {
      _locationPermissionGranted = false;
      _locationEnabled = false;
    }
    setState(() {});
  }

  // Check and request notification permission
  Future<void> _checkNotificationPermission() async {
    PermissionStatus notificationPermission = await Permission.notification.status;
    _notificationsPermissionGranted = notificationPermission.isGranted;
  }

  Future<void> _requestNotificationPermission() async {
    PermissionStatus notificationPermission = await Permission.notification.request();
    _notificationsPermissionGranted = notificationPermission.isGranted;
    setState(() {});
  }

  // Show dialog to enable location services
  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Enable Location Services'),
        content: Text('Location services need to be enabled to proceed.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text('Go to Settings'),
          ),
        ],
      ),
    );
  }

  // Navigate to the login page
  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to VoIP!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text('Enable location and notifications to continue'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _requestLocationPermission,
              child: Text(
                _locationPermissionGranted
                    ? (_locationEnabled ? 'Location Enabled' : 'Enable Location Services')
                    : 'Enable Location',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestNotificationPermission,
              child: Text(
                _notificationsPermissionGranted
                    ? 'Notifications Enabled'
                    : 'Enable Notifications',
              ),
            ),
            SizedBox(height: 40),
            if (_locationEnabled && _notificationsPermissionGranted)
              ElevatedButton(
                onPressed: _navigateToLogin,
                child: Text('Proceed to Login'),
              ),
          ],
        ),
      ),
    );
  }
}