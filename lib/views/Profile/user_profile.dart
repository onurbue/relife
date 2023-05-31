import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relife/models/user.dart';
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
                  // body: Center(
                  //   child: Text('Erro: ${userSnapshot.error}'),
                  // ),
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
                        Row(),
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
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text('Olá, ${user.name}'),
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
    print(user.image);
    return CircleAvatar(
      radius: 100,
      backgroundColor: Colors.grey,
      backgroundImage: NetworkImage(
        'http://localhost:3000/imagens/${user.image}?timestamp=${DateTime.now()}', //truque para atualizar a imagem
      ),
    );
  }
}
