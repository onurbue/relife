import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Donation/widgets/header.dart';

class FinishedDonationPage extends StatelessWidget {
  final int amountDonated;
  const FinishedDonationPage({
    super.key,
    required this.amountDonated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
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
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(41),
            child: Text(
              'Thank you for the $amountDonated € that you have donated to Earthquakes.\n\nWe appreciate all the help.',
              style: CustomTextStyles.donation,
            ),
          ),
          const Row(),
        ],
      ),
    );
  }
}
