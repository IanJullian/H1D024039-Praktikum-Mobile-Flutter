
import 'package:flutter/material.dart';
import 'package:router_flutter/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  // Menyimpan username ke local storage
  Future<void> _saveUsername() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'username',
      _usernameController.text,
    );
  }

  // Menampilkan input username dan password
  Widget _showInput(
    TextEditingController namacontroller,
    String placeholder,
    bool isPassword,
  ) {
    return TextField(
      controller: namacontroller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: placeholder,
      ),
    );
  }

  // Menampilkan dialog setelah login
  Future<void> _showDialog(String pesan, Widget alamat) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(pesan),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => alamat,
      ),
    );
  }

  // Proses validasi login
  Future<void> _login() async {
    if (_usernameController.text == 'admin' &&
        _passwordController.text == 'admin') {

      // Simpan username
      await _saveUsername();

      if (!mounted) return;

      // Login berhasil
      await _showDialog(
        'Anda Berhasil Login',
        const HomePage(),
      );
    } else {
      // Login gagal
      await _showDialog(
        'Username dan Password Salah',
        const LoginPage(),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _showInput(
              _usernameController,
              'Masukkan Username',
              false,
            ),
            _showInput(
              _passwordController,
              'Masukkan Password',
              true,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
