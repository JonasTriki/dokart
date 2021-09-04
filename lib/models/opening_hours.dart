import 'package:dokart/models/opening_hour.dart';
import 'package:flutter/widgets.dart';

class OpeningHours {
  final OpeningHour weekday;
  final OpeningHour saturday;
  final OpeningHour sunday;

  factory OpeningHours.fromJson(Map json) {
    return OpeningHours(
      weekday: OpeningHour.fromJson(json['weekday']),
      saturday: OpeningHour.fromJson(json['saturday']),
      sunday: OpeningHour.fromJson(json['sunday']),
    );
  }

  bool get sameOpeningHours => weekday == saturday && saturday == sunday;

  OpeningHours({
    @required this.weekday,
    @required this.saturday,
    @required this.sunday,
  });
}
