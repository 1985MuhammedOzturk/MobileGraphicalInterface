import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import for EncryptedSharedPreferences

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage(); // Create a storage instance
  String _imageSource = 'images/questionmark.png';

  void _checkLogin() async {
    setState(() {
      if (_passwordController.text == 'QWERTY123') {
        _imageSource = 'images/idea.png';
        _saveLoginData(); // Call save function after successful login
      } else {
        _imageSource = 'images/stop.png';
      }
    });
  }

  Future<void> _saveLoginData() async {
    bool save = await _showSaveDialog(); // Show dialog and get user choice
    if (save) {
      await storage.write(key: 'username', value: _loginController.text);
      await storage.write(key: 'password', value: _passwordController.text);
    } else {
      await storage.deleteAll(); // Clear any saved data
    }
  }

  Future<bool> _showSaveDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save Login Details?'),
        content: Text('Would you like to save your login information for next time?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Save on Ok
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Clear on Cancel
            child: Text('No'),
          ),
        ],
      ),
    );
    return result ?? false; // Default to false if dialog is dismissed without choice
  }

  Future<void> _loadLoginData() async {
    final username = await storage.read(key: 'username');
    final password = await storage.read(key: 'password');
    if (username != null && password != null) {
      setState(() {
        _loginController.text = username;
        _passwordController.text = password;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Previous Login Details Loaded'),
            action: SnackBarAction(
              label: 'Clear Saved Data',
              onPressed: () => _clearLoginData(),
            ),
          ),
        );
      });
    }
  }

  void _clearLoginData() async {
    await storage.deleteAll();
    setState(() {
      _loginController.text = '';
      _passwordController.text = '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLoginData(); // Load data on app start
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
    onPressed: _checkLogin,
    child: Text('Login'),
    ),
    SizedBox(height: 20),
    Image.asset(
    _imageSource,
    width: 300,
    height: 300,
    ),
    ],
    ),
    )
