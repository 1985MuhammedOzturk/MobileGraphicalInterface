import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  String _imageSource = 'images/questionmark.png';

  final _secureStorage = FlutterSecureStorage();

  Future<void> _checkLogin() async {
    final password = _passwordController.text;

    if (password == 'QWERTY123') {
      _imageSource = 'images/idea.png';
      // Save username and password to EncryptedSharedPreferences
      await _secureStorage.write(key: 'username', value: _loginController.text);
      await _secureStorage.write(key: 'password', value: password);
    } else {
      _imageSource = 'images/stop.png';
      // Clear saved data in EncryptedSharedPreferences
      await _secureStorage.delete(key: 'username');
      await _secureStorage.delete(key: 'password');
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Load data from EncryptedSharedPreferences on program start
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final username = await _secureStorage.read(key: 'username');
    final password = await _secureStorage.read(key: 'password');

    if (username != null && password != null) {
      // Populate EditText fields with stored values
      _loginController.text = username;
      _passwordController.text = password;

      // Show Snackbar indicating loaded data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Previous login name and passwords loaded.'),
          action: SnackBarAction(
            label: 'Clear Saved Data',
            onPressed: () {
              // Clear data and reset EditText fields
              _loginController.clear();
              _passwordController.clear();
              _secureStorage.delete(key: 'username');
              _secureStorage.delete(key: 'password');
            },
          ),
        ),
      );
    }
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
      ),
    );
  }
}
