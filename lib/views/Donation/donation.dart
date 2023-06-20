import 'package:flutter/material.dart';
import 'package:relife/utils/appbar.dart';
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
          const CustomBarHeader(
              percentage: 0.5, title: 'You are almost finishing'),
          const SizedBox(height: 120),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(41)),
            color: const Color.fromRGBO(252, 252, 252, 100),
            child: Column(children: [
              Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Donation')],
                    ),
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
              SizedBox(
                width: 238,
                height: 48,
                child: ElevatedButton(
                  child: const Text('Donate'),
                  onPressed: () {
                    print(_amountController.text);
                  },
                ),
              ),
            ]),
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
        onPressed: () {
          print(amount);
        },
        child: Text(amount.toString())),
  );
}
