import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'repository.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String password;

  ProfilePage({required this.username, required this.password});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final UserRepository _repository = UserRepository();

  @override
  void initState() {
    super.initState();
    _loadData();
    _firstNameController.addListener(_saveData);
    _lastNameController.addListener(_saveData);
    _phoneNumberController.addListener(_saveData);
    _emailController.addListener(_saveData);
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_saveData);
    _lastNameController.removeListener(_saveData);
    _phoneNumberController.removeListener(_saveData);
    _emailController.removeListener(_saveData);
    _saveData(); // Save data when the page is disposed
    super.dispose();
  }

  Future<void> _loadData() async {
    print('Loading data for user: ${widget.username}');
    final data = await _repository.loadData(widget.username, widget.password);
    print('Data loaded for ${widget.username}: $data');
    setState(() {
      _firstNameController.text = data['firstName'] ?? '';
      _lastNameController.text = data['lastName'] ?? '';
      _phoneNumberController.text = data['phoneNumber'] ?? '';
      _emailController.text = data['email'] ?? '';
    });
  }

  Future<void> _saveData() async {
    print('Saving data for user: ${widget.username}');
    await _repository.saveData(
      widget.username,
      widget.password,
      _firstNameController.text,
      _lastNameController.text,
      _phoneNumberController.text,
      _emailController.text,
    );
    print('Data saved for ${widget.username}');
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('This URL is not supported on this device.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () => _launchUrl('tel:${_phoneNumberController.text}'),
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () => _launchUrl('sms:${_phoneNumberController.text}'),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email address'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.email),
                  onPressed: () => _launchUrl('mailto:${_emailController.text}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
