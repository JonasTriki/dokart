import 'package:dokart/data/middleware.dart';
import 'package:dokart/models/app_state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> appMiddleware() => createDataMiddleware();