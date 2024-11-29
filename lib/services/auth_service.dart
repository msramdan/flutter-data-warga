// lib/services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/api_helper.dart';

class AuthService {
  // Fungsi login
  Future<String> login(String nik, String password) async {
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

        // Store individual fields
        prefs.setString('token', data['data']['token']);
        prefs.setString('userName', data['data']['warga']['nama']);

        // Store the entire 'warga' object as a JSON string
        prefs.setString('detailWarga', json.encode(data['data']['warga']));

        return data['data']['token']; // Mengembalikan token
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Terjadi kesalahan, coba lagi.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ?? 'Unknown User';
  }

  // Fungsi logout
  Future<bool> logout() async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return false; // Jika token tidak ditemukan, logout gagal
      }

      // Kirim permintaan logout ke API
      final response = await http.post(
        Uri.parse(ApiHelper.getUrl("logout")), // URL logout dari API
        headers: {
          'Authorization': 'Bearer $token', // Menambahkan token di header
        },
      );

      if (response.statusCode == 200) {
        // Jika logout berhasil, hapus token dari SharedPreferences
        await prefs.remove('token');
        return true; // Berhasil logout
      } else {
        return false; // Jika logout gagal
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat logout: $e');
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
