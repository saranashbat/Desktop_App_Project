import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/global_parameters.dart';
import '../models/user.dart';
import '../models/login_request.dart';

class UserService {
  // -------------------------------
  // LOGIN
  // -------------------------------
  Future<User> login(LoginRequest req) async {
    final response = await http.post(
      Uri.parse('${GlobalParameters.usersEndpoint}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed');
    }
  }

  // -------------------------------
  // GET USER BY ID
  // -------------------------------
  Future<User> getUser(String id) async {
    final response = await http.get(
      Uri.parse('${GlobalParameters.usersEndpoint}/$id'),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  // -------------------------------
  // UPDATE PROFILE IMAGE
  // -------------------------------
  Future<User> updateProfileImage(String id, String imagePath) async {
    final response = await http.patch(
      Uri.parse('${GlobalParameters.usersEndpoint}/$id/image?imagePath=$imagePath'),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update profile image');
    }
  }

  // -------------------------------
  // CREATE USER (for admin/testing)
  // -------------------------------
  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(GlobalParameters.usersEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }
}
