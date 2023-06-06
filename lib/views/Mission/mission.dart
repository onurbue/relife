import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  int totalAmount;
  int? limitAmount;
  int isLimited;

  MissionPage({
    required this.missionId,
    required this.title,
    required this.description,
    required this.totalAmount,
    this.limitAmount,
    required this.isLimited,
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
              if (widget.isLimited == 1) ...[
                FeaturedCausesCard(
                  title: '',
                  totalAmount: widget.limitAmount!,
                  amountDonated: widget.totalAmount,
                ),
              ] else ...[
                Column(
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
                    const Text(
                      'Total Donated',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      '${widget.totalAmount.toString()} €',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
              Text(widget.title,
                  textAlign: TextAlign.center, style: CustomTextStyles.title),
              const SizedBox(height: 20),
              Text(
                widget.description,
                style: CustomTextStyles.button,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100),
              Text('DONATIONS', style: CustomTextStyles.title),
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
              const SizedBox(height: 100),
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
                MaterialPageRoute(builder: (context) => DonationPage()),
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
              String donationDateStr = donation
                  .donationDate; // String no formato "2023-05-31T00:00:00.000Z"
              DateTime donationDate = DateTime.parse(
                  donationDateStr); // Converter a string em DateTime
              String formattedDate = DateFormat('yyyy-MM-dd')
                  .format(donationDate); // Formatar a data

              print(formattedDate);
              return Card(
                child: ListTile(
                  title: Text(
                    'Nome do user(id user = ${donation.userId})',
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(donation.donationMessage),
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
                            '${donation.amount.toString()} €',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(formattedDate,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                          )),
                    ],
                  ),
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
      future: Donations.getTop10(widget.missionId),
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
