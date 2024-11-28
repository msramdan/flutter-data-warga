import 'package:flutter/material.dart';
import 'dart:convert'; // Import missing for json.decode
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome icons
import '../widgets/navbar.dart'; // Navbar for bottom navigation
import '../widgets/header.dart'; // Header widget
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic> _userDetails = {}; // Store user details

  @override
  void initState() {
    super.initState();
    _loadUserDetails(); // Load user details when screen initializes
  }

  // Function to load user details from SharedPreferences
  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetailsString = prefs.getString('detailWarga'); // Retrieve the stored user data
    
    if (userDetailsString != null) {
      setState(() {
        _userDetails = json.decode(userDetailsString); // Decode JSON string into a map
      });
    }
  }

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
  child: _userDetails.isEmpty
      ? Center(child: CircularProgressIndicator()) // Show loading indicator while loading
      : ListView(
          padding: EdgeInsets.all(16), // Add padding around the ListView
          children: [
            _buildUserInfoTile(FontAwesomeIcons.user, "Nama", _userDetails['nama']),
            _buildUserInfoTile(FontAwesomeIcons.idCard, "No KK", _userDetails['no_kk']),
            _buildUserInfoTile(FontAwesomeIcons.idCardAlt, "NIK", _userDetails['nik']),
            _buildUserInfoTile(FontAwesomeIcons.male, "Jenis Kelamin", _userDetails['jenis_kelamin']),
            _buildUserInfoTile(FontAwesomeIcons.birthdayCake, "Tanggal Lahir", _userDetails['tanggal_lahir']),
            _buildUserInfoTile(FontAwesomeIcons.mapMarkerAlt, "Tempat Lahir", _userDetails['tempat_lahir']),
            _buildUserInfoTile(FontAwesomeIcons.church, "Agama", _userDetails['agama']),
            _buildUserInfoTile(FontAwesomeIcons.ring, "Status Perkawinan", _userDetails['status_kawin']),
            _buildUserInfoTile(FontAwesomeIcons.tint, "Golongan Darah", _userDetails['golongan_darah']),
            _buildUserInfoTile(FontAwesomeIcons.briefcase, "Pekerjaan", _userDetails['pekerjaan']),
            _buildUserInfoTile(FontAwesomeIcons.home, "Alamat Lengkap", _userDetails['alamat_lengkap']),
          ],
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

  // Custom function to create a list item for displaying user information with an icon
  Widget _buildUserInfoTile(IconData icon, String title, String? value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8), // Margin between cards
      elevation: 5, // Add some shadow for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 30), // Icon with color and size
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)), // Title with bold text
        subtitle: Text(value ?? 'Not available', style: TextStyle(fontSize: 16)), // Display value or a default message
      ),
    );
  }
}
