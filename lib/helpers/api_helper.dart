class ApiHelper {
  static const String baseUrl = "http://localhost:8000/api";  // Base URL API

  // Fungsi untuk membangun URL dengan path spesifik
  static String getUrl(String path) {
    return "$baseUrl/$path";
  }
}
