import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Import halaman login
import 'screens/home_screen.dart'; // Import halaman home
import 'services/auth_service.dart'; // Import AuthService

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App RT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: checkToken(),
        builder: (context, snapshot) {
          // Jika data belum selesai diambil, tampilkan loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            // Jika ada error, anggap token tidak valid dan tampilkan login
            return LoginScreen();
          } else {
            // Jika token valid, arahkan ke HomeScreen
            return snapshot.data == true ? HomeScreen() : LoginScreen();
          }
        },
      ),
    );
  }

  Future<bool> checkToken() async {
    final authService = AuthService();
    try {
      final token = await authService.getToken();
      if (token != null && token.isNotEmpty) {
        // Kamu bisa memverifikasi token di sini dengan cara tertentu
        // Misalnya, memanggil API untuk memverifikasi apakah token masih valid
        return true; // Jika token valid, kembalikan true
      } else {
        return false; // Jika token tidak ada atau invalid
      }
    } catch (e) {
      return false; // Jika terjadi error saat memverifikasi token
    }
  }
}
