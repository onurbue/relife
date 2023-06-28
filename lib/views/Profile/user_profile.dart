// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:relife/models/user.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/utils/helper.dart';
import 'package:relife/utils/urls.dart';
import 'package:relife/views/HomePage/homepage.dart';
import 'package:relife/views/Login/login_page.dart';
import 'package:relife/utils/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:relife/views/Profile/change_email.dart';
import 'package:relife/views/Profile/change_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/users.dart';
import '../../utils/shared.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<bool>? _loginCheck;
  Future<User?>? _user;
  late User _currentUser;
  late Future<int> valorDoado = Future<int>.value(0); // Inicializando com 0
  late Future<int> quantidadeDoacoes =
      Future<int>.value(0); // Inicializando com 0
  String? token;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });

    if (token != null) {
      _loginCheck = Users.checkUserLoggedIn();
      bool isLoggedIn = await _loginCheck!;
      if (isLoggedIn) {
        _currentUser = await Users.fetchCurrentUser();
        setState(() {
          valorDoado = Users.getUserTotalDonation(_currentUser.id);
          quantidadeDoacoes = Users.getUserDonationCount(_currentUser.id);
        });
        _user = Future<User>.value(_currentUser);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        _user = Future<User?>.value(null);
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      _user = Future<User?>.value(null);
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    setState(() {
      token = null;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void uploadImage(int userId) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imgurRequest = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.imgur.com/3/image'),
    );
    imgurRequest.headers['Authorization'] = "Client-ID 9aa5af389353021";
    imgurRequest.files.add(
      await http.MultipartFile.fromPath('image', image.path),
    );

    final imgurResponse = await imgurRequest.send();

    if (imgurResponse.statusCode == 200) {
      final imgurData = await imgurResponse.stream.toBytes();
      final imgurResult = json.decode(utf8.decode(imgurData));
      String imgurImageId = imgurResult['data']['id'];
      print('ID da imagem no imgur: $imgurImageId');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentToken = prefs.getString('token');
      String? oldToken = prefs.getString('oldToken');

      String newToken = await Users.refreshToken(currentToken!, imgurImageId);

      if (currentToken != newToken) {
        await SharedPreferencesHelper.saveToken(newToken);
        currentToken = newToken;
        token = newToken;
      }

      print('NOVA: $currentToken');
      print('VELHA: $oldToken');

      final Map<String, dynamic> decodedToken = JwtDecoder.decode(currentToken);
      final Map<String, dynamic> userMap = decodedToken['user'];

      int currentUserId = userMap['id_user'] as int;

      setState(() {
        _currentUser.image = imgurImageId;
        print(imgurImageId);
      });

      if (currentUserId == userId) {
        Users.updateImage(userId, imgurImageId);
      }
    } else {
      print(
          'Falha ao enviar a imagem para o Imgur. Código de status: ${imgurResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loginCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: customAppBar(false),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: customAppBar(false),
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
                  appBar: customAppBar(false),
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (userSnapshot.hasError) {
                return Scaffold(
                  appBar: customAppBar(false),
                  body: Center(
                    child: Text('Erro: ${userSnapshot.error}'),
                  ),
                );
              } else {
                User? user = userSnapshot.data;
                if (user != null) {
                  return Scaffold(
                    appBar: customAppBarLogout(_logout),
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
                        Text(
                          'Registered since ${formatDate(user.registerDate)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          user.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 50),
                        const Text(
                          'Statistics',
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                FutureBuilder<int>(
                                  future: quantidadeDoacoes,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Erro: ${snapshot.error}');
                                    } else {
                                      int quantidadeDoacoes =
                                          snapshot.data ?? 0;
                                      return Text(
                                        '$quantidadeDoacoes',
                                        style: const TextStyle(fontSize: 32),
                                      );
                                    }
                                  },
                                ),
                                const Text(
                                  'Donations',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                FutureBuilder<int>(
                                  future: valorDoado,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Erro: ${snapshot.error}');
                                    } else {
                                      int totalDoado = snapshot.data ?? 0;
                                      return Text(
                                        '$totalDoado €',
                                        style: const TextStyle(fontSize: 32),
                                      );
                                    }
                                  },
                                ),
                                const Text(
                                  'Total Donated',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 50),
                        const Text(
                          'Settings',
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeEmailPage(
                                  userId: user.id,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: 373,
                              height: 51,
                              color: const Color.fromRGBO(252, 252, 252, 30),
                              child: const Center(
                                child: Text(
                                  'Change Email',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.3),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                builder: (context) => ChangePasswordPage(
                                  userId: user.id,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: 373,
                              height: 51,
                              color: const Color.fromRGBO(252, 252, 252, 30),
                              child: const Center(
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.3),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Users.logout(context);
                            Users.deleteUser(user.id);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          },
                          child: const Text('Delete Account'),
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
    if (user.image != 'default.png') {
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
            '$imageUrl/${user.image}.jpg',
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: primaryColor,
            width: 2,
          ),
        ),
        child: const CircleAvatar(
          radius: 86.5,
          backgroundColor: Colors.grey,
          backgroundImage:
              NetworkImage('$baseAPIurl/imagens/users/default.png'),
        ),
      );
    }
  }
}
