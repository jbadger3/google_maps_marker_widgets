import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:screenshot/screenshot.dart';

import 'marker_widgets_controller.dart';
import 'inherited_marker_widgets_controller.dart';

///A widget that supplies the visual content for a [Marker] in [GoogleMap].
class MarkerWidget extends StatefulWidget {
  const MarkerWidget(
      {required this.markerId,
      this.animation,
      this.builder,
      this.child,
      super.key});

  ///[MarkerId] for the [Marker] this widget is associated with.
  final MarkerId markerId;

  ///Optional [Animation] used by this widget.
  ///
  ///Do **not** use [animation] for updaing this objects position on the [GoogleMap].
  ///Use [MarkerWidgetsController.updateMarker] instead.
  final Animation? animation;

  ///Builder to use when constructing the visual content with the associated [Marker].
  ///
  ///The builder method is useful for widgets that may not display their final content
  ///the first time the widget is build.  Use the updateMarkerWidgetsController
  /// function provided in the builder to signal the widget's appearance should be updated.
  ///
  ///**Note** Only one of [builder] or [child] can be passed in the constructor.
  final Widget Function(
      {BuildContext context,
      Function() updateMarkerWidgetsController})? builder;

  ///Widget to use as the visual content with the associated [Marker]
  ///
  ///**Note** Only one of [builder] or [child] can be passed in the constructor.
  final Widget? child;

  @override
  State<MarkerWidget> createState() => _MarkerWidgetState();
}

class _MarkerWidgetState extends State<MarkerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _markerUpdateAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  final screenshotController = ScreenshotController();
  double pixelRatio = 1.0;
  MarkerWidgetsController? markerWidgetsController;

  @override
  void initState() {
    if (widget.animation != null) {
      widget.animation!.addListener(updateMarkerWidgetsController);
    }
    super.initState();
  }

  @override
  void dispose() {
    _markerUpdateAnimationController.dispose();
    widget.animation?.removeListener(updateMarkerWidgetsController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onlyOneOfBuilderOrChildNonNull =
        (widget.builder == null && widget.child != null) ||
            (widget.builder != null && widget.child == null);
    assert(onlyOneOfBuilderOrChildNonNull,
        'Exactly one of builder or child must be assigned in a MarkerWidget!');
    pixelRatio = MediaQuery.of(context).devicePixelRatio;
    markerWidgetsController =
        InheritedMarkerWidgetsController.of(context).controller;
    markerWidgetsController?.addMarkerAnimationController(
        _markerUpdateAnimationController, widget.markerId);
    Future.delayed(Duration.zero, () => updateMarkerWidgetsController());
    if (widget.builder == null && widget.child != null) {
      return RepaintBoundary(
        child:
            Screenshot(controller: screenshotController, child: widget.child),
      );
    }
    if (widget.builder != null && widget.child == null) {
      return RepaintBoundary(
        child: Screenshot(
          controller: screenshotController,
          child: widget.builder!(
              context: context,
              updateMarkerWidgetsController: updateMarkerWidgetsController),
        ),
      );
    }
    return ErrorWidget(
        'Exactly one of builder or child must be assigned in a MarkerWidget!');
  }

  @override
  void didUpdateWidget(covariant MarkerWidget oldWidget) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateMarkerWidgetsController);
    super.didUpdateWidget(oldWidget);
  }

  ///Updates the associated [Marker] with the [BitmapDescriptor] (image)
  ///of this widget.
  void updateMarkerWidgetsController() async {
    print('update marker widget controller called');
    final bitmapDescriptor = await widgetImage();
    markerWidgetsController?.updateMarkerImage(
        bitmapDescriptor: bitmapDescriptor, markerId: widget.markerId);
  }

  ///Returns the [BitmapDescriptor] (image) associated with this widget.
  Future<BitmapDescriptor?> widgetImage() async {
    try {
      final imageBytes =
          await screenshotController.capture(delay: Duration.zero);
      if (imageBytes != null) {
        return BitmapDescriptor.bytes(imageBytes, imagePixelRatio: pixelRatio);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
