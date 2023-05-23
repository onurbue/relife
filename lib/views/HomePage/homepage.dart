import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relife/data/missions.dart';
import 'package:relife/models/mission.dart';
import 'package:relife/utils/constants.dart';
import 'package:relife/views/Mission/mission.dart';
import 'package:relife/utils/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              Text(
                'Featured Causes',
                style: CustomTextStyles.descriptions,
              ),

              // Missões em Destaque
              buildMissoesDestaque(),

              const SizedBox(height: 20),
              Text('Causes', style: CustomTextStyles.descriptions),

              // Missões Normais
              buildMissoesNormais(),
            ],
          ),
        ),
      ),
    );
  }

  //Trocar isto por o carousell slider, para ficar tipo a imagem em slide
  // destacada
  Widget buildMissoesDestaque() {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<Mission>>(
        future: _missions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          snapshot.data![index].title,
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data![index].description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          snapshot.data![index].totalAmount.toString(),
                          textAlign: TextAlign.justify,
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          snapshot.data![index].isLimited == 1
                              ? 'Limitada'
                              : 'Normal',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
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

  Widget buildMissoesNormais() {
    return SizedBox(
      height: 350,
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
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const SizedBox(
                      width: 200,
                      height: 350,
                      child: Placeholder(),
                    ),
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
