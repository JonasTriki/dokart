import 'package:dokart/data/location/actions.dart';
import 'package:dokart/models/app_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      var hasPermission = await location.hasPermission();
      if (!hasPermission) {
        hasPermission = await location.requestPermission();
      }
      if (!hasPermission) {

        // TODO: Do something when no permission
        print("Location permission not granted.");
        return;
      }
      location.onLocationChanged().handleError((error) {
        print("Location-error: " + error);
      }).listen((LocationData data) {
        store.dispatch(LocationChanged(
          location: LatLng(data.latitude, data.longitude),
        ));
      });
    }
  };
}
