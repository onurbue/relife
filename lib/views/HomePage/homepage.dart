import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relife/data/missions.dart';
import 'package:relife/models/mission.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/HomePage/widgets/featured_card.dart';
import 'package:relife/views/HomePage/widgets/normal_card.dart';
import 'package:relife/views/Mission/mission.dart';
import 'package:relife/utils/appbar.dart';

import '../../utils/bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //variables
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
      appBar: customAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Featured Causes', style: CustomTextStyles.descriptions),

              // Missões em Destaque
//              buildFeaturedMissions(),

              const SizedBox(height: 20),
              Text('Causes', style: CustomTextStyles.descriptions),

              // Missões Normais
              buildNormalMissions(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }

  //Trocar isto por o carousell slider, para ficar tipo a imagem em slide
  // destacada
  Widget buildFeaturedMissions() {
    return SizedBox(
      height: 220,
      child: FutureBuilder<List<Mission>>(
        future: _missions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final Mission mission = snapshot.data![index];

                if (mission.isLimited == 1) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MissionPage(
                            missionId: mission.id,
                            title: mission.title,
                            description: mission.description,
                          ),
                        ),
                      );
                    },
                    child: FeaturedCausesCard(
                      title: mission.title,
                      amountDonated: 10,
                      totalAmount: mission.totalAmount,
                    ),
                  );
                } else {
                  // Caso não seja limitado, você pode definir um widget alternativo ou retornar um widget vazio
                  return Container();
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildNormalMissions() {
    return SizedBox(
      height: 400,
      child: FutureBuilder<List<Mission>>(
        future: _missions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MissionPage(
                          missionId: snapshot.data![index].id,
                          title: snapshot.data![index].title,
                          description: snapshot.data![index].description,
                        ),
                      ),
                    );
                  },
                  child: NormalCausesCard(
                    title: snapshot.data![index].title,
                    description: snapshot.data![index].description,
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
