import 'package:flutter/material.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/views/Donation/widgets/header.dart';

class FinishedDonationPage extends StatelessWidget {
  const FinishedDonationPage({super.key});

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
                  height: 314,
                  width: 333,
                  child: Image.asset(
                    'assets/images/logo/Logo.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          const Row(),
        ],
      ),
    );
  }
}
