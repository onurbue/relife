import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relife/views/Login/login_page.dart';

import '../../widgets/appbar.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Register',
            style: GoogleFonts.workSans(
                textStyle:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Insere o teu nome',
                  labelText: 'Nome',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Insere a tua idade',
                  labelText: 'Idade',
                ),
              ),
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
                        builder: (context) => const LoginPage(),
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
                    'Registar',
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
