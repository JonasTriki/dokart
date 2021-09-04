import 'package:dokart/middleware.dart';
import 'package:dokart/models/app_config.dart';
import 'package:dokart/models/app_state.dart';
import 'package:dokart/reducer.dart';
import 'package:dokart/routes.dart';
import 'package:dokart/screens/splash/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppConfig(appName: "Dokart", child: Dokart()));
}

class Dokart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DokartState();
}

class _DokartState extends State<Dokart> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

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

    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error: " + snapshot.error);
            return Splash();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return StoreProvider<AppState>(
              store: store,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: config.appName,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                initialRoute: '/',
                routes: getRoutes(),
              ),
            );
          }

          return Splash();
        });
  }
}
