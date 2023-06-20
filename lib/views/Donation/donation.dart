import 'package:flutter/material.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Donation/widgets/header.dart';

class DonationPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 30),
          CustomBarHeader(percentage: 0.5, title: customAppText()),
          const SizedBox(height: 120),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(41)),
            color: const Color.fromRGBO(252, 252, 252, 30),
            child: Column(children: [
              Container(
                margin: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Donation',
                          style: CustomTextStyles.title,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customDonationButton(5),
                        const SizedBox(width: 10),
                        customDonationButton(10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customDonationButton(20),
                        const SizedBox(width: 10),
                        customDonationButton(50),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Custom Amount',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please, insert an amount';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ]),
          ),
          const SizedBox(height: 100),
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
              child: const Text('Donate'),
              onPressed: () {
                print(_amountController.text);
              },
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
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
        ),
        onPressed: () {
          print(amount);
        },
        child: Text(amount.toString())),
  );
  //   return SizedBox(
  //     width: 130,
  //     child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: const Color.fromRGBO(4, 140, 141, 100),
  //         ),
  //         onPressed: () {
  //           print(amount);
  //         },
  //         child: Text(amount.toString())),
  //   );
}

String customAppText() {
  return 'You are almost Finishing';
}
