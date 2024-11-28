import 'package:flutter/material.dart';

class KegiatanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kegiatan Wa"),
      ),
      body: Center(
        child: Text("Daftar Kegiatan akan ditampilkan di sini"),
      ),
    );
  }
}
