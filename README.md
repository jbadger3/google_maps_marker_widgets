# Google Maps Marker Widgets

A Flutter package for using widgets as markers in Google Maps.

## Features

* Use *any* widget as a [Marker] on a [GoogleMap].

* Update marker locations with smooth animations (no teleportation).

* A customizable [LocationPuck] widget that allows for manual control over location updates and appearance. 

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

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart

```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

## Author
Developed by [DabblingBadgerLLC](https://www.dabblingbadger.com)