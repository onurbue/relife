import 'package:flutter/material.dart';
import 'package:relife/views/Profile/user_profile.dart';

import '../../data/users.dart';
import '../../utils/appbar.dart';
import '../../utils/constants.dart';

class ChangePasswordPage extends StatefulWidget {
  final int userId;
  const ChangePasswordPage({super.key, required this.userId});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

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
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Change Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please, insert a Password';
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
                Users.changePassword(widget.userId, _passwordController.text);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
            ),
          ),
          const Row(),
        ],
      ),
    );
  }
}
