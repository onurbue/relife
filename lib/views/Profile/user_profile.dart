import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:relife/models/user.dart';
import 'package:relife/utils/constants.dart';
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
  late Future<bool> _loginCheck;
  late Future<User?> _user;
  late User _currentUser;
  late Future<int> valorDoado;
  late Future<int> quantidadeDoacoes;
  late String token;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;

    print('isto $token');
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
        return null;
      }
    });
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
      print('ID da imagem no Imgur: $imgurImageId');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentToken = prefs.getString('token');
      String? oldToken = prefs.getString('oldToken');

      // Solicite um novo token com os novos dados do usuário, incluindo a imagem
      String newToken = await Users.refreshToken(currentToken!, imgurImageId);

      if (currentToken != newToken) {
        await SharedPreferencesHelper.saveToken(
            newToken); // Update the token in SharedPreferences
        currentToken = newToken; // Update the currentToken with the new token
        token = newToken; // Update the variable `token` with the new value
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
        Users.updateImage(userId,
            imgurImageId); // Pass the new token to the updateImage method
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
                    child: Text('Erro: ${userSnapshot.error}'),
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
                        Text('Olá, ${user.name}'),
                        const SizedBox(height: 50),
                        const Text('Statistics'),
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
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Erro: ${snapshot.error}');
                                    } else {
                                      int totalDoado = snapshot.data ?? 0;
                                      return Text('$totalDoado');
                                    }
                                  },
                                ),
                                const Text('total donated'),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 50),
                        const Text('Settings'),
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
            'https://i.imgur.com/${user.image}.jpg',
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
