import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:relife/models/user.dart';
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
    } else {
      throw Exception('Erro ao criar usuário');
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
    final url = 'https://relife-api.vercel.app/donations/$userId';
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
      final response = await http.get(
          Uri.parse('https://relife-api.vercel.app/donations/$userId/count'));

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

  // static Future<User> fetchCurrentUser() async {
  //   final token = await SharedPreferencesHelper.getToken();

  //   if (token != null && token.isNotEmpty) {
  //     final response = await http.get(
  //       Uri.parse(getUser),
  //       headers: <String, String>{
  //         'Authorization': token,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       final user = User.fromJson(responseData);
  //       print(user);
  //       return user;
  //     } else {
  //       throw Exception('Falha ao obter os dados do user');
  //     }
  //   } else {
  //     throw Exception('Token inválido');
  //   }
  // }

  static Future<User> fetchCurrentUser() async {
    final token = await SharedPreferencesHelper.getToken();

    if (token != null && token.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      print(decodedToken);
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

  static Future<int> recoverPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://relife-api.vercel.app/recover-password',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      return response.statusCode;
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
