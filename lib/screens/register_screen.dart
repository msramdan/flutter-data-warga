import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helpers/api_helper.dart';
import 'login_screen.dart'; // Mengimpor halaman login setelah registrasi berhasil

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController noKkController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController tanggalLahirController =
      TextEditingController(); // Controller for Tanggal Lahir

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> agamaList = [
    'Islam',
    'Kristen Protestan',
    'Kristen Katolik',
    'Hindu',
    'Buddha',
    'Konghucu'
  ];
  final List<String> genderList = ['Laki-Laki', 'Perempuan'];
  final List<String> statusKawinList = [
    'Belum Kawin',
    'Kawin',
    'Cerai Hidup',
    'Cerai Mati'
  ];
  final List<String> golonganDarahList = ['A', 'B', 'AB', 'O'];

  String? _selectedAgama;
  String? _selectedGender;
  String? _selectedStatusKawin;
  String? _selectedGolonganDarah;
  DateTime? _selectedTanggalLahir; // Store the selected date

  Future<void> register() async {
    final nama = namaController.text;
    final nik = nikController.text;
    final noKk = noKkController.text;
    final tempatLahir = tempatLahirController.text;
    final pekerjaan = pekerjaanController.text;
    final alamat = alamatController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final tanggalLahir = _selectedTanggalLahir != null
        ? _selectedTanggalLahir!.toIso8601String()
        : ''; // Convert DateTime to String if not null

    if (nama.isEmpty ||
        nik.isEmpty ||
        noKk.isEmpty ||
        tempatLahir.isEmpty ||
        pekerjaan.isEmpty ||
        alamat.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        _selectedAgama == null ||
        _selectedGender == null ||
        _selectedStatusKawin == null ||
        _selectedGolonganDarah == null ||
        _selectedTanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Semua field harus diisi"),
      ));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password dan Konfirmasi Password tidak cocok"),
      ));
      return;
    }

    // Add password length validation (minimum 6 characters)
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password harus memiliki minimal 6 karakter"),
      ));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiHelper.getUrl("register")),
        body: {
          'nama': nama,
          'nik': nik,
          'no_kk': noKk,
          'agama': _selectedAgama!,
          'jenis_kelamin': _selectedGender!,
          'tempat_lahir': tempatLahir,
          'pekerjaan': pekerjaan,
          'alamat_lengkap': alamat,
          'status_kawin': _selectedStatusKawin!,
          'golongan_darah': _selectedGolonganDarah!,
          'tanggal_lahir': tanggalLahir, // Include tanggal_lahir
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Registrasi berhasil! Menunggu verifikasi Ketua RT"),
        ));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      } else {
        final error = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error['message'] ?? 'Registrasi gagal!'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Terjadi kesalahan saat melakukan registrasi: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Akun"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: nikController,
                    decoration: InputDecoration(
                      labelText: "NIK",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: noKkController,
                    decoration: InputDecoration(
                      labelText: "Nomor KK",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedAgama,
                    items: agamaList.map((agama) {
                      return DropdownMenuItem<String>(
                        value: agama,
                        child: Text(agama),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAgama = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Agama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items: genderList.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Jenis Kelamin",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: tempatLahirController,
                    decoration: InputDecoration(
                      labelText: "Tempat Lahir",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Date Picker for Tanggal Lahir
                  TextField(
                    controller: tanggalLahirController,
                    decoration: InputDecoration(
                      labelText: "Tanggal Lahir",
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedTanggalLahir = pickedDate;
                          tanggalLahirController.text =
                              '${pickedDate.toLocal()}'.split(' ')[0];
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedStatusKawin,
                    items: statusKawinList.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatusKawin = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Status Kawin",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGolonganDarah,
                    items: golonganDarahList.map((golongan) {
                      return DropdownMenuItem<String>(
                        value: golongan,
                        child: Text(golongan),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGolonganDarah = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Golongan Darah",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: pekerjaanController,
                    decoration: InputDecoration(
                      labelText: "Pekerjaan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: alamatController,
                    decoration: InputDecoration(
                      labelText: "Alamat",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Konfirmasi Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(double.infinity, 50), // Tombol penuh lebar
                      backgroundColor:
                          Colors.blue, // Set warna latar belakang biru
                      foregroundColor:
                          Colors.white, // Set warna teks menjadi putih
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Sudut tombol melengkung
                      ),
                    ),
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold, // Membuat teks menjadi bold
                      ),
                    ),
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
