import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';

class GetLocation {}

class LocationChanged {
  final LatLng location;

  LocationChanged({@required this.location});

  @override
  String toString() {
    return 'LocationChanged{location: $location}';
  }
}
