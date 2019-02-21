import 'dart:core';
import 'dart:math';

import 'package:dokart/data/toilets/actions.dart';
import 'package:dokart/mapbox_token.dart';
import 'package:dokart/models/app_state.dart';
import 'package:dokart/models/toilet.dart';
import 'package:dokart/screens/toilets/widgets/toilet_card.dart';
import 'package:dokart/utils/filter.dart';
import 'package:dokart/utils/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
                child: const Icon(
                  MdiIcons.tooltipAccount,
                  color: Color(0xff2196f3),
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

  Widget _drawMap(BuildContext context, AppState state) {
    if (state.location == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Laster inn...",
              style: Theme.of(context)
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
            ..addAll(_toiletMarkers(state.filteredToilets)),
        ),
      ],
    );
  }

  Widget _drawToiletList(BuildContext context, List<Toilet> toilets) {
    if (toilets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Icon(
                  MdiIcons.emoticonSadOutline,
                  size: 64.0,
                ),
              ),
              Text(
                "Ingen toaletter som samsvarer med dine filtre",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              )
            ],
          ),
        ),
      );
    }
    return ListView(
      children: toilets
          .map((toilet) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: toiletCard(context, toilet, () {
                  goToToilet(toilet);
                }),
              ))
          .toList(),
    );
  }

  List<Widget> _content(Store<AppState> store) => [
        Expanded(child: _drawMap(context, store.state)),
        Expanded(child: _drawToiletList(context, store.state.filteredToilets))
      ];

  Future<Null> filterUpdated(
      StateSetter updateState, VoidCallback setFilter) async {
    updateState(() {
      setFilter();
    });
  }

  Widget filterTiles(Store<AppState> store, StateSetter setState) {
    Color iconColor = Color(0xff35485e);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all( 16.0),
          child: Text(
            "Toalettfiltre",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Divider(height: 1.0,),
        SwitchListTile(
          secondary: Icon(
            MdiIcons.cashUsd,
            color: iconColor,
          ),
          title: Text("Gratis"),
          onChanged: (c) {
            store.dispatch(
              ApplyToiletFilter("free", c),
            );
            setState(() {});
          },
          value: store.state.toiletFilter.free,
        ),
        SwitchListTile(
          secondary: Icon(
            MdiIcons.doorOpen,
            color: iconColor,
          ),
          title: Text("Åpen nå"),
          onChanged: (c) {
            store.dispatch(
              ApplyToiletFilter("open", c),
            );
            setState(() {});
          },
          value: store.state.toiletFilter.open,
        ),
        SwitchListTile(
          secondary: Icon(
            Icons.accessible,
            color: iconColor,
          ),
          title: Text("Handicap"),
          onChanged: (c) {
            store.dispatch(
              ApplyToiletFilter("handicap", c),
            );
            setState(() {});
          },
          value: store.state.toiletFilter.handicap,
        ),
        SwitchListTile(
          secondary: Icon(
            MdiIcons.baby,
            color: iconColor,
          ),
          title: Text("Stellerom"),
          onChanged: (c) {
            store.dispatch(
              ApplyToiletFilter("stellerom", c),
            );
            setState(() {});
          },
          value: store.state.toiletFilter.stellerom,
        ),
        SwitchListTile(
          secondary: Icon(
            MdiIcons.humanMale,
            color: iconColor,
          ),
          title: Text("Kun pissoir"),
          onChanged: (c) {
            store.dispatch(
              ApplyToiletFilter("pissoirOnly", c),
            );
            setState(() {});
          },
          value: store.state.toiletFilter.pissoirOnly,
        ),
      ],
    );
  }

  BottomAppBar _bottomAppBar() => BottomAppBar(
        //hasNotch: false,
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
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return filterTiles(store, setState);
                            },
                          );
                        });
                  },
                ),
                IconButton(
                  icon: Icon(
                    MdiIcons.crosshairsGps,
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
          icon: const Icon(MdiIcons.nearMe),
          label: const Text("Nærmeste toalett"),
          onPressed: () {
            final store = StoreProvider.of<AppState>(context);
            launchMaps(
                context, store.state.filteredToilets.elementAt(0).getLatLng);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _bottomAppBar(),
      ),
    );
  }
}
