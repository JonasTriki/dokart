import 'package:dokart/models/toilet.dart';
import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final bool isLoading;
  final dynamic error;
  final LatLng location;
  final List<Toilet> toilets;

  AppState(
      {this.isLoading = false,
      this.error,
      this.location,
      this.toilets = const []});

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith(
          {bool isLoading,
          dynamic error,
          LatLng location,
          List<Toilet> toilets}) =>
      AppState(
          isLoading: isLoading ?? this.isLoading,
          error: error ?? this.error,
          location: location ?? this.location,
          toilets: toilets ?? this.toilets);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          error == other.error &&
          location == other.location &&
          toilets == other.toilets;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      error.hashCode ^
      location.hashCode ^
      toilets.hashCode;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, error: $error, location: $location, toilets: $toilets}';
  }
}
