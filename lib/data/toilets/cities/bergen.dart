import 'dart:async';

import 'package:dokart/data/toilets/cities/difi_city.dart';
import 'package:dokart/models/toilet.dart';

Future<List<Toilet>> fetchBergenToilets() async =>
    fetchToilets("/api/json/bergen/dokart");
