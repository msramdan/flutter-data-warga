import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart'; // Untuk memilih file
import 'dart:io'; // Untuk bekerja dengan file (gambar / pdf)
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
  final ImagePicker _picker = ImagePicker();
  XFile? _image; // File gambar kartu keluarga

  // Form validation
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Dropdown values for enums
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

  // Fungsi untuk memilih file kartu keluarga
  Future<void> _pickFile() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery); // Untuk gambar
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  // Fungsi untuk melakukan registrasi
  Future<void> register() async {
    final nama = namaController.text;
    final nik = nikController.text;
    final noKk = noKkController.text;
    final tempatLahir = tempatLahirController.text;
    final pekerjaan = pekerjaanController.text;
    final alamat = alamatController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

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
        _image == null) {
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

    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse(ApiHelper.getUrl("register")));
      request.fields['nama'] = nama;
      request.fields['nik'] = nik;
      request.fields['no_kk'] = noKk;
      request.fields['agama'] = _selectedAgama!;
      request.fields['jenis_kelamin'] = _selectedGender!;
      request.fields['tempat_lahir'] = tempatLahir;
      request.fields['pekerjaan'] = pekerjaan;
      request.fields['alamat_lengkap'] = alamat;
      request.fields['status_kawin'] = _selectedStatusKawin!;
      request.fields['golongan_darah'] = _selectedGolonganDarah!;
      request.fields['password'] = password;

      // Menambahkan file gambar (Kartu Keluarga)
      request.files.add(
          await http.MultipartFile.fromPath('kartu_keluarga', _image!.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Registrasi berhasil!"),
        ));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      } else {
        final error = json.decode(responseBody);
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
                  // Nama
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // NIK
                  TextField(
                    controller: nikController,
                    decoration: InputDecoration(
                      labelText: "NIK",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Nomor KK
                  TextField(
                    controller: noKkController,
                    decoration: InputDecoration(
                      labelText: "Nomor KK",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Agama Dropdown
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
                  // Jenis Kelamin Dropdown
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
                  // Tempat Lahir
                  TextField(
                    controller: tempatLahirController,
                    decoration: InputDecoration(
                      labelText: "Tempat Lahir",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Tanggal Lahir (Date Picker)
                  TextField(
                    controller: TextEditingController(
                      text: 'Tanggal Lahir',
                    ),
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
                          TextEditingController(
                            text: '${pickedDate.toLocal()}'.split(' ')[0],
                          );
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  // Pekerjaan
                  TextField(
                    controller: pekerjaanController,
                    decoration: InputDecoration(
                      labelText: "Pekerjaan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Alamat
                  TextField(
                    controller: alamatController,
                    decoration: InputDecoration(
                      labelText: "Alamat Lengkap",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Kartu Keluarga (File Picker)
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: Text("Pilih File Kartu Keluarga"),
                  ),
                  if (_image != null)
                    Text('File Terpilih: ${_image!.path.split('/').last}'),
                  SizedBox(height: 16),
                  // Password
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Confirm Password
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Konfirmasi Password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Button Registrasi

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
