import 'package:dokart/data/toilets/actions.dart';
import 'package:dokart/data/toilets/firestore/index.dart';
import 'package:dokart/models/app_state.dart';
import 'package:dokart/models/toilet.dart';
import 'package:dokart/utils/filter.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createToiletsMiddleware() {
  return [
    TypedMiddleware<AppState, LoadToilets>(_createLoadToiletsMiddleware()),
    TypedMiddleware<AppState, ApplyToiletFilter>(
        _createApplyToiletFilterMiddleware()),
  ];
}

Middleware<AppState> _createLoadToiletsMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is LoadToilets) {
      try {
        print("Fetching toilets from Cloud Firestore...");
        final List<Toilet> toilets = await fetchFirestoreToilets();
        print("Fetched " + toilets.length.toString() + " toilets!");

        store.dispatch(LoadToiletsSuccessful(toilets: toilets));
      } catch (error) {
        store.dispatch(LoadToiletsError(error));
      }
    }
  };
}

Middleware<AppState> _createApplyToiletFilterMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is ApplyToiletFilter) {
      Filter f = store.state.toiletFilter;
      switch (action.filter) {
        case "free":
          store.dispatch(SetToiletFilter(f.setFree(action.on)));
          break;
        case "open":
          store.dispatch(SetToiletFilter(f.setOpen(action.on)));
          break;
        case "handicap":
          store.dispatch(SetToiletFilter(f.setAccessible(action.on)));
          break;
        case "stellerom":
          store.dispatch(SetToiletFilter(f.setBabycare(action.on)));
          break;
        case "pissoirOnly":
          store.dispatch(SetToiletFilter(f.setPissoir(action.on)));
          break;
      }
    }
  };
}
