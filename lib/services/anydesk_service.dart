import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AnyDeskService {
  static const platform = MethodChannel('com.stlghana.fcm_voip/anydesk');

  Future<void> openAnyDesk() async {
    try {
      await platform.invokeMethod('openAnyDesk');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to open AnyDesk: ${e.message}');
      }
    }
  }

}

