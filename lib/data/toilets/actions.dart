import 'package:dokart/models/toilet.dart';
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
