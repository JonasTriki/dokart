import 'package:dokart/data/toilets/middleware.dart';
import 'package:dokart/models/app_state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createDataMiddleware() => createToiletsMiddleware();
