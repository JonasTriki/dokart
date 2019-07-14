import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:url_launcher/url_launcher.dart";

launchMaps(BuildContext context, LatLng location) async {
  String googleUrl =
      "https://www.google.com/maps/dir/?api=1&destination=${location
      .latitude},${location.longitude}";
  String appleGoogleMapsUrl =
      "comgooglemaps://?center=${location.latitude},${location.longitude}";
  String appleMapsUrl =
      "https://maps.apple.com/?sll=${location.latitude},${location.longitude}";
  if (Theme.of(context).platform == TargetPlatform.android) {
    await launch(googleUrl);
  } else {
    if (await canLaunch("comgooglemaps://")) {
      print("launching com googleUrl");
      await launch(appleGoogleMapsUrl);
    } else if (await canLaunch(appleMapsUrl)) {
      print("launching apple url");
      await launch(appleMapsUrl);
    } else {
      throw "Could not launch url";
    }
  }
}
