import 'package:dokart/data/toilets/actions.dart';
import 'package:dokart/models/app_state.dart';
import 'package:redux/redux.dart';

final toiletsReducer = combineReducers<AppState>([
  TypedReducer<AppState, LoadToiletsSuccessful>(_loadToilets),
  TypedReducer<AppState, LoadToiletsError>(_loadToiletsError),
  TypedReducer<AppState, SetToiletFilter>(_setToiletFilter),
]);

AppState _loadToilets(AppState state, LoadToiletsSuccessful action) {
  return state.copyWith(toilets: action.toilets);
}

AppState _loadToiletsError(AppState state, LoadToiletsError action) {
  return state.copyWith(error: action.error);
}

AppState _setToiletFilter(AppState state, SetToiletFilter action) {
  return state.copyWith(toiletFilter: action.toilerFilter);
}
