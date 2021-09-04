import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:dokart/data/toilets/actions.dart';
import 'package:dokart/models/app_state.dart';
import 'package:dokart/models/toilet.dart';
import 'package:dokart/screens/toilets/widgets/toilet_card.dart';
import 'package:dokart/utils/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:redux/redux.dart';

class Toilets extends StatefulWidget {
  @override
  _ToiletsState createState() => _ToiletsState();
}

class _ToiletsState extends State<Toilets> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final Map<String, MarkerId> mapMarkerIds = <String, MarkerId>{};
  Completer<GoogleMapController> _mapController = Completer();
  bool _toggleStickToLocation = false;
  BitmapDescriptor _toiletIcon;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  void _loadAssets() async {
    _toiletIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/toilet.png",
    );
  }

  void _setupMapMarkerIds(List<Toilet> toilets) async {
    toilets.forEach((toilet) {
      mapMarkerIds[toilet.id] = MarkerId(toilet.id);
    });
  }

  void _moveToLocation(LatLng location, {String mapMarkerId}) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: location, zoom: max(0, 16.0)),
    ));
    if (mapMarkerId != null) {
      controller.showMarkerInfoWindow(mapMarkerIds[mapMarkerId]);
    }
  }

  void goToToilet(Toilet toilet) =>
      _moveToLocation(toilet.getLatLng, mapMarkerId: toilet.id);

  void scrollToToilet(List<Toilet> toilets, Toilet toilet) => itemScrollController.scrollTo(
        index: toilets.indexOf(toilet),
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutCubic,
        alignment: 0,
      );

  List<Marker> _toiletMarkers(List<Toilet> toilets) => toilets
      .map((toilet) => Marker(
            markerId: mapMarkerIds[toilet.id],
            position: toilet.getLatLng,
            icon: _toiletIcon,
            infoWindow: InfoWindow(
                title: toilet.name,
                snippet: toilet.getDistance + " unna",
                onTap: () {
                  print("Tapped toilet " + toilet.name);
                }),
            onTap: () {
              _moveToLocation(toilet.getLatLng, mapMarkerId: toilet.id);
              scrollToToilet(toilets, toilet);
            },
          ))
      .toList(growable: false);

  Widget _drawMap(BuildContext context, AppState state) {
    if (state.location == null || _toiletIcon == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Laster inn...",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          )
        ],
      );
    }
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: state.location, zoom: 16.0),
      onMapCreated: (GoogleMapController controller) {
        if (!_mapController.isCompleted) {
          _mapController.complete(controller);
        } else {

          // TODO: How to handle this on rotation?
          _mapController = Completer();
          _mapController.complete(controller);
        }
      },
      markers: Set.from(_toiletMarkers(state.filteredToilets)),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
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
    return ScrollablePositionedList.builder(
      itemCount: toilets.length,
      itemBuilder: (_, idx) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: toiletCard(context, toilets[idx], () async {
          goToToilet(toilets[idx]);
        }),
      ),
      itemScrollController: itemScrollController,
    );
    return ListView(
      children: toilets
          .map((toilet) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: toiletCard(context, toilet, () async {
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
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Toalettfiltre",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Divider(
          height: 1.0,
        ),
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
          value: store.state.toiletFilter.accessible,
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
          value: store.state.toiletFilter.babycare,
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
          value: store.state.toiletFilter.pissoir,
        ),
      ],
    );
  }

  BottomAppBar _bottomAppBar() => BottomAppBar(
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
        }, onInit: (Store<AppState> store) {
          _setupMapMarkerIds(store.state.filteredToilets);
        }, onDidChange: (_, Store<AppState> store) {
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
