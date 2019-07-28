import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dokart/models/toilet.dart';

Future<List<Toilet>> fetchFirestoreToilets() async {
  final Firestore _store = Firestore.instance;
  final QuerySnapshot toilets =
      await _store.collection("toilets").getDocuments();
  final List<Toilet> results = toilets.documents.map(
    (snapshot) => Toilet.fromJson(snapshot.documentID, snapshot.data),
  ).toList(growable: false);
  return results;
}
