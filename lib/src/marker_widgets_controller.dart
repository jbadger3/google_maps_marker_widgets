import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_puck.dart';
import 'marker_widget.dart';

///Manages [MarkerWidget]s and associated [Marker]s on a [GoogleMap].
///
class MarkerWidgetsController {
  final Map<MarkerId, MarkerWidget> _markerWidgets = {};
  final Map<MarkerId, Marker> _markers = {};
  final Map<MarkerId, AnimationController> _markerAnimationControllers = {};

  ///The list of [MarkerId]s being tracked.
  List<MarkerId> get markerIds => _markers.keys.toList();

  ///A listenable containing the set of [Marker]s to display on [GoogleMap].
  ValueNotifier<Set<Marker>> markers = ValueNotifier<Set<Marker>>({});

  ///A listenable containing the list of [MarkerWidget]s currently being displayed and tracked.
  ValueNotifier<List<MarkerWidget>> markerWidgets =
      ValueNotifier<List<MarkerWidget>>([]);

  ///Adds a location puck for the device at [initialPosition] to the [GoogleMap].
  ///
  ///*Note* the [MarkerId] for the location puck is 'device'.
  void addDeviceLocationPuck(
      {LatLng initialPosition = const LatLng(0, 0),
      LocationPuck locationPuck = const LocationPuck()}) {
    final markerId = MarkerId('device');
    final deviceMarker = Marker(
        markerId: markerId,
        position: initialPosition,
        anchor: Offset(0.5, 0.5));
    addMarkerWidget(
        markerWidget: MarkerWidget(
          markerId: markerId,
          child: locationPuck,
        ),
        marker: deviceMarker);
  }

  ///Adds a [Marker] and associated [MarkerWidget] to the [GoogleMap].
  ///
  ///*Note* [markerWidget] and [marker] should have the same [MarkerId]!
  void addMarkerWidget(
      {required MarkerWidget markerWidget, required Marker marker}) {
    final markerId = marker.markerId;
    assert(!_markerWidgets.containsKey(markerId),
        'Marker $markerId already exists! Use updateMarkerWidget instead.');
    assert(markerWidget.markerId == marker.markerId,
        'MarkerWidget and Marker do not have the same MarkerId!');
    _markerWidgets[markerId] = markerWidget;
    final newMarkerWidgets = _markerWidgets.values.toList();
    markerWidgets.value = newMarkerWidgets;

    _markers[markerId] = marker;
    final newSet = <Marker>{};
    newSet.addAll(_markers.values);
    markers.value = newSet;
  }

  ///Removes the [Marker] and [MarkerWidget] associated with [markerId] from the [GoogleMap].
  void removeMarker(MarkerId markerId) {
    assert(_markers.keys.contains(markerId),
        'MarkerId: ${markerId.toString()} not found in tracked markers!');
    assert(_markerWidgets.keys.contains(markerId),
        'MarkerId: ${markerId.toString()} not found in marker widgets!');

    //stop any animations and remove the animation controller first
    final animationController = _markerAnimationControllers[markerId];
    if (animationController != null) {
      animationController.stop();
      animationController.dispose();
      _markerAnimationControllers.remove(markerId);
    }

    _markers.remove(markerId);
    _markerWidgets.remove(markerId);

    final newMarkersSet = <Marker>{};
    newMarkersSet.addAll(_markers.values);
    markers.value = newMarkersSet;

    final newMarkerWidgetsList = _markerWidgets.values.toList();
    markerWidgets.value = newMarkerWidgetsList;
  }

  ///Returns the [Marker] associated with [markerId].
  Marker? markerForId(MarkerId markerId) {
    return _markers[markerId];
  }

  ///Returns the [MarkerWidget] associated with [markerId].
  MarkerWidget? markerWidgetForId(MarkerId markerId) {
    return _markerWidgets[markerId];
  }

  ///Returns the [AnimationController] associated with [markerId].
  AnimationController? animationControllerForId(MarkerId markerId) {
    return _markerAnimationControllers[markerId];
  }

  ///Adds the [animationController] used for updating marker positions on the GoogleMap to this
  ///controller.
  ///
  ///This method is called by [MarkerWidget] on the first build and shouldn't be
  ///called directly.
  void addMarkerAnimationController(
      AnimationController animationController, MarkerId markerId) {
    _markerAnimationControllers[markerId] = animationController;
  }

  ///Update the [bitmapDescriptor] for the [Marker] with [markerId].
  void updateMarkerImage(
      {required BitmapDescriptor? bitmapDescriptor,
      required MarkerId markerId}) {
    assert(_markers.containsKey(markerId), 'Marker $markerId not found!');
    final oldMarker = _markers[markerId]!;
    final newMarker = oldMarker.copyWith(iconParam: bitmapDescriptor);
    _markers[markerId] = newMarker;
    final newSet = <Marker>{};
    newSet.addAll(_markers.values);
    markers.value = newSet;
  }

  ///Updates a [marker] on [GoogleMap].
  ///
  ///By default changes in latitude and longitude will be [animated] using [curve] `Curves.easeInOutCubic` with a [duration] of
  ///1000 milliseconds.
  Future<void> updateMarker(Marker marker,
      {bool animated = true,
      Curve curve = Curves.easeInOutCubic,
      Duration duration = const Duration(milliseconds: 1000)}) async {
    assert(_markers.containsKey(marker.markerId),
        'Marker ${marker.markerId.toString()} not found!');
    final markerId = marker.markerId;
    final oldMarker = _markers[markerId]!;
    final oldLatLang = oldMarker.position;
    final newLatLang = marker.position;

    if (animated && _markerAnimationControllers[marker.markerId] != null) {
      final animationController = _markerAnimationControllers[marker.markerId]!;
      animationController.duration = duration;
      final animation = animationController.drive(CurveTween(curve: curve));
      animation.addListener(() async {
        if (animationController.isAnimating) {
          //update latitude and longitude
          final double latStep =
              (newLatLang.latitude - oldLatLang.latitude) * animation.value +
                  oldLatLang.latitude;
          final double lngStep =
              (newLatLang.longitude - oldLatLang.longitude) * animation.value +
                  oldLatLang.longitude;
          final latLangStep = LatLng(latStep, lngStep);

          final markerStep =
              _markers[markerId]!.copyWith(positionParam: latLangStep);
          _markers[markerId] = markerStep;
          final newSet = <Marker>{};
          newSet.addAll(_markers.values
              .where((setMarker) => setMarker.markerId != marker.markerId));
          newSet.add(markerStep);
          markers.value = newSet;
        }
        if (animationController.isCompleted) {
          _markers[markerId] =
              _markers[markerId]!.copyWith(positionParam: marker.position);
        }
      });
      await animationController.forward();
      animationController.reset();
    } else {
      _markers[markerId] = marker;
      final newSet = <Marker>{};
      newSet.addAll(_markers.values);
      markers.value = newSet;
    }
  }
}
