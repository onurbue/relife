import 'package:flutter/material.dart';
import 'package:relife/views/Profile/user_profile.dart';
import '../data/users.dart';
import '../models/user.dart';
import 'HomePage/homepage.dart';
import 'Login/login_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

int _indiceAtual = 0; // Variável para controlar o índice das telas
late Future<bool> _loginCheck;
late Future<User?> _user;
late User _currentUser;

final List<Widget> _telas = [
  HomePage(),
  ProfilePage(),
];

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {
    print(_indiceAtual);
    return Scaffold(
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: "Home Page"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    } else {
      setState(() {
        _indiceAtual = index;
      });
    }
  }
}
