// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Import AuthService
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // Untuk menyembunyikan password secara default
  bool _showPassword = false; // Menyimpan status checkbox "Show Password"

  // Menambahkan instance dari AuthService
  final AuthService _authService = AuthService();

  Future<void> login() async {
    final nik = nikController.text;
    final password = passwordController.text;

    if (nik.isEmpty || password.isEmpty) {
      // Jika ada field yang kosong
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Nik dan Password harus diisi"),
      ));
      return;
    }

    try {
      final token = await _authService.login(nik, password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login berhasil!"),
      ));
      // Arahkan ke halaman Home setelah login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login gagal: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            elevation: 5.0, // Memberikan efek bayangan
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Membuat sudut card melengkung
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Menambahkan logo
                  Image.asset(
                    'assets/images/login.png', // Menampilkan gambar logo
                    width: 250, // Ukuran logo lebih besar
                    height: 250, // Ukuran logo lebih besar
                  ),
                  SizedBox(height: 20),
                  // Input untuk Nik
                  TextField(
                    controller: nikController,
                    decoration: InputDecoration(
                      labelText: "Nik",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Input untuk Password
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Row untuk checkbox "Show Password"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Untuk meratakan ke kiri
                    children: [
                      Checkbox(
                        value: _showPassword,
                        onChanged: (bool? value) {
                          setState(() {
                            _showPassword = value!;
                            _obscurePassword = !_showPassword;
                          });
                        },
                      ),
                      Text("Show Password"),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Tombol login
                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Tombol penuh lebar
                      backgroundColor: Colors.blue, // Set warna latar belakang biru
                      foregroundColor: Colors.white, // Set warna teks menjadi putih
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Sudut tombol melengkung
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Membuat teks menjadi bold
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  // Tombol untuk Register
                  TextButton(
                    onPressed: () {
                      // Pindah ke halaman register
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(), // Ganti dengan layar register
                        ),
                      );
                    },
                    child: Text("Belum punya akun? Daftar di sini"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
