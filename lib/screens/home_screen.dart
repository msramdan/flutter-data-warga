// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/navbar.dart'; // Navbar untuk bottom navigation
import '../widgets/header.dart'; // Header yang sudah dibuat

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Menghilangkan AppBar
        child: Container(),
      ),
      body: Column(
        children: [
          Header(), // Menambahkan Header
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
