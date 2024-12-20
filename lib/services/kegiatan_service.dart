import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/api_helper.dart'; // Pastikan helper ini ada untuk URL

class KegiatanService {
  // Fungsi untuk mengambil daftar kegiatan dengan filter tanggal
  Future<List<dynamic>> fetchKegiatan({String? startDate, String? endDate}) async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('Token tidak ditemukan. Anda harus login terlebih dahulu.');
      }

      // Buat query parameter untuk startDate dan endDate
      final queryParams = {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      };

      // Tambahkan query parameter ke URL
      final uri = Uri.parse(ApiHelper.getUrl("kegiatan")).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token', // Mengirimkan token di header
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];  // Menyaring dan mengembalikan data kegiatan
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Terjadi kesalahan saat mengambil data kegiatan.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
