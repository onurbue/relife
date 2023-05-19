import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relife/views/HomePage/homepage.dart';
import 'package:relife/widgets/appbar.dart';

import '../RecoverPassword/recover_password.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: GoogleFonts.workSans(
                textStyle:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Insere o teu email',
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Insere a tua password',
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 346,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecoverPassword()));
                },
                child: const Text('Recuperar Password'),
              ),
            ]),
          ),
          //formulário
        ],
      ),
    );
  }
}
