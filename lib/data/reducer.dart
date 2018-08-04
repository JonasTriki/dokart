import 'package:dokart/data/location/reducer.dart';
import 'package:dokart/data/toilets/reducer.dart';
import 'package:redux/redux.dart';

final dataReducer = combineReducers([toiletsReducer, locationReducer]);
