import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Maps Marker Widgets Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MarkerWidgetsController _markerWidgetsController =
      MarkerWidgetsController();
  StreamSubscription<Position>? _deviceLocationStream;
  StreamSubscription<CompassEvent>? _compassEventsStream;
  CameraPosition? _cameraPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    _addSampleWidgetMarkers();
    super.initState();
  }

  @override
  void dispose() {
    _deviceLocationStream?.cancel();
    _compassEventsStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MarkerWidgets(
        markerWidgetsController: _markerWidgetsController,
        builder: (context, markers) => GoogleMap(
          onMapCreated: _onMapCreated,
          onCameraMove: _onCameraMove,
          initialCameraPosition:
              CameraPosition(target: LatLng(41.8, -99.65), zoom: 4),
          markers: markers,
          myLocationButtonEnabled: false,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveMarkers,
        child: Icon(Icons.play_arrow_rounded),
      ),
    );
  }

  void _onMapCreated(GoogleMapController mapController) async {
    _mapController = mapController;
    try {
      //check permissions and start streaming location data
      await _startLocationDataStreaming();
      final currentLocation = await Geolocator.getCurrentPosition();
      final newLatLng =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      final cameraUpdate = CameraUpdate.newLatLng(newLatLng);
      await _mapController?.animateCamera(cameraUpdate);
    } catch (error) {
      //TODO: handle error
    }
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    _cameraPosition = cameraPosition;
  }

  void _addSampleWidgetMarkers() {
    //add a few sample widgets to demonstrate animation
    //Note the anchor / Offset is set to 0.5, 0.5.
    //This centers your widget on the position you provide.
    final treeMarkerId = MarkerId('treeMarker');
    _markerWidgetsController.addMarkerWidget(
        markerWidget: MarkerWidget(
          markerId: treeMarkerId,
          child: Icon(Icons.park, color: Colors.green, size: 45),
        ),
        marker: Marker(
            markerId: treeMarkerId,
            anchor: Offset(0.5, 0.5),
            position: LatLng(37, -108)));
    final smileyMarkerId = MarkerId('smileyMarker');
    _markerWidgetsController.addMarkerWidget(
        markerWidget: MarkerWidget(
          markerId: smileyMarkerId,
          child: Text(
            '😀',
            style: TextStyle(fontSize: 40),
          ),
        ),
        marker: Marker(
            markerId: smileyMarkerId,
            position: LatLng(37, -101),
            anchor: Offset(0.5, 0.5)));
    final flightMarkerId = MarkerId('flightMarker');
    _markerWidgetsController.addMarkerWidget(
      markerWidget: MarkerWidget(
          markerId: flightMarkerId,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.flight,
              color: Colors.white,
            ),
          )),
      marker: Marker(
        markerId: flightMarkerId,
        anchor: Offset(0.5, 0.5),
        position: LatLng(37, -93.65),
      ),
    );
  }

  //Moves markers to new random locations
  void _moveMarkers() {
    final markers = _markerWidgetsController.markers.value;
    for (var marker in markers) {
      if (marker.markerId != MarkerId('device')) {
        final newLat =
            41.8 + Random().nextDouble() * 10 * (Random().nextBool() ? -1 : 1);
        final newLng =
            -99 + Random().nextDouble() * 10 * (Random().nextBool() ? -1 : 1);
        final newMarker =
            marker.copyWith(positionParam: LatLng(newLat, newLng));
        _markerWidgetsController.updateMarker(newMarker);
      }
    }
  }

  Future<void> _startLocationDataStreaming() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    //Start streaming the current position
    _deviceLocationStream =
        Geolocator.getPositionStream().listen(_onDeviceLocationUpdate);
    _compassEventsStream = FlutterCompass.events?.listen(_onCompassEvent);
  }

  void _onCompassEvent(CompassEvent compassEvent) {
    final currentHeading = compassEvent.heading;
    //print('heading is: ${compassEvent.heading}');
    final marker = _markerWidgetsController.markerForId(MarkerId('device'));
    if (marker != null) {
      double rotationParam =
          (currentHeading ?? 0) - (_cameraPosition?.bearing ?? 0);
      final newMarker = marker.copyWith(rotationParam: rotationParam);
      _markerWidgetsController.updateMarker(newMarker, animated: false);
    }
  }

  void _onDeviceLocationUpdate(Position position) {
    //print('Location update (lat, lng): ${position.latitude}, ${position.longitude}');
    final newLatLng = LatLng(position.latitude, position.longitude);
    final deviceMaker =
        _markerWidgetsController.markerForId(MarkerId('device'));
    if (deviceMaker == null) {
      //add the device marker to the map
      _markerWidgetsController.addDeviceLocationPuck(
          initialPosition: newLatLng,
          locationPuck: LocationPuck(
            showHeading: true,
          ));
    } else {
      final positionParam = LatLng(position.latitude, position.longitude);
      final newDeviceMarker =
          deviceMaker.copyWith(positionParam: positionParam);
      _markerWidgetsController.updateMarker(newDeviceMarker);
    }
  }
}
