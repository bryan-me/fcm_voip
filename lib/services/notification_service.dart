import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final String serverUrl;
  final String userId;

  WebSocketService(this.serverUrl, this.userId);

  // Connect to the WebSocket server and subscribe to the user's channel
  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(serverUrl));

    // Listen for messages from the server
    _channel?.stream.listen(
      (message) {
        _handleMessage(message);
      },
      onError: (error) {
        print('WebSocket error: $error');
        // Optionally, attempt reconnection here
      },
      onDone: () {
        print('WebSocket connection closed');
        // Optionally, reconnect here
      },
    );

    // Subscribe to the user's specific channel
    _subscribeToUserChannel(userId);
  }

  // Subscribe to a user-specific channel
  void _subscribeToUserChannel(String userId) {
    if (_channel != null) {
      final subscriptionMessage = jsonEncode({
        'action': 'subscribe',
        'channel': 'tasks.$userId', // Channel format for user-specific updates
      });
      _channel?.sink.add(subscriptionMessage);
    }
  }

  // Handle incoming messages
  void _handleMessage(String message) {
    final decodedMessage = jsonDecode(message);

    // Assuming the server sends messages with a "type" field
    if (decodedMessage['type'] == 'new_task') {
      final taskData = decodedMessage['data'];
      // Trigger a push notification or perform any other action
      _triggerPushNotification(taskData);
    }
  }

  // Trigger a local push notification for a new task
  void _triggerPushNotification(Map<String, dynamic> taskData) {
    // Use flutter_local_notifications or a similar package to show a notification
    print('New task assigned: ${taskData['title']}');
    // Here you can implement actual local notification code
  }

  // Disconnect the WebSocket connection
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}