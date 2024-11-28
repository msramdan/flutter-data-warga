import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Import the AuthService
import '../screens/login_screen.dart'; // Import the LoginScreen for navigation
import '../screens/aduan_warga_screen.dart'; // Import your other screen
import '../screens/kegiatan_screen.dart'; // Import KegiatanScreen or other screens

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  Navbar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) async {
        // Check if the tapped item is the logout item (index 3)
        if (index == 3) {
          bool success = await AuthService().logout();
          
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Logout successful")),
            );
            // Redirect to login screen without replacing the stack
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Logout failed. Please try again.")),
            );
          }
        } else if (index == 1) {
          // Navigate to Aduan Warga screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AduanWargaScreen()),
          );
        } else if (index == 2) {
          // Navigate to Kegiatan screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KegiatanScreen()),
          );
        } else {
          // Call the onItemTapped function for other tabs
          onItemTapped(index);
        }
      },
      backgroundColor: Colors.blue, // Navbar background color
      selectedItemColor: Colors.white, // Color for selected item
      unselectedItemColor: Colors.white.withOpacity(0.6), // Color for unselected items
      type: BottomNavigationBarType.fixed,
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
