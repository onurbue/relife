import 'package:flutter/material.dart';
import 'package:relife/utils/constants.dart';
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

int _pageIndex = 0;

final List<Widget> _telas = [
  const HomePage(),
  const ProfilePage(),
];

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    print(_pageIndex);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _telas[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
            ),
            label: "Home Page",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    // if (index == 1) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const LoginPage(),
    //       ));
    // } else {
    //   setState(() {
    //     _indiceAtual = index;
    //   });
    // }
    setState(() {
      _pageIndex = index;
    });
  }
}
