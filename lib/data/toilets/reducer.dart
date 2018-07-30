import 'package:dokart/data/toilets/actions.dart';
import 'package:dokart/models/app_state.dart';
import 'package:redux/redux.dart';

final toiletsReducer = combineReducers<AppState>([
  TypedReducer<AppState, LoadToiletsSuccessful>(_loadToilets),
  TypedReducer<AppState, LoadToiletsError>(_loadToiletsError)
]);

AppState _loadToilets(AppState state, action) {
  return state.copyWith(toilets: action.toilets);
}

AppState _loadToiletsError(AppState state, action) {
  return state.copyWith(error: action.error);
}
