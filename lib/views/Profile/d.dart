import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relife/models/user.dart';
import 'package:relife/views/Login/login_page.dart';
import 'package:relife/utils/appbar.dart';

import 'package:http/http.dart' as http;

import '../../data/users.dart';
import '../../utils/bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 1;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late Future<bool> _loginCheck;
  late Future<User?> _user;
  File? _image;

  @override
  void initState() {
    super.initState();
    _loginCheck = Users.checkUserLoggedIn();
    _user = _loginCheck.then((isLoggedIn) {
      if (isLoggedIn) {
        return Users.fetchCurrentUser();
      } else {
        return null;
      }
    });
  }

  void uploadImage(int userid) async {
    print(userid);
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:3000/upload/$userid'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', image.path),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Imagem enviada com sucesso!');
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
          bool isLoggedIn = snapshot.data ?? false;
          if (isLoggedIn) {
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
                      child: Text('Erro: ${userSnapshot.error}'),
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
                      bottomNavigationBar: CustomBottomNavigationBar(
                        selectedIndex: _selectedIndex,
                        onTabSelected: _onTabSelected,
                      ),
                    );
                  } else {
                    // Usuário não encontrado (tratar caso o usuário logado não exista mais)
                    return Scaffold(
                      appBar: customAppBar(),
                      body: const Center(
                        child: Text('Usuário não encontrado.'),
                      ),
                    );
                  }
                }
              },
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            });
            return const SizedBox();
          }
        }
      },
    );
  }

  Widget _buildAvatar(User user) {
    if (user.image == 'default.png') {
      return const CircleAvatar(
        radius: 100,
        backgroundColor: Colors.grey,
        backgroundImage:
            NetworkImage('http://localhost:3000/imagens/default.png'),
      );
    } else {
      return CircleAvatar(
        radius: 100,
        backgroundColor: Colors.grey,
        child: Image.network(
          'http://localhost:3000/imagens/${user.id}.jpg?timestamp=${DateTime.now()}', //truque para garantir que a imagem é atualizada
        ),
      );
    }
  }
}
