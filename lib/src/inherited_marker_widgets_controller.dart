import 'package:flutter/material.dart';

import 'marker_widgets_controller.dart';
import 'marker_widget.dart';

///Provides access to [MarkerWidgetsController] for [MarkerWidget]s in the subtree.
class InheritedMarkerWidgetsController extends InheritedWidget {
  const InheritedMarkerWidgetsController(
      {super.key, required this.controller, required super.child});
  final MarkerWidgetsController controller;

  static InheritedMarkerWidgetsController? maybeOf(
    BuildContext context,
  ) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedMarkerWidgetsController>();
  }

  static InheritedMarkerWidgetsController of(BuildContext context) {
    final InheritedMarkerWidgetsController? result = maybeOf(context);
    assert(result != null,
        'Unable to find an instance of MarkerWidgetsController in tree.');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    //never update
    return false;
  }
}
