import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://run.mocky.io/v3/4f9dbc3f-53c0-4b5d-8631-976a9a3c07f8'; // Example URL

  static Future<Map<String, dynamic>?> fetchImageData() async{
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);

      } else {
        log('Failed to fetch data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Exception occurred: $e');
      return null;
    }
  }
}
