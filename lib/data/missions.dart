import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/mission.dart';

class Missions {
  //constants
  static const String url = 'http://localhost:3000/mission';

  static Future<List<Mission>> fetchMissions() async {
    //variables
    Iterable iterable;
    List<Mission> missions;

    // ask data
    final response = await http.get(Uri.parse(url));

    //deserialize process for a list
    iterable = json.decode(response.body);

    //deseriale the body
    missions = List<Mission>.from(iterable.map((m) => Mission.fromJson(m)));

    print(missions);
    // returns deserialized list of objects
    return missions;
  }
}
