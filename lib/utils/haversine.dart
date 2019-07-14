import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show pow, sin, cos, sqrt, asin, pi;

double _radiansFromDegrees(final double degrees) => degrees * (pi / 180.0);

double calculateDistance(LatLng startLoc, LatLng endLoc) {
  var lat1 = _radiansFromDegrees(startLoc.latitude);
  var lon1 = _radiansFromDegrees(startLoc.longitude);
  var lat2 = _radiansFromDegrees(endLoc.latitude);
  var lon2 = _radiansFromDegrees(endLoc.longitude);
  const R = 6378137.0; // WGS84 major axis

  double a = pow(sin(lat2 - lat1) / 2, 2) +
      cos(lat1) * cos(lat2) * pow(sin(lon2 - lon1) / 2, 2);
  double c = 2 * asin(sqrt(a));

  // Returns the distance in meters
  return R * c;
}
