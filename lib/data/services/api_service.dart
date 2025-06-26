import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http; // HTTP client for network requests

import '../../app/app_constants.dart'; // Constants for API endpoints

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();
  final String _baseUrl = AppConstants.baseUrl; // Base URL for the API

  // Fetches data from a specified endpoint
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint'); // Construct the full URL
    try {
      final response = await client.get(url); // Perform GET request

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response body
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // If the server returns an error, throw an exception
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any network or parsing errors
      throw Exception('Failed to connect to the server: $e');
    }
  }

  // Posts data to a specified endpoint
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint'); // Construct the full URL
    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'}, // Set content type to JSON
        body: json.encode(data), // Encode the data to JSON string
      );

      // Check if the request was successful (status code 200 or 201 for creation)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Decode the JSON response body
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // If the server returns an error, throw an exception
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any network or parsing errors
      throw Exception('Failed to connect to the server: $e');
    }
  }
}