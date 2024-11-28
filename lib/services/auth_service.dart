// lib/services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/api_helper.dart';

class AuthService {
  // Fungsi login
  Future<void> login(String nik, String password) async {
    if (nik.isEmpty || password.isEmpty) {
      throw Exception('Nik dan Password harus diisi');
    }

    try {
      final response = await http.post(
        Uri.parse(ApiHelper.getUrl("login")), // Menggunakan helper untuk URL
        body: {
          'nik': nik,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['data']['token']);
        return data['data']['token'];  // Mengembalikan token
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Terjadi kesalahan, coba lagi.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
