## 1.1.0

* Adds optional builder method to `MarkerWidget` to supply a callback to widgets whose visual state may change after the first build (e.g. network images with a placeholder).

* Fixed a bug that would briefly display the default GoogleMap marker instead of the visual content from a `MarkerWidget`.

## 1.0.1

* Fixed a bug related to a missing dispose call for animation controllers in MarkerWidgets.  (see [issue #1](https://github.com/jbadger3/google_maps_marker_widgets/issues/1))

## 1.0.0

* Initial development and release.