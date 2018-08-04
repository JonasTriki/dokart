import 'dart:math';

import 'package:dokart/mapbox_token.dart';
import 'package:dokart/models/app_state.dart';
import 'package:dokart/models/toilet.dart';
import 'package:dokart/screens/toilets/widgets/toilet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong/latlong.dart';
import 'package:redux/redux.dart';

class Toilets extends StatefulWidget {
  @override
  _ToiletsState createState() => _ToiletsState();
}

class _ToiletsState extends State<Toilets> {
  MapController mapController;
  bool _toggleStickToLocation;

  @override
  void initState() {
    mapController = MapController();
    _toggleStickToLocation = false;
    super.initState();
  }

  _moveToLocation(LatLng location) {
    mapController.move(location, max(mapController.zoom, 16.0));
  }

  Marker _myLocation(LatLng currentLocation) => Marker(
        point: currentLocation,
        builder: (ctx) => Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: const Color(0xffffffff),
                    spreadRadius: -5.0,
                    blurRadius: 5.0)
              ]),
              child: GestureDetector(
                onTap: () {
                  _moveToLocation(currentLocation);
                },
                child: const Icon(const IconData(0xf00c, fontFamily: "mdi"),
                    color: Color(0xff2196f3)),
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

  Widget _drawMap(BuildContext context, AppState state) {
    if (state.location == null) {
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
      options: MapOptions(center: state.location, zoom: 16.0),
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
          markers: [_myLocation(state.location)]
            ..addAll(_toiletMarkers(state.toilets)),
        ),
      ],
    );
  }

  ListView _drawToiletList(BuildContext context, List<Toilet> toilets) =>
      ListView(
        children: toilets
            .map((toilet) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: toiletCard(context, toilet, () {
                    print(toilet);
                    goToToilet(toilet);
                  }),
                ))
            .toList(),
      );

  List<Widget> _content(Store<AppState> store) => [
        Expanded(child: _drawMap(context, store.state)),
        Expanded(child: _drawToiletList(context, store.state.toilets))
      ];

  BottomAppBar _bottomAppBar() => BottomAppBar(
        hasNotch: false,
        child: StoreBuilder<AppState>(
          builder: (BuildContext context, store) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new ListTile(
                                leading: new Icon(Icons.music_note),
                                title: new Text('Music'),
                                onTap: () {},
                              ),
                              new ListTile(
                                leading: new Icon(Icons.photo_album),
                                title: new Text('Photos'),
                                onTap: () {},
                              ),
                              new ListTile(
                                leading: new Icon(Icons.videocam),
                                title: new Text('Video'),
                                onTap: () {},
                              ),
                            ],
                          );
                        });
                  },
                ),
                IconButton(
                  icon: Icon(
                    IconData(0xf1a4, fontFamily: "mdi"),
                    color: _toggleStickToLocation
                        ? Color(0xff2097f3)
                        : Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    setState(() {
                      _toggleStickToLocation = !_toggleStickToLocation;
                      if (_toggleStickToLocation) {
                        _moveToLocation(store.state.location);
                      }
                    });
                  },
                ),
              ],
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff6f7fa),
        body: StoreBuilder<AppState>(builder: (BuildContext context, store) {
          final Orientation orientation = MediaQuery.of(context).orientation;
          return orientation == Orientation.portrait
              ? Column(children: _content(store))
              : Row(children: _content(store));
        }, onDidChange: (Store<AppState> store) {
          if (_toggleStickToLocation) {
            _moveToLocation(store.state.location);
          }
        }),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          icon: const Icon(const IconData(0xf5cd, fontFamily: "mdi")),
          label: const Text("Nærmeste toalett"),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _bottomAppBar(),
      ),
    );
  }
}
