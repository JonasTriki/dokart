import 'package:flutter/material.dart';

class OpeningHour {
  final String from;
  final String to;

  OpeningHour({
    @required this.from,
    @required this.to,
  });

  factory OpeningHour.fromJson(Map json) {
    return OpeningHour(
      from: json['from'],
      to: json['to'],
    );
  }

  bool get isClosed => from == to && from == "closed";

  bool get isAlwaysOpen => from == "00:00" && to == "24:00";

  @override
  String toString() {
    return from + " - " + to;
  }
}
