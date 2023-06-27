import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

Widget normalDonationCard({
  required int userID,
  required int donationAmount,
  String? donationMessage,
  required String donationDate,
}) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        
        child: Card(
          margin: const EdgeInsets.only(left: 30.0),
          child: ListTile(
            title: Text(
              'Nome do usuário (ID do usuário = $userID)',
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
                    borderRadius: BorderRadius.circular(45),
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
      Positioned(
        top: 5,
        left: -330,
        right: .0,
        child: Center(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30.0,
            child: Image.asset('assets/images/users_profiles/default.png'),
          ),
        ),
      ),
    ],
  );
}

Widget bigDonationCard({
  required int userID,
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
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    userID.toString(),
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                    ),
                  ),
                  if (donationMessage != null)
                  Center(
                        child: Text(
                          donationMessage,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  Text(
                    donationAmount.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    donationDate.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )),
      ),
      Positioned(
        top: .0,
        left: .0,
        right: .0,
        child: Center(
          child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30.0,
              child: Image.asset('assets/images/users_profiles/default.png')),
        ),
      )
    ],
  );
}
