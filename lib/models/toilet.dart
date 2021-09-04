import 'package:dokart/models/opening_hour.dart';
import 'package:dokart/models/opening_hours.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Toilet {
  final String id;
  final bool accessible;
  final String address;
  final bool babycare;
  final String commune;
  final double longitude;
  final double latitude;
  final OpeningHours openingHours;
  final bool pissoir;
  final String placement;
  final int price;
  final GlobalKey key = GlobalKey();
  num distance;

  Toilet({
    this.id,
    this.accessible,
    this.address,
    this.babycare,
    this.commune,
    this.longitude,
    this.latitude,
    this.openingHours,
    this.pissoir,
    this.placement,
    this.price,
    this.distance,
  });

  LatLng get getLatLng => LatLng(latitude, longitude);

  String get name => address.length > 0 ? address : placement;

  OpeningHour getCurrentOpeningHour(DateTime dt) {
    bool isSaturday = dt.weekday == 6;
    bool isSunday = dt.weekday == 7;
    if (isSaturday) {
      return openingHours.saturday;
    } else if (isSunday) {
      return openingHours.sunday;
    }
    return openingHours.weekday;
  }

  String get getDistance {
    if (distance == null) {
      return "Laster...";
    } else if (distance.toInt() > 999) {
      return (distance / 1000).toStringAsFixed(2) + " km";
    } else {
      return distance.toInt().toString() + " meter";
    }
  }

  set setDistance(num distance) => this.distance = distance;

  factory Toilet.fromJson(String id, Map json) {
    return Toilet(
      id: id,
      accessible: json['accessible'],
      address: json['address'],
      babycare: json['babycare'],
      commune: json['commune'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      openingHours: OpeningHours.fromJson(json['openingHours']),
      price: json['price'],
      placement: json['placement'],
      pissoir: json['pissoir'],
    );
  }

  @override
  String toString() {
    return 'Toilet{id: $id, accessible: $accessible, address: $address, babycare: $babycare, commune: $commune, longitude: $longitude, latitude: $latitude, openingHours: $openingHours, pissoir: $pissoir, placement: $placement, price: $price, key: $key, distance: $distance}';
  }
}
