import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/donation.dart';

class Donations {
  //constants
  static const String url = 'https://relife-api.vercel.app/donations';

  static Future<List<Donation>> getDonations(int id) async {
    // variables
    Iterable iterable;
    List<Donation> donations;

    // ask data
    final response = await http.get(Uri.parse('$url?missionId=$id'));

    // deserialize process for a list
    iterable = json.decode(response.body);

    // deserialize the body
    donations = List<Donation>.from(iterable.map((d) => Donation.fromJson(d)));

    // returns deserialized list of objects
    return donations;
  }

  static Future<List<Donation>> getTop10(int id) async {
    // variables
    Iterable iterable;
    List<Donation> donations;

    // ask data
    final response = await http.get(Uri.parse('$url?missionId=$id&top10=true'));

    // deserialize process for a list
    iterable = json.decode(response.body);

    // deserialize the body
    donations = List<Donation>.from(iterable.map((d) => Donation.fromJson(d)));

    // returns deserialized list of objects
    return donations;
  }
}
