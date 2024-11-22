// centrifugo_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class CentrifugoConnection {
  final String credentialsUrl;
  final String websocketUrl;
  final String token;
  WebSocketChannel? channel;

  final Function(String notificationMessage)? onNotification;

  CentrifugoConnection({
    required this.credentialsUrl,
    required this.websocketUrl,
    required this.token,
    this.onNotification,
  });

  Future<void> connect() async {
    try {
      final centrifugoToken = await _fetchCentrifugoToken();
      if (centrifugoToken != null) {
        await _connectToWebSocket(centrifugoToken);
      } else {
        print('Failed to retrieve Centrifugo token');
      }
    } catch (e) {
      print('Error connecting to Centrifugo: $e');
    }
  }

  Future<String?> _fetchCentrifugoToken() async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final url = Uri.parse(credentialsUrl);

    print('Fetching Centrifugo credentials from: $url with headers: $headers');

    try {
      final response = await http.get(url, headers: headers);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['token'];
      } else {
        print('Failed to fetch Centrifugo credentials');
      }
    } catch (e) {
      print('Error fetching Centrifugo credentials: $e');
    }
    return null;
  }

  Future<void> _connectToWebSocket(String centrifugoToken) async {
    print('Connecting to Centrifugo WebSocket with token: $centrifugoToken');

    channel = WebSocketChannel.connect(Uri.parse(websocketUrl));

    channel?.stream.listen(
          (message) {
        print('WebSocket message received: $message');
        if (message is String) {
          _handleMessage(message);
        } else if (message is List<int>) {
          final decodedMessage = utf8.decode(message);
          _handleMessage(decodedMessage);
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );

    final authMessage = jsonEncode({
      "params": {"token": centrifugoToken},
      "id": 1
    });
    channel?.sink.add(authMessage);
    print('Sent authentication message: $authMessage');

    final subscribeMessage = jsonEncode({
      "method": 1,
      "params": {"channel": "notifications"},
      "id": 2
    });
    channel?.sink.add(subscribeMessage);
    print('Sent subscription message: $subscribeMessage');
  }

  void _handleMessage(String message) {
    if (onNotification != null) {
      onNotification!(message);
    }
  }

  void disconnect() {
    channel?.sink.close();
    print('WebSocket connection closed manually');
  }
}