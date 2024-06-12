import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final encrypt.Encrypter _encrypter;
  late final encrypt.Key _key;
  late final encrypt.IV _iv;

  @override
  void initState() {
    super.initState();
    // Ensure the key and IV are the correct sizes for AES-256
    _key = encrypt.Key.fromUtf8('32-byte-key-12345678901234567890'); // 32 bytes for AES-256
    _iv = encrypt.IV.fromUtf8('1234567890123456'); // 16 bytes
    _encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    _loadCredentials();
  }

  void _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedUsername = prefs.getString('username');
    final encryptedPassword = prefs.getString('password');

    if (encryptedUsername != null && encryptedPassword != null) {
      final username = _encrypter.decrypt64(encryptedUsername, iv: _iv);
      final password = _encrypter.decrypt64(encryptedPassword, iv: _iv);

      _loginController.text = username;
      _passwordController.text = password;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Credentials loaded!'),
          action: SnackBarAction(
            label: 'Clear saved data',
            onPressed: _clearCredentials,
          ),
        ),
      );
    }
  }

  void _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    _loginController.clear();
    _passwordController.clear();
  }

  void _showSaveCredentialsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Save Credentials?"),
          content: Text("Would you like to save your username and password securely for future use?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                _clearCredentials();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                await _saveCredentials();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedUsername = _encrypter.encrypt(_loginController.text, iv: _iv).base64;
    final encryptedPassword = _encrypter.encrypt(_passwordController.text, iv: _iv).base64;

    await prefs.setString('username', encryptedUsername);
    await prefs.setString('password', encryptedPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: 'Login name',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showSaveCredentialsDialog,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
