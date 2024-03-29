// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:relife/models/user.dart';
import 'package:relife/utils/urls.dart';
import 'package:relife/utils/shared.dart';
import 'package:relife/views/start.dart';

class Users {
  //constants
  static const String register = 'https://relife-api.vercel.app/register';
  static const String login = 'https://relife-api.vercel.app/login';
  //static const String getUser = 'http://localhost:3000/currentUser';

  static Future<dynamic> createUser(
      String name, String email, String password, String mobilePhone) async {
    final response = await http.post(
      Uri.parse(register),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'mobile_phone': mobilePhone,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 409) {
      // 409 indicates email already exists
      return 'E-mail já está em uso';
    } else if (response.statusCode == 410) {
      return 'Mobile Phone in use';
    } else {
      throw Exception(
          'Falha ao criar usuário'); // Throw a generic exception for other errors
    }
  }

  static Future<String> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token =
          responseData['token']; // Extrai o token do objeto decodificado
      if (token != null && token.isNotEmpty) {
        // Armazena o token no SharedPreferences
        await SharedPreferencesHelper.saveToken(token);
        return token;
      } else {
        throw Exception('Token inválido');
      }
    } else {
      throw Exception('Falha na autenticação');
    }
  }

  static Future<int> getUserTotalDonation(int userId) async {
    final url = '$baseAPIurl/donations/$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final totalDonation = data['totalDonation'] as int;
      return totalDonation;
    } else {
      throw Exception('Falha ao obter o valor total da doação do usuário');
    }
  }

  static Future<int> getUserDonationCount(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseAPIurl/donations/$userId/count'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final count = data['count'] as int;
        return count;
      } else {
        throw Exception('Failed to get user donation count');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<User> fetchCurrentUser() async {
    final token = await SharedPreferencesHelper.getToken();

    if (token != null && token.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      //print(decodedToken);
      // ignore: unnecessary_null_comparison
      if (decodedToken != null) {
        final user = User.fromJson(decodedToken);
        return user;
      } else {
        throw Exception('Failed to decode token');
      }
    } else {
      throw Exception('Invalid token');
    }
  }

  static Future<bool> checkUserLoggedIn() async {
    String? token = await SharedPreferencesHelper.getToken();
    if (token != null && token.isNotEmpty) {
      return true;
    }
    return false;
  }

  static void logout(context) async {
    // Remove o token
    await SharedPreferencesHelper.removeToken();

    // Redireciona para a tela de login
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const InitialPage()));
  }

  static Future<dynamic> recoverPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseAPIurl/recover-password',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return 'Deverá Receber um e-mail com uma palavra passe nova';
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<String> getUserName(int userId) async {
    final url =
        '$baseAPIurl/getUserName/$userId'; // Substitua pela URL correta do seu backend
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final userName = data['name'];
      return userName;
    } else {
      throw Exception('Erro ao buscar o nome do usuário');
    }
  }

  static Future<void> changeEmail(int userId, String email) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$baseAPIurl/user/email',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_user': userId,
          'email': email,
        }),
      );

      print(response.statusCode);
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<void> changePassword(int userId, String password) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$baseAPIurl/user/password',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_user': userId,
          'password': password,
        }),
      );

      print(response.statusCode);
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<void> updateImage(int userId, String image) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$baseAPIurl/user/image',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_user': userId,
          'image': image,
        }),
      );

      print(response.statusCode);
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<String> refreshToken(
      String oldToken, String imgurImageId) async {
    final response = await http.post(
      Uri.parse('$baseAPIurl/refresh-token'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'oldToken': oldToken,
        'imgurImageId': imgurImageId,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final newToken = jsonResponse['token'];
      return newToken;
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  static Future<void> deleteUser(int userId) async {
    try {
      final response = await http.delete(
          Uri.parse(
            '$baseAPIurl/user',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id_user': userId,
          }));

      print(response.statusCode);
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
