import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  final String websocketUrl;
  Function(String)? onMessageReceived; // Callback for message handling

  WebSocketService(this.websocketUrl);

  // Initialize WebSocket connection
  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(websocketUrl));
    print("Connected to WebSocket: $websocketUrl");

    // Listen for messages
    _channel.stream.listen(
          (message) {
        print("New WebSocket message: $message");
        if (onMessageReceived != null) {
          onMessageReceived!(message);
        }
      },
      onDone: () {
        print("WebSocket connection closed.");
        // reconnect();
      },
      onError: (error) {
        print("WebSocket error: $error");
        // reconnect();
      },
    );
  }

  // Reconnect logic
  // void reconnect() {
  //   print("Reconnecting to WebSocket...");
  //   Future.delayed(Duration(seconds: 5), connect);
  // }

  // Subscribe to a channel
  void subscribe(String channel) {
    final subscriptionMessage = jsonEncode({
      "action": "subscribe",
      "channel": channel,
    });
    _channel.sink.add(subscriptionMessage);
    print("Subscribed to channel: $channel");
  }

  // Disconnect WebSocket
  void disconnect() {
    _channel.sink.close();
  }
}