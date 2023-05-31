import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relife/data/donations.dart';
import 'package:relife/models/donation.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Donation/donation.dart';
import 'package:relife/utils/appbar.dart';

import '../HomePage/widgets/featured_card.dart';

// Ver aqui sobre o sliding
// https://api.flutter.dev/flutter/cupertino/CupertinoSlidingSegmentedControl-class.html

class MissionPage extends StatefulWidget {
  int missionId;
  String title;
  String description;

  MissionPage({
    required this.missionId,
    required this.title,
    required this.description,
  });

  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  int _selectedIndex = 0;
  final Map<int, Widget> _segments = {
    0: const Text('Latest Donations'),
    1: const Text('Top 10'),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://media.wired.com/photos/59272787cefba457b079c416/master/w_2560%2Cc_limit/GettyImages-512764656.jpg',
                        width: 400,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        height: 10,
                        width: 400,
                        child: LinearProgressIndicator(
                          value: 1,
                          backgroundColor: Colors.grey,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('2 €'),
                            const Text(' / '),
                            Text(
                              '2 €',
                              style: const TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
                            ),
                          ],
                        ),
                        Text('(amountDonated, totalAmount).toString()} %'),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(widget.title, style: CustomTextStyles.title),
              const SizedBox(height: 20),
              Text(
                widget.description,
                style: CustomTextStyles.button,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text('Donations', style: CustomTextStyles.title),
              const SizedBox(height: 20),
              CupertinoSlidingSegmentedControl(
                groupValue: _selectedIndex,
                children: _segments,
                onValueChanged: (value) {
                  setState(() {
                    _selectedIndex = value!;
                  });
                },
              ),
              _selectedIndex == 0
                  ? _buildLatestDonations()
                  : _buildTop10Donations(),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: 300,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DonationPage()),
              );
            },
            label: const Text('Donate'),
            backgroundColor: primaryColor,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildLatestDonations() {
    return FutureBuilder<List<Donation>>(
      future: Donations.getDonations(widget.missionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erro ao buscar as doações: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Donation> donations = snapshot.data!;
          return Column(
            children: donations.map((donation) {
              return Card(
                child: ListTile(
                  title: Text(donation.donationMessage),
                  subtitle: Text(donation.donationMessage),
                  trailing: Text('\$${donation.amount.toStringAsFixed(2)}'),
                ),
              );
            }).toList(),
          );
        } else {
          return const Text('Nenhuma doação encontrada.');
        }
      },
    );
  }

  Widget _buildTop10Donations() {
    return FutureBuilder<List<Donation>>(
      future: Donations.getTop10(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erro ao buscar as doações: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Donation> donations = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              //Primeiro card, ou seja o primeiro index
              if (index == 0) {
                // Primeiro card
                return Container(
                  color: Colors.red,
                  height: 125,
                  child: ListTile(
                    title: Text(
                      donation.amount.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      donation.donationMessage,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      '${donation.amount} €',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                // os outros
                return Card(
                  child: ListTile(
                    title: Text(
                      donation.donationMessage,
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      donation.donationMessage,
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      '${donation.amount} €',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return Text('Nenhuma doação encontrada.');
        }
      },
    );
  }
}