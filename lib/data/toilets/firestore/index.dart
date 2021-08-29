import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dokart/models/toilet.dart';

Future<List<Toilet>> fetchFirestoreToilets() async {
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final QuerySnapshot toilets = await _store.collection("toilets").get();
  final List<Toilet> results = toilets.docs
      .map(
        (snapshot) => Toilet.fromJson(snapshot.id, snapshot.data()),
      )
      .toList(growable: false);
  return results;
}
