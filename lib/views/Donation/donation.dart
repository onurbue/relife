import 'package:flutter/material.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Donation/widgets/header.dart';

class DonationPage extends StatefulWidget {
  DonationPage({Key? key}) : super(key: key);

  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  int _selected = 0;

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
            child: Column(
              children: [
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
                          customDonationButton(5, () {
                            setState(() {
                              _amountController.text = '5';
                              _selected = 1;
                            });
                          }, _selected == 1),
                          const SizedBox(width: 10),
                          customDonationButton(10, () {
                            setState(() {
                              _amountController.text = '10';
                              _selected = 2;
                            });
                          }, _selected == 2),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customDonationButton(20, () {
                            setState(() {
                              _amountController.text = '20';
                              _selected = 3;
                            });
                          }, _selected == 3),
                          const SizedBox(width: 10),
                          customDonationButton(50, () {
                            setState(() {
                              _amountController.text = '50';
                              _selected = 4;
                            });
                          }, _selected == 4),
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
              ],
            ),
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

Widget customDonationButton(
    int amount, VoidCallback onPressed, bool isSelected) {
  return SizedBox(
    width: 130,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? const Color.fromRGBO(4, 140, 141, 100) : primaryColor,
        primary: isSelected ? Colors.white : null,
      ),
      onPressed: onPressed,
      child: Text(
        amount.toString(),
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

String customAppText() {
  return 'You are almost Finishing';
}
