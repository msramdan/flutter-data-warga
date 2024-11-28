import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For Date formatting
import '../services/aduan_service.dart'; // Aduan Service to handle post requests
import '../services/auth_service.dart'; // Import the AuthService to get the logged-in user

class AduanFormScreen extends StatefulWidget {
  @override
  _AduanFormScreenState createState() => _AduanFormScreenState();
}

class _AduanFormScreenState extends State<AduanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final AduanService _aduanService = AduanService();
  late Future<String> _userName; // Declare a future to store the user name

  String _judul = '';
  String _keterangan = '';
  String _namaPengirim = ''; // Initially empty, will be filled with dynamic username
  String _tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // Fetch the logged-in user's name when the widget is initialized
    _userName = AuthService().getUserName(); // Assuming AuthService returns a Future<String>
  }

  // Method to submit the aduan data
  Future<void> _submitAduan() async {
    if (_formKey.currentState!.validate()) {
      final aduanData = {
        'nama_pengirim': _namaPengirim,
        'tanggal': _tanggal,
        'judul': _judul,
        'keterangan': _keterangan,
      };
      try {
        final response = await _aduanService.submitAduan(aduanData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aduan submitted successfully')),
        );
        Navigator.pop(context); // Close the form
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit aduan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Aduan Warga')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: _userName, // Wait for the username to be fetched
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No user data available'));
            }

            // Once the username is fetched, update the state
            _namaPengirim = snapshot.data!;

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Judul Aduan'),
                    onChanged: (value) {
                      setState(() {
                        _judul = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Keterangan Aduan'),
                    onChanged: (value) {
                      setState(() {
                        _keterangan = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Keterangan is required';
                      }
                      return null;
                    },
                    maxLines: 5,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submitAduan,
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
                      "Kirim Aduan",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold, // Membuat teks menjadi bold
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
