import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  Navbar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.blue, // Warna biru pada navbar
      selectedItemColor: Colors.white, // Warna putih saat item dipilih
      unselectedItemColor: Colors.white.withOpacity(0.6), // Warna putih transparan untuk item tidak dipilih
      type: BottomNavigationBarType.fixed, // Agar semua item memiliki ukuran yang konsisten
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feedback),
          label: 'Aduan Warga',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Kegiatan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          label: 'Logout',
        ),
      ],
    );
  }
}
