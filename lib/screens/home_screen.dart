import 'package:flutter/material.dart';
import '../widgets/navbar.dart'; // Navbar for bottom navigation
import '../widgets/header.dart'; // Header widget
import '../screens/aduan_warga_screen.dart'; // Aduan Warga screen
import '../screens/kegiatan_screen.dart'; // Kegiatan screen

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
