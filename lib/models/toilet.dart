import 'package:dokart/models/meta_state.dart';

class Toilet {
  // Dynamic because Oslo/Firestore toilets gets parsed to double, whilst Oslo/Stvg is string, so we need to make it flexible.
  final dynamic longitude;
  final dynamic latitude;
  final String pris;
  final String plassering;
  final String adresse;
  final String tid_hverdag;
  final String tid_lordag;
  final String tid_sondag;
  final String rullestol;
  final String stellerom;
  final String pissoir;

  Toilet(
      {this.longitude,
      this.latitude,
      this.pris,
      this.plassering,
      this.adresse,
      this.tid_hverdag,
      this.tid_lordag,
      this.tid_sondag,
      this.pissoir,
      this.rullestol,
      this.stellerom});

  double get getLongitude =>
      longitude is double ? longitude : double.tryParse(longitude) ?? 0.0;

  double get getLatitude =>
      latitude is double ? latitude : double.tryParse(latitude) ?? 0.0;

  int get getPris => pris == "Ja" ? -1 : int.tryParse(pris) ?? 0;

  String get getPlassering => plassering.replaceAll(" , ", ", ");

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

  String get getTidHverdag => _fixToiletTime(tid_hverdag);

  String get getTidLordag => _fixToiletTime(tid_lordag);

  String get getTidSondag => _fixToiletTime(tid_sondag);

  MetaState get isRullestol => rullestol == "-1"
      ? MetaState.UNKNOWN
      : rullestol == "1" ? MetaState.YES : MetaState.NO;

  MetaState get isStellerom => stellerom == "-1"
      ? MetaState.UNKNOWN
      : (stellerom == "1" || stellerom == "JA") ? MetaState.YES : MetaState.NO;

  MetaState get isPissoir => pissoir == "-1"
      ? MetaState.UNKNOWN
      : pissoir == "1" ? MetaState.YES : MetaState.NO;

  factory Toilet.fromJson(Map<String, dynamic> json) {
    return Toilet(
        latitude: json['latitude'],
        longitude: json['longitude'],
        pris: json['pris'],
        plassering: json['plassering'],
        adresse: json['adresse'],
        tid_hverdag: json['tid_hverdag'] ?? json['aapningstider_hverdag'],
        tid_lordag: json['tid_lordag'] ?? json['aapningstider_loerdag'],
        tid_sondag: json['tid_sondag'] ?? json['aapningstider_soendag'],
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
        plassering: json['Navn'],
        adresse: json['Sted'],
        tid_hverdag: getApningstid(),
        tid_lordag: getApningstid(),
        tid_sondag: getApningstid(),
        pissoir: "-1",
        rullestol: attributes['Type'] == "UU Toalett" ? "1" : "0",
        stellerom: "-1");
  }

  @override
  String toString() {
    return 'Toilet{longitude: $longitude, latitude: $latitude, pris: $pris, plassering: $plassering, adresse: $adresse, tid_hverdag: $tid_hverdag, tid_lordag: $tid_lordag, tid_sondag: $tid_sondag, rullestol: $isRullestol, stellerom: $isStellerom, pissoir: $isPissoir}';
  }
}