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
  late Future<int> valorDoado;
  late Future<int> quantidadeDoacoes;

  @override
  void initState() {
    super.initState();
    _loginCheck = Users.checkUserLoggedIn();
    _user = _loginCheck.then((isLoggedIn) {
      if (isLoggedIn) {
        return Users.fetchCurrentUser().then((user) {
          setState(() {
            _currentUser = user;
            valorDoado = Users.getUserTotalDonation(_currentUser.id);
            quantidadeDoacoes = Users.getUserDonationCount(_currentUser.id);
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
      Uri.parse('https://relife-api.vercel.app/upload/$userId'),
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
            appBar: customAppBar(true),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: customAppBar(true),
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
                  appBar: customAppBar(true),
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (userSnapshot.hasError) {
                return Scaffold(
                  appBar: customAppBar(true),
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
                    appBar: customAppBar(true),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Stack(
                          children: [
                            _buildAvatar(user),
                            Positioned(
                              top: 150,
                              right: 25,
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
                                    radius: 12,
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

                        const Text('Registered since'),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Olá, ${user.name}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text('Statistics'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      FutureBuilder<int>(
                                        future: quantidadeDoacoes,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Erro: ${snapshot.error}');
                                          } else {
                                            int quantidadeDoacoes =
                                                snapshot.data ?? 0;
                                            return Text('$quantidadeDoacoes');
                                          }
                                        },
                                      ),
                                      const Text('Donations'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      FutureBuilder<int>(
                                        future: valorDoado,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Erro: ${snapshot.error}');
                                          } else {
                                            int totalDoado = snapshot.data ?? 0;
                                            return Text('$totalDoado');
                                          }
                                        },
                                      ),
                                      const Text('total donated'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Settings'),
                        const SizedBox(height: 10),
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 373,
                            height: 51,
                            color: const Color.fromRGBO(252, 252, 252, 30),
                            child: Center(
                              child: const Text(
                                'Change Email',
                                style: TextStyle(
                                  color: const Color.fromRGBO(0, 0, 0, 0.3),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 373,
                            height: 51,
                            color: const Color.fromRGBO(252, 252, 252, 30),
                            child: Center(
                              child: const Text(
                                'Change Password',
                                style: TextStyle(
                                  color: const Color.fromRGBO(0, 0, 0, 0.3),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
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
        radius: 86.5,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(
          'https://relife-api.vercel.app/imagens/${user.image}?timestamp=${DateTime.now()}', //truque para atualizar a imagem
        ),
      ),
    );
  }
}
