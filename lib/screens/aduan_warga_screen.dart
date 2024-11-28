import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Library for formatting dates
import '../widgets/navbar.dart'; // Navbar for bottom navigation
import '../widgets/header.dart'; // Header widget
import '../services/aduan_service.dart'; // Import the AduanService
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Optional loading spinner
import 'aduan_form_screen.dart'; // Import the Aduan Form Screen

class AduanWargaScreen extends StatefulWidget {
  @override
  _AduanWargaScreenState createState() => _AduanWargaScreenState();
}

class _AduanWargaScreenState extends State<AduanWargaScreen> {
  int _selectedIndex = 1;
  final AduanService _aduanService = AduanService(); // Initialize AduanService
  List<dynamic> _aduanList = [];
  bool _isLoading = true;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchAduan();
  }

  // Fetch aduan data
  Future<void> _fetchAduan() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final aduanData = await _aduanService.fetchAduan(
        startDate: _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : null,
        endDate: _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : null,
      );
      setState(() {
        _aduanList = aduanData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // Function to show the DatePicker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
      _fetchAduan();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Navigate to the aduan form screen
  void _navigateToForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AduanFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(),
      ),
      body: Column(
        children: [
          Header(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _startDate != null
                            ? DateFormat('yyyy-MM-dd').format(_startDate!)
                            : 'Start Date',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _endDate != null
                            ? DateFormat('yyyy-MM-dd').format(_endDate!)
                            : 'End Date',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: _aduanList.length,
                    itemBuilder: (context, index) {
                      final aduan = _aduanList[index];
                      return Card(
                        color: Colors.lightBlue.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.only(bottom: 12.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.report_problem,
                            color: Colors.blue,
                          ),
                          title: Text(
                            aduan['judul'] ?? 'Judul tidak tersedia',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          subtitle: Text(
                            'Pengirim: ${aduan['nama_pengirim'] ?? 'Tidak diketahui'}\nTanggal: ${aduan['tanggal'] ?? '-'}',
                          ),
                          onTap: () {
                            // Handle card tap, if needed
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToForm,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
