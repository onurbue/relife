import 'package:flutter/material.dart';
import 'package:relife/utils/helper.dart';

import '../../../utils/constants.dart';
import '../../../utils/urls.dart';

Widget normalDonationCard({
  required int userID,
  required String userName,
  required String userImage,
  required int donationAmount,
  String? donationMessage,
  required String donationDate,
}) {
  // print(userImage);
  // print('$imageUrl/$userImage');
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Card(
          margin: const EdgeInsets.only(left: 40.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              title: Text(
                userName,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(donationMessage ?? ''),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(25),
                      color: primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        '${donationAmount.toString()} €',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    donationDate,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: 17,
        left: -330,
        right: .0,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30.0,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 27,
            backgroundImage: userImage == 'default.png'
                ? const NetworkImage('$baseAPIurl/imagens/users/default.png')
                : NetworkImage('$imageUrl/$userImage.jpg'),
          ),
        ),
      ),
    ],
  );
}

Widget bigDonationCard({
  required int userID,
  required String userName,
  required String userImage,
  required int donationAmount,
  String? donationMessage,
  required String donationDate,
}) {
  return Stack(
    children: [
      Card(
        margin: const EdgeInsets.only(top: 20.0),
        child: SizedBox(
            height: 150.0,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 45.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (donationMessage != null)
                    Text(
                      donationMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                    ),
                  Text(
                    '${donationAmount.toString()} €',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    formatDate(donationDate),
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
            )),
      ),
      Positioned(
          top: .0,
          left: .0,
          right: .0,
          child: Center(
            child: userImage == 'default.png'
                ? const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        NetworkImage('$baseAPIurl/imagens/users/default.png'),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      '$imageUrl/$userImage.jpg',
                    ),
                  ),
          )),
    ],
  );
}
