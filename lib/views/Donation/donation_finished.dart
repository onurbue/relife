import 'package:flutter/material.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Donation/widgets/header.dart';
import 'package:relife/views/start.dart';

class FinishedDonationPage extends StatelessWidget {
  final int amountDonated;
  final String missionName;
  const FinishedDonationPage({
    super.key,
    required this.amountDonated,
    required this.missionName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const CustomBarHeader(percentage: 1, title: 'Done !'),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                SizedBox(
                  child: Image.asset(
                    'assets/images/logo/Logo.png',
                    width: 314,
                    height: 333,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(41),
            child: Text(
              'Thank you for the $amountDonated € that you have donated to $missionName.\n\nWe appreciate all the help.',
              style: CustomTextStyles.donation,
            ),
          ),
          SizedBox(
            width: 238,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Continue'),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InitialPage(),
                    ));
              },
            ),
          ),
          const Row(),
        ],
      ),
    );
  }
}
