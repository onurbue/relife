import 'package:flutter/material.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/views/Donation/widgets/header.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const CustomBarHeader(
              percentage: 0.5, title: 'You are almost finishing'),
          const SizedBox(height: 120),
          Container(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Row(children: [Text('Donation')]),
                const SizedBox(height: 25),
                Row(
                  children: [
                    customDonationButton(5),
                    const SizedBox(width: 10),
                    customDonationButton(10),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    customDonationButton(20),
                    const SizedBox(width: 10),
                    customDonationButton(50),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget customDonationButton(int amount) {
  return SizedBox(
    width: 130,
    child: ElevatedButton(onPressed: () {}, child: Text(amount.toString())),
  );
}
