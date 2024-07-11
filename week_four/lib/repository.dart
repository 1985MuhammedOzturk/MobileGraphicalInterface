import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class UserRepository {
  final encrypt.Key key = encrypt.Key.fromUtf8('32-byte-key-12345678901234567890');
  final encrypt.IV iv = encrypt.IV.fromUtf8('1234567890123456'); // 16 bytes
  late final encrypt.Encrypter encrypter;

  UserRepository() {
    encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  }

  Future<void> saveData(String username, String password, String firstName, String lastName, String phoneNumber, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedFirstName = encrypter.encrypt(firstName, iv: iv).base64;
    final encryptedLastName = encrypter.encrypt(lastName, iv: iv).base64;
    final encryptedPhoneNumber = encrypter.encrypt(phoneNumber, iv: iv).base64;
    final encryptedEmail = encrypter.encrypt(email, iv: iv).base64;

    await prefs.setString('$username:$password:firstName', encryptedFirstName);
    await prefs.setString('$username:$password:lastName', encryptedLastName);
    await prefs.setString('$username:$password:phoneNumber', encryptedPhoneNumber);
    await prefs.setString('$username:$password:email', encryptedEmail);
  }

  Future<Map<String, String>> loadData(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedFirstName = prefs.getString('$username:$password:firstName');
    final encryptedLastName = prefs.getString('$username:$password:lastName');
    final encryptedPhoneNumber = prefs.getString('$username:$password:phoneNumber');
    final encryptedEmail = prefs.getString('$username:$password:email');

    return {
      'firstName': encryptedFirstName != null ? encrypter.decrypt64(encryptedFirstName, iv: iv) : '',
      'lastName': encryptedLastName != null ? encrypter.decrypt64(encryptedLastName, iv: iv) : '',
      'phoneNumber': encryptedPhoneNumber != null ? encrypter.decrypt64(encryptedPhoneNumber, iv: iv) : '',
      'email': encryptedEmail != null ? encrypter.decrypt64(encryptedEmail, iv: iv) : '',
    };
  }
}
