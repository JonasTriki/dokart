import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dokart/models/toilet.dart';

Future<List<Toilet>> fetchFirestoreToilets() async {
  final Firestore _store = Firestore.instance;
  final QuerySnapshot cities = await _store.collection("cities").getDocuments();
  final List<Toilet> results = [];
  await Future.forEach(cities.documents, (DocumentSnapshot city) async {
    final toilets = await city.reference.collection("toilets").getDocuments();
    await Future.forEach(toilets.documents, (DocumentSnapshot toilet) async {
      results.add(Toilet.fromJson(toilet.data));
    });
  });
  return results;
}
