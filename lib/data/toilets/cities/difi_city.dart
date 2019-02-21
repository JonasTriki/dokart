import 'dart:async';
import 'dart:convert';

import 'package:dokart/models/toilet.dart';
import 'package:http/http.dart' as http;

Future<List<Toilet>> fetchToilets(String endpoint) async {
  final res = await http.get("http://hotell.difi.no" + endpoint);
  if (res.statusCode == 200) {
    var jsonToilets = json.decode(res.body)['entries'];
    List<Toilet> toilets = [];
    for (var toilet in jsonToilets) {
      Toilet t = Toilet.fromJson(toilet);

      // Remove false-positives
      if (t.latitude == "" && t.longitude == "") continue;
      toilets.add(Toilet.fromJson(toilet));
    }
    return toilets;
  } else {
    throw Exception("Failed to load toilets");
  }
}
