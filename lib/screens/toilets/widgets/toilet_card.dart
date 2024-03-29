import 'package:dokart/models/app_state.dart';
import 'package:dokart/models/toilet.dart';
import 'package:dokart/utils/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Color _iconColor = Color(0xff35485e);

Widget _top(BuildContext context, Toilet toilet) => Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                toilet.getDistance,
                textScaleFactor: 1.5,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(toilet.name, textScaleFactor: 0.9)
            ],
          ),
        ),
        Expanded(
          child: StoreBuilder<AppState>(
            builder: (BuildContext context, store) => MaterialButton(
                onPressed: () async {
                  launchMaps(context, toilet.getLatLng);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.map,
                      color: _iconColor,
                    ),
                    Text(
                      "Åpne i kart",
                      textAlign: TextAlign.center,
                    )
                  ],
                )),
          ),
        )
      ],
    );

Widget _infoItem(BuildContext context, IconData iconData, String text) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          iconData,
          color: _iconColor,
        ),
        Text(
          text,
          textScaleFactor: 0.9,
        )
      ],
    );

Widget _bottom(BuildContext context, Toilet toilet) {
  final List<Widget> additionalInfoItems = [];
  if (toilet.accessible) {
    additionalInfoItems.add(_infoItem(context, Icons.accessible, "Rullestol"));
  }
  if (toilet.babycare) {
    additionalInfoItems.add(_infoItem(context, MdiIcons.baby, "Stellerom"));
  }
  TextStyle weekendStyle = TextStyle(color: Color(0xfff32121));
  final List<Widget> openingHourItems = [];
  if (toilet.openingHours.sameOpeningHours) {
    if (toilet.openingHours.weekday.isAlwaysOpen) {
      openingHourItems.add(Text(
        "Døgnåpent\nalle dager",
        textScaleFactor: 0.9,
        textAlign: TextAlign.center,
      ));
    } else {
      openingHourItems.addAll([
        Text(
          "Alle dager",
          textScaleFactor: 0.9,
        ),
        Text(
          toilet.openingHours.weekday.toString(),
          textScaleFactor: 0.9,
        ),
      ]);
    }
  } else {
    openingHourItems.addAll([
      Text(
        toilet.openingHours.weekday.toString(),
        textScaleFactor: 0.9,
      ),
      Text(
        toilet.openingHours.saturday.toString(),
        textScaleFactor: 0.9,
        style: weekendStyle,
      ),
      Text(
        toilet.openingHours.sunday.toString(),
        textScaleFactor: 0.9,
        style: weekendStyle,
      ),
    ]);
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.access_time,
              color: _iconColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: openingHourItems,
          )
        ],
      ),
      _infoItem(context, Icons.monetization_on,
          toilet.price > 0 ? toilet.price.toString() + " kr" : "Gratis")
    ]..addAll(additionalInfoItems),
  );
}

Card toiletCard(BuildContext context, Toilet toilet, onClick) {
  return Card(
    elevation: 2.0,
    child: InkWell(
      onTap: () {
        onClick();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 120.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _top(context, toilet),
              ),
              Expanded(
                child: _bottom(context, toilet),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
