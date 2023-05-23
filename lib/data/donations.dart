import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/donation.dart';

class Donations {
  //constants
  static const String url = 'http://localhost:3000/donations';
  static const String url10 = 'http://localhost:3000/donations10';

  static Future<List<Donation>> getDonations(int id) async {
    // variables
    Iterable iterable;
    List<Donation> donations;

    // ask data
    final response = await http.get(Uri.parse('$url?id=$id'));

    // deserialize process for a list
    iterable = json.decode(response.body);

    // deserialize the body
    donations = List<Donation>.from(iterable.map((d) => Donation.fromJson(d)));

    // returns deserialized list of objects
    return donations;
  }

  static Future<List<Donation>> getTop10() async {
    //variables
    Iterable iterable;
    List<Donation> donations;

    // ask data
    final response = await http.get(Uri.parse(url10));

    //deserialize process for a list
    iterable = json.decode(response.body);

    //deseriale the body
    donations = List<Donation>.from(iterable.map((d) => Donation.fromJson(d)));

    // returns deserialized list of objects
    return donations;
  }
}
