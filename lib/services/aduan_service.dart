import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/api_helper.dart'; // Make sure this helper exists for API URL

class AduanService {
  // Function to fetch the list of aduan with date filters
  Future<List<dynamic>> fetchAduan({String? startDate, String? endDate}) async {
    try {
      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
      }

      // Create query parameters for startDate and endDate
      final queryParams = {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      };

      // Add query parameters to the URL
      final uri = Uri.parse(ApiHelper.getUrl("aduan")).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token', // Sending token in the header
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];  // Extract and return the aduan data
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Terjadi kesalahan saat mengambil data aduan.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Function to submit a new aduan
  Future<void> submitAduan(Map<String, dynamic> aduanData) async {
    try {
      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
      }

      final uri = Uri.parse(ApiHelper.getUrl("aduan"));

      // Send POST request to submit the new aduan
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',  // Sending token in the header
          'Content-Type': 'application/json', // Content-Type for JSON data
        },
        body: json.encode(aduanData),  // Convert aduanData to JSON
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return;
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Terjadi kesalahan saat mengirimkan aduan.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
