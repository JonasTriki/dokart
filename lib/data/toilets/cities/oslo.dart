import 'dart:async';
import 'dart:convert';

import 'package:dokart/models/toilet.dart';
import 'package:http/http.dart' as http;

Future<List<Toilet>> fetchOsloToilets() async {
  final res = await http.get(
      "https://geodata.bymoslo.no/arcgis/rest/services/geodata/Temadata/MapServer/4/query?where=1=1&inSR=25832&spatialRel=esriSpatialRelIntersects&outFields=*&returnGeometry=true&outSR=4326&f=pjson");
  if (res.statusCode == 200) {
    var jsonToilets = json.decode(res.body)['features'];
    List<Toilet> toilets = [];
    for (var toilet in jsonToilets) {
      print(toilet);
      toilets.add(Toilet.fromBymJson(toilet));
    }
    return toilets;
  } else {
    throw Exception("Failed to load toilets");
  }
}
