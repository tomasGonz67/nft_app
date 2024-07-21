import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IBMWatsonService {
  final String _apiKey = dotenv.env['IBM_WATSON_API_KEY'] ?? '';
  final String _serviceUrl = dotenv.env['IBM_WATSON_SERVICE_URL'] ?? '';

  Future<http.Response> synthesizeSpeech(String text) async {
    final response = await http.post(
      Uri.parse('$_serviceUrl/v1/synthesize'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('apikey:$_apiKey')),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'text': text,
        'voice': 'en_us_michaelv3voice', // Adjust as necessary
        'accept': 'audio/mp3',
      }),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      print('Failed to synthesize speech: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to synthesize speech: ${response.statusCode} - ${response.body}');
    }
  }
}
