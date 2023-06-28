import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:relife/views/start.dart';

class Mission {
  int id;
  String name;
  String description;
  int amount;
  int limitAmount;
  int isLimited;
  String image;

  Mission({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.limitAmount,
    required this.isLimited,
    required this.image,
  });
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionCOntroller = TextEditingController();

  final limitAmountCOntroller = TextEditingController();
  final imgurID = TextEditingController();
  final List<Mission> missions = [];

  @override
  void initState() {
    super.initState();
    fetchMissions(); // Chama o método para carregar as missões ao inicializar o estado
  }

  Future<void> fetchMissions() async {
    final url = Uri.parse(
        'https://relife-api.vercel.app/mission'); // Coloque o endereço correto da sua API
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> missionData = json.decode(response.body);
      print(missionData);
      final List<Mission> loadedMissions = missionData.map((data) {
        return Mission(
          id: data['id_mission'],
          name: data['title'],
          description: data['description'],
          amount: data['total_amount'],
          limitAmount: data['limit_amount'],
          isLimited: data['is_limited'],
          image: data['image'],
        );
      }).toList();

      // Filtra apenas as missões que são limitadas
      final limitedMissions =
          loadedMissions.where((mission) => mission.isLimited == 1).toList();

      setState(() {
        missions.addAll(limitedMissions);
      });
    } else {
      throw Exception('Failed to fetch missions');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(missions);
    return Scaffold(
      appBar: AppBar(title: const Text('Mission Dashboard')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Tiitle'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, insert title';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: TextFormField(
                        controller: limitAmountCOntroller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(labelText: 'Amount'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, insert an amout';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: descriptionCOntroller,
                  decoration: const InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please, insert a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: imgurID,
                  decoration: const InputDecoration(labelText: 'Imgur ID'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please, insert the imgur id';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final name = titleController.text;
                      final desc = descriptionCOntroller.text;
                      final pw = limitAmountCOntroller.text;
                      final image = imgurID.text;

                      final newMission = Mission(
                        name: name,
                        description: desc,
                        amount: 0,
                        isLimited: 1,
                        id: missions.length + 1,
                        limitAmount: int.parse(pw),
                        image: image,
                      );

                      // Envia os dados da nova missão para a API
                      final response = await http.post(
                        Uri.parse('https://relife-api.vercel.app/mission'),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode({
                          'title': newMission.name,
                          'description': newMission.description,
                          'total_amount': 0,
                          'is_limited': 1,
                          'limit_amount': newMission.limitAmount,
                          'image': newMission.image,
                        }),
                      );

                      if (response.statusCode == 200) {
                        // A missão foi adicionada com sucesso
                        setState(() {
                          missions.add(newMission);
                        });

                        _formKey.currentState!.reset();
                      } else {
                        // Houve um erro ao adicionar a missão
                        // Exiba uma mensagem de erro ou tome uma ação apropriada
                      }
                    }
                  },
                  child: const Text('Add Mission'),
                ),
              ]),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: missions.length,
              itemBuilder: (context, index) {
                final mission = missions[index];

                return ListTile(
                  title: Text(mission.name),
                  subtitle: Text(mission.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirmed = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Mission'),
                                content: const Text(
                                    'Are you sure you want to delete this mission?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false); // Cancelar a exclusão
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // Confirmar a exclusão
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmed == true) {
                            final missionId = mission
                                .id; // Obtenha o ID da missão a ser excluída

                            // Envia a requisição DELETE para a API
                            final response = await http.delete(
                              Uri.parse(
                                  'https://relife-api.vercel.app/mission?id=$missionId'),
                              headers: {'Content-Type': 'application/json'},
                            );

                            if (response.statusCode == 200) {
                              // A missão foi excluída com sucesso
                              setState(() {
                                missions.remove(mission);
                              });
                            } else {
                              // Houve um erro ao excluir a missão
                              // Exiba uma mensagem de erro ou tome uma ação apropriada
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InitialPage()));
              },
              child: const Text('w'))
        ],
      ),
    );
  }
}
