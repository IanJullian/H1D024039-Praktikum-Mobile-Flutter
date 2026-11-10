
import 'package:flutter/material.dart';
import 'package:ian_shop/sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var namauser;

  void _loadUsername() async {
    // Inisialisasi Shared Preferences
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    // Ambil username yang sudah tersimpan
    namauser = prefs.getString('username');

    // Set username on UI
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Text('Ini adalah halaman User $namauser'),
      ),
      drawer: const Sidemenu(),
    );
  }
}
