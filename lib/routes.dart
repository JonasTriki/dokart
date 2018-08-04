import 'package:dokart/data/location/actions.dart';
import 'package:dokart/data/toilets/actions.dart';
import 'package:dokart/models/app_state.dart';
import 'package:dokart/screens/splash/index.dart';
import 'package:dokart/screens/toilets/index.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

Map<String, WidgetBuilder> getRoutes() => {
      '/': (BuildContext context) {
        return StoreBuilder<AppState>(
            onInit: (Store store) {
              return store.dispatch(LoadToilets());
            },
            onWillChange: (store) {
              if (store.state.toilets.isNotEmpty) {
                store.dispatch(GetLocation());
                Navigator.of(context).pushReplacementNamed("/toilets");
              }
            },
            builder: (BuildContext context, Store vm) => Splash());
      },
      '/toilets': (BuildContext context) {
        return StoreBuilder<AppState>(
          builder: (context, store) => Toilets(),
        );
      }
    };
