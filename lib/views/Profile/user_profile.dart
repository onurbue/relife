import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relife/models/user.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/HomePage/homepage.dart';
import 'package:relife/views/Login/login_page.dart';
import 'package:relife/utils/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:relife/views/Profile/change_email.dart';
import 'package:relife/views/Profile/change_password.dart';

import '../../data/users.dart';

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
      return null;
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
                              top: 140,
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
                        const SizedBox(height: 15),
                        const Text('Registered since'),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${user.name}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 32,
                          ),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16), // Added padding
                            child: Column(
                              children: [
                                const Text(
                                  'Statistics',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
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
                                              return const CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Erro: ${snapshot.error}');
                                            } else {
                                              int quantidadeDoacoes =
                                                  snapshot.data ?? 0;
                                              return Text(
                                                '$quantidadeDoacoes',
                                                style: const TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        const Text(
                                          'Donations',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
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
                                              return Text(
                                                  'Erro: ${snapshot.error}');
                                            } else {
                                              int totalDoado =
                                                  snapshot.data ?? 0;
                                              return Text(
                                                '$totalDoado €',
                                                style: const TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        const Text(
                                          'Total Donated',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 32),
                          child: const Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                              child: const Padding(
                                padding: EdgeInsets.only(left: 16, top: 15),
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
                              child: const Padding(
                                padding: EdgeInsets.only(left: 16, top: 15),
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
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: primaryColor,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 81.5,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(
          'https://relife-api.vercel.app/imagens/${user.image}?timestamp=${DateTime.now()}', //truque para atualizar a imagem
        ),
      ),
    );
  }
}
