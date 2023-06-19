import 'package:flutter/material.dart';
import 'package:relife/data/users.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/utils/constants.dart';

class RecoverPassword extends StatelessWidget {
  const RecoverPassword({super.key});

  @override
  Widget build(BuildContext context) {
    // variables
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();

    // submit the form
    void _submitForm() {
      if (_formKey.currentState!.validate()) {
        final email = _emailController.text;
      }
    }

    return Scaffold(
      appBar: customAppBar(),
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
                key: _formKey,
                child: Column(children: [
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
                  const SizedBox(height: 16),
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
