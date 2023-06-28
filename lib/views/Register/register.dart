import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relife/data/users.dart';
import 'package:relife/views/Login/login_page.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/utils/constants.dart';

import '../../utils/helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobilePhoneController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final mobilePhone = _mobilePhoneController.text;

      Users.createUser(name, email, password, mobilePhone).then((result) {
        if (result is String) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
            ),
          );
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      }).catchError((error) {
        //print(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(true),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Register',
              style: CustomTextStyles.title,
            ),
            Padding(
              padding: const EdgeInsets.all(21.5),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please, insert your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please, insert an email';
                        } else if (!isValidEmail(value)) {
                          return 'Please, insert a valid email.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _mobilePhoneController,
                      keyboardType: TextInputType.phone,
                      decoration:
                          const InputDecoration(labelText: 'Mobile Phone'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please, insert your mobile phone';
                        } else if (!isValidPhoneNumber(value)) {
                          return 'Please, insert a valid mobile phone';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please, insert a password';
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
                          'Register',
                          style: GoogleFonts.workSans(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
