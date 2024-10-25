import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'https://apinodedb-1-sen4.onrender.com/api/'; // URL ของ RESTful API

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> signup(
      String username, String email, String password, File? image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users'));
    request.headers['Content-Type'] = 'application/json';

    // เพิ่มข้อมูลที่จำเป็น
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;

    // ถ้ามีภาพโปรไฟล์ ให้เพิ่มลงใน request
    if (image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('profile_image', image.path));
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseData = await response.stream.toBytes();
      return jsonDecode(String.fromCharCodes(responseData));
    }
    return null;
  }

  Future<bool> deleteAccount(int userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId'),
    );
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> updateProfile(
      int userId, String username, String email, String password) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}
