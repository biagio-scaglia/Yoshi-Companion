import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web/Desktop
  // Assuming Desktop run for now based on user context
  static const String baseUrl = 'http://127.0.0.1:8000'; 
  
  // Stream the response from the chat endpoint
  static Stream<String> sendMessageStream(String message) async* {
    final url = Uri.parse('$baseUrl/chat');
    final request = http.Request('POST', url);
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({'message': message});

    try {
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final stream = response.stream.transform(utf8.decoder);
        await for (var chunk in stream) {
          yield chunk;
        }
      } else {
        yield "Yoshi is confused... (Error ${response.statusCode})";
      }
    } catch (e) {
      if (kDebugMode) {
        print("API Error: $e");
      }
      yield "Yoshi can't reach his brain! Is the server running? 🦕";
    }
  }
}
