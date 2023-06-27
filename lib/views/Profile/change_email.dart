import 'package:flutter/material.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/utils/constants.dart';

class ChangeEmailPage extends StatefulWidget {
  final int userId;
  const ChangeEmailPage({super.key, required this.userId});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Change Email',
              style: CustomTextStyles.title,
            ),
          ),
          const SizedBox(height: 50),
          Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Change Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please, insert an e-mail';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          SizedBox(
            height: 48,
            width: 238,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Change'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Row(),
        ],
      ),
    );
  }
}
