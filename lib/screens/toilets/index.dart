import 'dart:math';

import 'package:dokart/mapbox_token.dart';
import 'package:dokart/models/app_state.dart';
import 'package:dokart/models/toilet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:redux/redux.dart';

class Toilets extends StatefulWidget {
  @override
  _ToiletsState createState() => _ToiletsState();
}

class _ToiletsState extends State<Toilets> {
  MapController mapController;
  LatLng currentLocation;

  @override
  void initState() {
    mapController = MapController();
    Location().onLocationChanged.listen((Map<String, double> data) {
      print("New location");
      print(currentLocation);
      setState(() {
        currentLocation = LatLng(data["latitude"], data["longitude"]);
      });
    });
    super.initState();
  }

  Marker _myLocation() => Marker(
        point: currentLocation,
        builder: (ctx) => Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: const Color(0x77000000),
                    spreadRadius: -5.0,
                    blurRadius: 5.0)
              ]),
              child: GestureDetector(
                onTap: () {
                  mapController.move(
                      currentLocation, max(mapController.zoom, 16.0));
                },
                child: Image.asset(
                  "assets/circle.png",
                  color: Colors.red,
                ),
              ),
            ),
      );

  goToToilet(Toilet toilet) =>
      mapController.move(toilet.getLatLng, max(mapController.zoom, 16.0));

  List<Marker> _toiletMarkers(List<Toilet> toilets) => toilets
      .map((toilet) => Marker(
            width: 40.0,
            height: 40.0,
            point: toilet.getLatLng,
            builder: (ctx) => GestureDetector(
                  onTap: () {
                    goToToilet(toilet);
                  },
                  child: Tooltip(
                    key: toilet.key,
                    preferBelow: false,
                    message: toilet.getAdresse,
                    child: Image.asset(
                      "assets/marker.png",
                    ),
                  ),
                ),
          ))
      .toList();

  Widget _drawMap(BuildContext context, List<Toilet> toilets) {
    if (currentLocation == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Laster inn...",
              style: Theme
                  .of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          )
        ],
      );
    }
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(center: currentLocation, zoom: 16.0),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            "accessToken": MAPBOX_TOKEN,
            "id": "mapbox.streets",
          },
        ),
        MarkerLayerOptions(
          markers: [_myLocation()]..addAll(_toiletMarkers(toilets)),
        ),
      ],
    );
  }

  ListView _drawToiletList(BuildContext context, List<Toilet> toilets) =>
      ListView(
        children: toilets
            .map((toilet) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 2.0,
                    child: InkWell(
                      onTap: () {
                        goToToilet(toilet);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              toilet.getPlassering,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .title
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(toilet.getAdresse)
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      );

  List<Widget> _content(Store<AppState> store) => [
        Expanded(child: _drawMap(context, store.state.toilets)),
        Expanded(child: _drawToiletList(context, store.state.toilets))
      ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StoreBuilder<AppState>(builder: (BuildContext context, store) {
          final Orientation orientation = MediaQuery.of(context).orientation;
          return orientation == Orientation.portrait
              ? Column(children: _content(store))
              : Row(children: _content(store));
        }),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
