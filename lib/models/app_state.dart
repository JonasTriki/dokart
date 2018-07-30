import 'package:dokart/models/toilet.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final bool isLoading;
  final dynamic error;
  final List<Toilet> toilets;

  AppState({this.isLoading = false, this.error, this.toilets = const []});

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({bool isLoading, dynamic error, List<Toilet> toilets}) =>
      AppState(
          isLoading: isLoading ?? this.isLoading,
          error: error ?? this.error,
          toilets: toilets ?? this.toilets);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          error == other.error &&
          toilets == other.toilets;

  @override
  int get hashCode => isLoading.hashCode ^ error.hashCode ^ toilets.hashCode;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, error: $error, toilets: $toilets}';
  }
}
