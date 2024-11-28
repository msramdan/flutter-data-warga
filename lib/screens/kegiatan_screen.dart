import 'package:flutter/material.dart';
import '../widgets/navbar.dart'; // Navbar for bottom navigation
import '../widgets/header.dart'; // Header widget

class KegiatanScreen extends StatefulWidget {
  @override
  _KegiatanScreenState createState() => _KegiatanScreenState();
}

class _KegiatanScreenState extends State<KegiatanScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Hide the AppBar
        child: Container(),
      ),
      body: Column(
        children: [
          Header(), // Add Header widget
          Expanded(
            child: Center(
              child: Text("Daftar Kegiatan akan ditampilkan di sini"),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
