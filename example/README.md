# Google Maps Marker Widgets Example

Demonstrates the core functionality of goog_maps_marker_widgets which includes animating marker positions and using a custom location puck.

This example does **not** include a Google Maps API key.  

## For iOS
 1. Open the Runner.xcworkspace in XCode. (don't do it in VS Code.  It won't work.)
 2. Under the Runner folder right click and select 'New Empty File'.  
 3. Name the new file MAPS_API_KEY.txt.
 4. Paste in the contents of your Google Maps API key.  
 
 You should be all set run from VS Code or using flutter run.

 The AppDelegate.swift has code to grab the key from your new file. 

As an alternative you can edit AppDelegate.swift directly and replace the current code with the official instructions from [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) using your API key.

## For Android
  1. open android/local.properites
  2. Add a new line to the file MAPS_API_KEY=your_key

You should be all set.

As an alternative edit the android/app/src/main/AndroidManifest.xml with the official instructions from [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) using your API key.

