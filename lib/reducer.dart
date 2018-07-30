import 'package:dokart/data/reducer.dart';
import 'package:dokart/models/app_state.dart';
import 'package:redux/redux.dart';

AppState appReducer(AppState state, action) =>
    combineReducers([dataReducer])(state, action);
