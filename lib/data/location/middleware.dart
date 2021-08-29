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
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          // TODO: Do something when no service.
          print("Location service not enabled.");
          return;
        }
      }

      var permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          // TODO: Do something when no permission.
          print("Location permission not granted.");
          return;
        }
      }

      location.onLocationChanged.listen((LocationData data) {
        store.dispatch(LocationChanged(
          location: LatLng(data.latitude, data.longitude),
        ));
      })
        ..onError((error, stackTrace) {
          print("Location-error: " + error);
        });
    }
  };
}
