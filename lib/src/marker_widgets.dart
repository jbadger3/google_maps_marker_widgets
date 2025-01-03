import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'inherited_marker_widgets_controller.dart';
import 'marker_widget.dart';
import 'marker_widgets_controller.dart';

///A wrapper widget for [GoogleMap].
///
///[MarkerWidgets] is the entry point for using `google_maps_marker_widgets`.
///This widget supplies the set of markers `Set<Marker>` from [markerWidgetsController] to your [builder].
///
///Example
///```dart
/// MarkerWidgets(
///   markerWidgetsController: markerWidgetsController,
///   builder: (BuildContext context, Set<Marker> markers) => GoogleMap(
///     initialCameraPosition: CameraPosition(target: LatLng(41.8, -99.65), zoom: 4),
///     markers: markers),
///   ),
/// )
class MarkerWidgets extends StatefulWidget {
  const MarkerWidgets({
    super.key,
    required this.markerWidgetsController,
    required this.builder,
  });
  final MarkerWidgetsController markerWidgetsController;

  ///Builder function which should be used to construct a [GoogleMap].
  final Widget Function(BuildContext context, Set<Marker> markers) builder;
  @override
  State<MarkerWidgets> createState() => _MarkerWidgetsState();
}

class _MarkerWidgetsState extends State<MarkerWidgets> {
  late final MarkerWidgetsController markerWidgetsController;

  @override
  void initState() {
    markerWidgetsController = widget.markerWidgetsController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return ValueListenableBuilder<List<MarkerWidget>>(
        valueListenable: markerWidgetsController.markerWidgets,
        builder: (context, markerWidgets, child) {
          return InheritedMarkerWidgetsController(
            controller: markerWidgetsController,
            child: Stack(children: [
              ...markerWidgets,
              Container(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              ValueListenableBuilder<Set<Marker>>(
                  valueListenable: markerWidgetsController.markers,
                  builder: (context, markers, child) =>
                      widget.builder(context, markers)),
            ]),
          );
        });
  }
}
