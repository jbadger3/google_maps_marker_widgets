import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'inherited_marker_widgets_controller.dart';
import 'marker_widgets_controller.dart';

///
class MarkerWidgets extends StatefulWidget {
  const MarkerWidgets({
    super.key,
    required this.markerWidgetsController,
    required this.builder,
  });
  final MarkerWidgetsController markerWidgetsController;
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
    return ListenableBuilder(
        listenable: markerWidgetsController,
        builder: (context, child) {
          return InheritedMarkerWidgetsController(
            controller: markerWidgetsController,
            child: Stack(children: [
              ...markerWidgetsController.markerWidgets(),
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
