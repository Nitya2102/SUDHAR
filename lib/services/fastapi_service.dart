import 'package:http/http.dart' as http;
import 'dart:convert';

class FastAPIService {
  final String baseUrl;

  FastAPIService({required this.baseUrl});

  // Function to process the query
  Future<dynamic> processQuery(String query) async {
    final response = await http.post(
      Uri.parse('$baseUrl/process-query'),  // Ensure it matches the FastAPI endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_query': query}),  // Send the query in a JSON format
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);  // Decode the response
    } else {
      throw Exception('Failed to process query');
    }
  }
}