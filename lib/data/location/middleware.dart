import 'package:dokart/data/location/actions.dart';
import 'package:dokart/models/app_state.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:redux/redux.dart';

final Location location = Location();

List<Middleware<AppState>> createLocationMiddleware() {
  return [
    TypedMiddleware<AppState, GetLocation>(_createGetLocationMiddleware())
  ];
}

Middleware<AppState> _createGetLocationMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is GetLocation) {
      location.onLocationChanged().listen((LocationData data) {
        store.dispatch(LocationChanged(
          location: LatLng(data.latitude, data.longitude),
        ));
      });
    }
  };
}
