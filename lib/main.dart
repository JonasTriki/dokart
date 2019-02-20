import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dokart/middleware.dart';
import 'package:dokart/models/app_config.dart';
import 'package:dokart/models/app_state.dart';
import 'package:dokart/reducer.dart';
import 'package:dokart/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

void main() async {
  await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);

  runApp(AppConfig(appName: "Dokart", child: Dokart()));
}

class Dokart extends StatelessWidget {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.loading(),
    middleware: []
      ..addAll(appMiddleware())
      ..add(LoggingMiddleware.printer()),
  );

  @override
  Widget build(BuildContext context) {
    // Call AppConfig.of(context) anywhere to obtain the
    // environment specific configuration
    var config = AppConfig.of(context);

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: config.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: getRoutes(),
      ),
    );
  }
}
