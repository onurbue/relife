import 'package:flutter/material.dart';

import '../data/users.dart';

AppBar customAppBar(bool backArrow) {
  return AppBar(
    automaticallyImplyLeading: backArrow,
    backgroundColor: Colors.white,
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Re',
            style: TextStyle(
              color: Color.fromRGBO(94, 225, 215, 1),
              fontFamily: 'Arial',
              fontSize: 36,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        RichText(
          text: const TextSpan(
            text: 'Life',
            style: TextStyle(
              color: Color.fromRGBO(6, 188, 193, 1),
              fontFamily: 'Arial',
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

AppBar customAppBarLogout(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Re',
            style: TextStyle(
              color: Color.fromRGBO(94, 225, 215, 1),
              fontFamily: 'Arial',
              fontSize: 36,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        RichText(
          text: const TextSpan(
            text: 'Life',
            style: TextStyle(
              color: Color.fromRGBO(6, 188, 193, 1),
              fontFamily: 'Arial',
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    actions: [
      GestureDetector(
          onTap: () {
            Users.logout(context);
          },
          child: Icon(Icons.logout)),
      SizedBox(width: 20)
    ],
  );
}
