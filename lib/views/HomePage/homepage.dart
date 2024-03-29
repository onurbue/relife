import 'package:flutter/material.dart';
import 'package:relife/data/missions.dart';
import 'package:relife/models/mission.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/HomePage/widgets/featured_card.dart';
import 'package:relife/views/HomePage/widgets/normal_card.dart';
import 'package:relife/views/Mission/mission.dart';
import 'package:relife/utils/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // variables
  late Future<List<Mission>> _missions;

  @override
  void initState() {
    super.initState();
    _missions = Missions.fetchMissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Missões em Destaque
              buildFeaturedMissions(),

              // Missões Normais
              buildNormalMissions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeaturedMissions() {
    return FutureBuilder<List<Mission>>(
      future: _missions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          final filteredMissions = snapshot.data!
              .where((mission) => mission.isLimited == 1 && mission.active)
              .toList();
          if (filteredMissions.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Featured Causes',
                  style: CustomTextStyles.descriptions,
                ),
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    itemCount: filteredMissions.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final Mission mission = filteredMissions[index];
                      //print(mission.totalAmount);
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MissionPage(
                                missionId: mission.id,
                                title: mission.title,
                                description: mission.description,
                                totalAmount: mission.totalAmount,
                                limitAmount: mission.limitAmout,
                                isLimited: mission.isLimited,
                                image: mission.image,
                              ),
                            ),
                          );
                        },
                        child: FeaturedCausesCard(
                          title: mission.title,
                          amountDonated: mission.totalAmount,
                          totalAmount: mission.limitAmout,
                          image: mission.image,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildNormalMissions() {
    return FutureBuilder<List<Mission>>(
      future: _missions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          final filteredMissions = snapshot.data!
              .where((mission) => mission.isLimited == 0)
              .toList();
          if (filteredMissions.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Normal Causes', style: CustomTextStyles.descriptions),
                SizedBox(
                  height: 336,
                  child: ListView.builder(
                    itemCount: filteredMissions.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final Mission mission = filteredMissions[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MissionPage(
                                missionId: mission.id,
                                title: mission.title,
                                description: mission.description,
                                totalAmount: mission.totalAmount,
                                limitAmount: mission.limitAmout,
                                isLimited: mission.isLimited,
                                image: mission.image,
                              ),
                            ),
                          );
                        },
                        child: NormalCausesCard(
                          title: mission.title,
                          description: mission.description,
                          image: mission.image,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
}
