import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:relife/models/user.dart';
import 'package:relife/utils/shared.dart';
import 'package:relife/views/start.dart';

class Users {
  //constants
  static const String register = 'http://localhost:3000/register';
  static const String login = 'http://localhost:3000/login';
  static const String getUser = 'http://localhost:3000/currentUser';

  static Future<dynamic> createUser(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(register),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
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

  static Future<User> fetchCurrentUser() async {
    final token = await SharedPreferencesHelper.getToken();
    print(token);
    if (token != null && token.isNotEmpty) {
      final response = await http.get(
        Uri.parse(getUser),
        headers: <String, String>{
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final user = User.fromJson(responseData);
        print(user);
        return user;
      } else {
        throw Exception('Falha ao obter os dados do usuário');
      }
    } else {
      throw Exception('Token inválido');
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
}
