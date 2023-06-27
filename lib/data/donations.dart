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

  Future<void> createDonation(
      {required int userId,
      required int missionId,
      required int donationAmount,
      String? donationMessage}) async {
    final url = Uri.parse('https://relife-api.vercel.app/donation');

    // Dados da doação a serem enviados
    final data = {
      'id_user': userId,
      'id_mission': missionId,
      'amount': donationAmount,
      'donation_message': donationMessage,
    };

    final token = 'SEU_TOKEN_JWT'; // Substitua pelo seu token JWT válido

    try {
      final response = await http.post(
        url,
        // headers: {'Content-Type': 'application/json', 'token': token},
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Doação criada com sucesso!');
      } else {
        print('Erro ao criar doação: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Erro na solicitação: $error');
    }
  }
}
