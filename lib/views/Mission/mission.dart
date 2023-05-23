import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relife/data/donations.dart';
import 'package:relife/models/donation.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Donation/donation.dart';
import 'package:relife/utils/appbar.dart';

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
              const SizedBox(
                height: 200,
                width: 366,
                child: Placeholder(),
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
                  title: Text(donation.name),
                  subtitle: Text(donation.description),
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
                      donation.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      donation.description,
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
                      donation.name,
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      donation.description,
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
