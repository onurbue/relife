import 'package:flutter/material.dart';

import 'package:relife/data/users.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Login/login_page.dart';

class RecoverPassword extends StatelessWidget {
  const RecoverPassword({super.key});

  @override
  Widget build(BuildContext context) {
    // variables
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();

    // ignore: no_leading_underscores_for_local_identifiers
    void _submitForm() {
      if (formKey.currentState!.validate()) {
        final email = emailController.text;
        Users.recoverPassword(email).then((response) {
          if (response is String) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Deverá receber um e-mail com uma palavra passe nova'),
              ),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
          }
        });
      }
    }

    return Scaffold(
      appBar: customAppBar(true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Recover Password',
            style: CustomTextStyles.title,
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Column(children: [
              Form(
                key: formKey,
                child: Column(children: [
                  const SizedBox(height: 100),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please, insert an email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 70),
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
                        'Recover Password',
                        style: CustomTextStyles.button,
                      ),
                    ),
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
