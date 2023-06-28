import 'package:flutter/material.dart';

import 'package:relife/views/start.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/data/users.dart';
import 'package:relife/views/Register/register.dart';
import 'package:relife/views/RecoverPassword/recover_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Controllers &  Form key
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      Users.loginUser(email, password).then((token) {
        // Armazena o token no SharedPreferences
        SharedPreferences.getInstance().then((prefs) {
          // Armazene o token como uma string
          prefs.setString('token', token);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InitialPage()),
          );
        });
      }).catchError((error) {
        // Trata o erro de login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid password or email'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: CustomTextStyles.title,
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Column(children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please, insert an email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please, insert your password';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: 346,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: CustomTextStyles.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecoverPassword(),
                    ),
                  );
                },
                child: const Text('Recover password'),
              ),
              const SizedBox(height: 100),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New User? '),
                      Text(
                        'Create an account',
                        style: TextStyle(color: primaryColor),
                      ),
                    ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
