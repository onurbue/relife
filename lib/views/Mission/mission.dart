import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:relife/data/donations.dart';
import 'package:relife/models/donation.dart';
import 'package:relife/utils/helper.dart';
import 'package:relife/utils/urls.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Donation/donation.dart';
import 'package:relife/utils/appbar.dart';
import 'package:relife/views/Mission/widgets/donations_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../HomePage/widgets/featured_card.dart';
import '../Login/login_page.dart';

class MissionPage extends StatefulWidget {
  final int missionId;
  final String title;
  final String description;
  final int totalAmount;
  final int? limitAmount;
  final int isLimited;
  final String image;

  const MissionPage({
    super.key,
    required this.missionId,
    required this.title,
    required this.description,
    required this.totalAmount,
    this.limitAmount,
    required this.isLimited,
    required this.image,
  });

  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  int _selectedIndex = 0;

  String? token;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(true),
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
                  image: widget.image,
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '$baseAPIurl/imagens/missions/${widget.image}',
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
              CustomSlidingSegmentedControl<int>(
                fixedWidth: 170,
                height: 48,
                initialValue: 0,
                children: {
                  0: Text(
                    'Latest Donations',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  1: Text(
                    'Top 10',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                },
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                thumbDecoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInToLinear,
                onValueChanged: (v) {
                  setState(() {
                    _selectedIndex = v;
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
            onPressed: token != null
                ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DonationPage(
                                missionID: widget.missionId,
                                missionName: widget.title,
                              )),
                    );
                  }
                : () {
                    print(token);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
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

          return ListView.builder(
            shrinkWrap: true,
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];

              print('HERE ${donation.userName}');
              return normalDonationCard(
                  userID: donation.userId,
                  donationAmount: donation.amount,
                  donationDate: formatDate(donation.donationDate),
                  donationMessage: donation.donationMessage,
                  userName: donation.userName,
                  userImage: donation.userImage);
            },
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

              String donationDateStr = donation.donationDate;
              DateTime donationDate = DateTime.parse(donationDateStr);
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(donationDate);

              if (index == 0) {
                // Primeiro card
                return bigDonationCard(
                    userID: donation.userId,
                    donationAmount: donation.amount,
                    donationDate: formattedDate,
                    donationMessage: donation.donationMessage,
                    userName: donation.userName,
                    userImage: donation.userImage);
              } else {
                // os outros
                return normalDonationCard(
                    userID: donation.userId,
                    donationAmount: donation.amount,
                    donationDate: formattedDate,
                    donationMessage: donation.donationMessage,
                    userName: donation.userName,
                    userImage: donation.userImage);
              }
            },
          );
        } else {
          return const Text('Nenhuma doação encontrada.');
        }
      },
    );
  }
}
