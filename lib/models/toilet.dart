import 'package:dokart/models/meta_state.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong/latlong.dart';

class Toilet {
  // Dynamic because Oslo/Firestore toilets gets parsed to double, whilst Oslo/Stvg is string, so we need to make it flexible.
  final dynamic longitude;
  final dynamic latitude;
  final String pris;
  final String plassering;
  final String adresse;
  final String tidHverdag;
  final String tidLordag;
  final String tidSondag;
  final String rullestol;
  final String stellerom;
  final String pissoir;
  final GlobalKey key = GlobalKey();
  num distance;

  Toilet(
      {this.longitude,
      this.latitude,
      this.pris,
      this.plassering,
      this.adresse,
      this.tidHverdag,
      this.tidLordag,
      this.tidSondag,
      this.pissoir,
      this.rullestol,
      this.stellerom,
      this.distance});

  LatLng get getLatLng => LatLng(getLatitude, getLongitude);

  double get getLongitude =>
      longitude is double ? longitude : double.tryParse(longitude) ?? 0.0;

  double get getLatitude =>
      latitude is double ? latitude : double.tryParse(latitude) ?? 0.0;

  int get getPris => pris == "Ja" ? -1 : int.tryParse(pris) ?? 0;

  String get getPlassering {
    if (plassering == null) {
      print(this);
    }
    return plassering.replaceAll(" , ", ", ");
  }

  String get getAdresse => adresse;

  String _fixToiletTime(String time) {
    if (time == ("NULL")) {
      return "Stengt";
    } else {
      return time
          .replaceAll("-", " - ")
          .replaceAll("-", "–")
          .replaceAll("  ", " ");
    }
  }

  String get getTidHverdag => _fixToiletTime(tidHverdag);

  String get getTidLordag => _fixToiletTime(tidLordag);

  String get getTidSondag => _fixToiletTime(tidSondag);

  MetaState get isRullestol => rullestol == "-1"
      ? MetaState.UNKNOWN
      : rullestol == "1" ? MetaState.YES : MetaState.NO;

  MetaState get isStellerom => stellerom == "-1"
      ? MetaState.UNKNOWN
      : (stellerom == "1" || stellerom == "JA") ? MetaState.YES : MetaState.NO;

  MetaState get isPissoir => pissoir == "-1"
      ? MetaState.UNKNOWN
      : pissoir == "1" ? MetaState.YES : MetaState.NO;

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

  factory Toilet.fromJson(Map<String, dynamic> json) {
    return Toilet(
        latitude: json['latitude'],
        longitude: json['longitude'],
        pris: json['pris'],
        plassering: json['plassering'],
        adresse: json['adresse'],
        tidHverdag: json['tid_hverdag'] ?? json['aapningstider_hverdag'],
        tidLordag: json['tid_lordag'] ?? json['aapningstider_loerdag'],
        tidSondag: json['tid_sondag'] ?? json['aapningstider_soendag'],
        pissoir: json['pissoir_only'] ?? json['pissoir'],
        rullestol: json['rullestol'],
        stellerom: json['stellerom']);
  }

  factory Toilet.fromBymJson(Map<String, dynamic> json) {
    final dynamic attributes = json['attributes'];
    final dynamic geometry = json['geometry'];

    String getApningstid() {
      final String apningstid = attributes['Åpningstid'];
      if (apningstid.contains(", ")) {
        return apningstid.split(", ")[0];
      } else if (apningstid.contains("døgn")) {
        return "Døgnåpent";
      } else if (apningstid.contains(" - ")) {
        return apningstid;
      } else {
        return "Ukjent";
      }
    }

    return Toilet(
        latitude: geometry['y'],
        longitude: geometry['x'],
        pris: attributes['Betaling'],
        plassering: attributes['Navn'],
        adresse: attributes['Sted'],
        tidHverdag: getApningstid(),
        tidLordag: getApningstid(),
        tidSondag: getApningstid(),
        pissoir: "-1",
        rullestol: attributes['Type'] == "UU Toalett" ? "1" : "0",
        stellerom: "-1");
  }

  @override
  String toString() {
    return 'Toilet{longitude: $longitude, latitude: $latitude, pris: $pris, plassering: $plassering, adresse: $adresse, tid_hverdag: $tidHverdag, tid_lordag: $tidLordag, tid_sondag: $tidSondag, rullestol: $isRullestol, stellerom: $isStellerom, pissoir: $isPissoir}';
  }
}
