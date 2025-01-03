# Google Maps Marker Widgets

A Flutter package for using widgets as markers in Google Maps.

## Features

* Use *any* widget as a [Marker] on a [GoogleMap].

* Update marker locations with smooth animations (no teleportation).

* A customizable [LocationPuck] widget that allows for manual control over location updates and appearance. 

## Screenshots

| animated marker widgets | custom location puck |
| --- | --- |
| ![animated_markers](https://github.com/jbadger3/google_maps_marker_widgets/blob/main/images/animated_markers.gif?raw=true) | ![location_puck](https://github.com/jbadger3/google_maps_marker_widgets/blob/main/images/location_puck.png?raw=true) |

## Getting started

* Install and setup [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) if you haven't already done so.

* If you plan on tracking the users location be sure to add the appropriate permissions.

<details>
<summary>iOS</summary>

Update your Info.plist to include permissions to access the user's location. 

For foreground only access use

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app to access your location when in use?</string>
```

For apps using monitoring location data in the background use

```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app works best when you allow it to track your location at all times.</string>
```
</details>

<details>
<summary>Android</summary>
For Android open app/src/main/AndroidManifest.xml and add one of following under the `manifest` tag.

``` xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```
</details>

### Add `geolocator` and `flutter_compass` (optional)
```bash
flutter pub add geolocator
flutter pub add flutter_compass
```

## Usage

There are three main components to google_maps_marker_widgets.

1. [MarkerWidget] - a widget which supplies the visual content for a [Marker] in [GoogleMap].

```dart
  final treeMarkerId = MarkerId('treeMarker');
  final treeMarkerWidget = MarkerWidget(
    markerId: treeMarkerId,
    child: Icon(Icons.park, color: Colors.green, size: 45),
  );
```
2. [MarkerWidgetsController] - which manages [MarkerWidget]s and their associated [Marker]s on a [GoogleMap].

You use a markerWidgetsController to add, remove, and update markers.

### create a controller and add a marker
```dart
  final markerWidgetsController = MarkerWidgetsController();
  
  final treeMarker = Marker(
            markerId: treeMarkerId,
            anchor: Offset(0.5, 0.5),
            position: LatLng(37, -108));
  markerWidgetsController.addMarkerWidget(
    markerWidget: treeMarkerWidget,
    marker: treeMarker
  );
```
Note the [Marker.anchor] was set to Offset(0.5, 0.5).  This ensures the marker is centered.  The default anchor is Offset(0.5, 1.0). 

### Update the position of a marker
When updating a marker, the position is automatically animated.

```dart
  final treeMarker = markerWidgetsController.markerForId(treeMarkerId)!;
  final newPosition = LatLng(33, -105);
  final updatedMarker = treeMarker.copyWith(positionParam: newPosition);
  markerWidgetsController.updateMarker(marker: updatedMarker);
```

3. [MarkerWidgets] - A wrapper widget for [GoogleMap].
[MarkerWidgets] is the main entry point for using `google_maps_marker_widgets`.

Pass a [MarkerWidgetsController] to [MarkerWidgets] and in the  [MarkerWidgets.builder] method create your [GoogleMap] passing in the set of supplied markers.

```dart
  ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MarkerWidgets(
        markerWidgetsController: _markerWidgetsController,
        builder: (context, markers) => GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(41.8, -99.65), zoom: 4),
          markers: markers,
        ),
      ),
    );
  }

```


### Full example

```dart
import 'dart:math';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    _addSampleWidgetMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext conftext) {
    return Scaffold(
      body: MarkerWidgets(
        markerWidgetsController: _markerWidgetsController,
        builder: (context, markers) => GoogleMap(
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

  void _addSampleWidgetMarkers() {
    //add a few sample widgets to demonstrate animation
    //Note the anchor / Offset is set to 0.5, 0.5.
    //This centers your widget on the position you provide.

    //Make a MarkerId
    final treeMarkerId = MarkerId('treeMarker');
    
    //Add a MarkerWidget
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
      final newLat =
          41.8 + Random().nextDouble() * 10 * (Random().nextBool() ? -1 : 1);
      final newLng =
          -99 + Random().nextDouble() * 10 * (Random().nextBool() ? -1 : 1);
      final newMarker = marker.copyWith(positionParam: LatLng(newLat, newLng));
      _markerWidgetsController.updateMarker(newMarker);
    }
  }
}
```

## Issues and Contributing
If you find any bugs or want to help add features file an issue on [GitHub](https://github.com/jbadger3/google_maps_marker_widgets/issues).

## Author
Developed by Jonthan Badger PharmD, MS

[DabblingBadgerLLC](https://www.dabblingbadger.com)