import 'package:flutter/material.dart';
import '../widgets/navbar.dart'; // Navbar for bottom navigation
import '../widgets/header.dart'; // Header widget

class AduanWargaScreen extends StatefulWidget {
  @override
  _AduanWargaScreenState createState() => _AduanWargaScreenState();
}

class _AduanWargaScreenState extends State<AduanWargaScreen> {
  int _selectedIndex = 1;

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
              child: Text("Daftar aduan akan ditampilkan di sini"),
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
