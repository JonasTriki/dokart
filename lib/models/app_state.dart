import 'package:dokart/models/toilet.dart';
import 'package:dokart/utils/filter.dart';
import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final bool isLoading;
  final dynamic error;
  final LatLng location;
  final Filter toiletFilter;
  final List<Toilet> toilets;

  AppState(
      {this.isLoading = false,
      this.error,
      this.location,
      this.toiletFilter = const Filter(),
      this.toilets = const []});

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith(
          {bool isLoading,
          dynamic error,
          LatLng location,
          Filter toiletFilter,
          List<Toilet> toilets}) =>
      AppState(
          isLoading: isLoading ?? this.isLoading,
          error: error ?? this.error,
          location: location ?? this.location,
          toiletFilter: toiletFilter ?? this.toiletFilter,
          toilets: toilets ?? this.toilets);

  List<Toilet> get filteredToilets => toiletFilter.filterToilets(toilets);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          error == other.error &&
          location == other.location &&
          toiletFilter == other.toiletFilter &&
          toilets == other.toilets;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      error.hashCode ^
      location.hashCode ^
      toiletFilter.hashCode ^
      toilets.hashCode;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, error: $error, location: $location, toiletFilter: $toiletFilter, toilets: $toilets}';
  }
}
