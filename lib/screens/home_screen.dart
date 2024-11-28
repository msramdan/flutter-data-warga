import 'package:flutter/material.dart';
import '../widgets/navbar.dart'; // Navbar untuk bottom navigation

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
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text(
          _selectedIndex == 0
              ? 'Selamat datang di halaman Home!'
              : _selectedIndex == 1
                  ? 'Aduan Warga'
                  : _selectedIndex == 2
                      ? 'Kegiatan'
                      : 'Logout',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
