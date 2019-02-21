import 'package:dokart/models/toilet.dart';
import 'package:dokart/utils/filter.dart';
import 'package:meta/meta.dart';

class LoadToilets {}

class LoadToiletsSuccessful {
  final List<Toilet> toilets;

  LoadToiletsSuccessful({@required this.toilets});

  @override
  String toString() {
    return 'LoadToiletsSuccessful{toilets: $toilets}';
  }
}

class LoadToiletsError {
  final dynamic error;

  LoadToiletsError(this.error);

  @override
  String toString() {
    return 'LoadToiletsError{There was an error loading toilets: $error}';
  }
}

class ApplyToiletFilter {
  final String filter;
  final bool on;

  ApplyToiletFilter(this.filter, this.on);

  @override
  String toString() {
    return 'ApplyToiletFilter{filter: $filter, on: $on}';
  }
}

class SetToiletFilter {
  final Filter toilerFilter;

  SetToiletFilter(this.toilerFilter);

  @override
  String toString() {
    return 'SetToiletFilter{toilerFilter: $toilerFilter}';
  }
}
