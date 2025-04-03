## 1.1.1

* Fixed a bug [issue #5](https://github.com/jbadger3/google_maps_marker_widgets/issues/5) related to improper disposal of animation controllers when removing markers.

## 1.1.0

* Adds optional builder method to `MarkerWidget` to supply a callback to widgets whose visual state may change after the first build (e.g. network images with a placeholder).

* Adds `bulkAddMarkerWidget` and `bulkRemoveMarker` to `MarkerWidgetsController`.

## 1.0.1

* Fixed a bug related to a missing dispose call for animation controllers in MarkerWidgets.  (see [issue #1](https://github.com/jbadger3/google_maps_marker_widgets/issues/1))

## 1.0.0

* Initial development and release.