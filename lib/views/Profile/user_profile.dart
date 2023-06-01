import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relife/models/user.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Login/login_page.dart';
import 'package:relife/utils/appbar.dart';

import 'package:http/http.dart' as http;

import '../../data/users.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<bool> _loginCheck;
  late Future<User?> _user;
  late File _image;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _loginCheck = Users.checkUserLoggedIn();
    _user = _loginCheck.then((isLoggedIn) {
      if (isLoggedIn) {
        return Users.fetchCurrentUser().then((user) {
          setState(() {
            _currentUser = user;
          });
          return user;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  void uploadImage(int userId) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:3000/upload/$userId'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', image.path),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Imagem enviada com sucesso!');

      setState(() {});
    } else {
      print(
          'Falha ao enviar a imagem. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loginCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: customAppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: customAppBar(),
            body: Center(
              child: Text('Erro: ${snapshot.error}'),
            ),
          );
        } else {
          return FutureBuilder<User?>(
            future: _user,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  appBar: customAppBar(),
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (userSnapshot.hasError) {
                return Scaffold(
                  appBar: customAppBar(),
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () => Users.logout(context),
                      child: const Text('Logout'),
                    ),
                  ),
                );
              } else {
                User? user = userSnapshot.data;
                if (user != null) {
                  return Scaffold(
                    appBar: customAppBar(),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Stack(
                          children: [
                            _buildAvatar(user),
                            Positioned(
                              top: 150,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  uploadImage(user.id);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.edit,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('Registered since'),
                        Text('Olá, ${user.name}'),
                        const SizedBox(height: 50),
                        Text('Statistics'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('value'),
                                Text('Donations'),
                              ],
                            ),
                            Column(
                              children: [
                                Text('value'),
                                Text('total donated'),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 50),
                        Text('Settings'),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () => Users.logout(context),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }
            },
          );
        }
      },
    );
  }

  Widget _buildAvatar(User user) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: primaryColor,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(
          'https://relife-api.vercel.app/imagens/${user.image}?timestamp=${DateTime.now()}', //truque para atualizar a imagem
        ),
      ),
    );
  }
}
