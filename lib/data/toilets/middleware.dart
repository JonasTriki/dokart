import 'package:dokart/data/toilets/actions.dart';
import 'package:dokart/data/toilets/cities/bergen.dart';
import 'package:dokart/data/toilets/cities/firestore_cities.dart';
import 'package:dokart/data/toilets/cities/oslo.dart';
import 'package:dokart/data/toilets/cities/stavanger.dart';
import 'package:dokart/models/app_state.dart';
import 'package:dokart/models/toilet.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createToiletsMiddleware() {
  return [
    TypedMiddleware<AppState, LoadToilets>(_createLoadToiletsMiddleware())
  ];
}

Middleware<AppState> _createLoadToiletsMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is LoadToilets) {
      try {
        print("Fetching Bergen toilets...");
        final List<Toilet> bergenToilets = await fetchBergenToilets();
        print("Fetched " + bergenToilets.length.toString() + " toilets!");

        print("Fetching Stavanger toilets...");
        final List<Toilet> stavangerToilets = await fetchStavangerToilets();
        print("Fetched " + stavangerToilets.length.toString() + " toilets!");

        print("Fetching Oslo toilets...");
        final List<Toilet> osloToilets = await fetchOsloToilets();
        print("Fetched " + osloToilets.length.toString() + " toilets!");

        print("Fetching toilets from Cloud Firestore...");
        final List<Toilet> firestoreToilets = await fetchFirestoreToilets();
        print("Fetched " + firestoreToilets.length.toString() + " toilets!");

        store.dispatch(LoadToiletsSuccessful(
            toilets: bergenToilets
              ..addAll(stavangerToilets)
              ..addAll(osloToilets)
              ..addAll(firestoreToilets)));
      } catch (error) {
        store.dispatch(LoadToiletsError(error));
      }
    }
  };
}