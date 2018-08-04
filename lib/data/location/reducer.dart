import 'package:dokart/data/location/actions.dart';
import 'package:dokart/models/app_state.dart';
import 'package:dokart/models/toilet.dart';
import 'package:latlong/latlong.dart';
import 'package:redux/redux.dart';

final locationReducer = combineReducers<AppState>(
    [TypedReducer<AppState, LocationChanged>(_locationChanged)]);

final Distance distance = Distance();

AppState _locationChanged(AppState state, LocationChanged action) {
  // New location, calculate new distances for toilets
  final newToilets = state.toilets.map((toilet) {
    toilet.distance = distance(action.location, toilet.getLatLng);
    return toilet;
  }).toList();
  newToilets.sort((Toilet a, Toilet b) => a.distance.compareTo(b.distance));
  return state.copyWith(toilets: newToilets, location: action.location);
}
