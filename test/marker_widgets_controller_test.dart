import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';

void main() {
  late MarkerWidgetsController sut;
  setUp(() {
    sut = MarkerWidgetsController();
  });
  group('addDeviceLocationPuck', () {
    test('adds device marker and marker widget to to internal maps', () {
      sut.addDeviceLocationPuck();

      final deviceMarker = sut.markerForId(MarkerId('device'));
      expect(deviceMarker, isNotNull);

      expect(sut.markerWidgets.value.isNotEmpty, isTrue);
    });
  });

  group('addMarkerWidget', () {
    test('when marker already exists throws assertion error', () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);

      expect(() {
        sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);
      }, throwsAssertionError);
    });

    test(
        'when markerIds of marker and markerwidget do not match throws assertion error',
        () {
      final testId1 = MarkerId('testId1');
      final testMarker = Marker(markerId: testId1);
      final testId2 = MarkerId('testId2');
      final testMarkerWidget = MarkerWidget(markerId: testId2);

      expect(() {
        sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);
      }, throwsAssertionError);
    });

    test('adds to _markers and updates markers value notifier', () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);
      final markerIds =
          sut.markers.value.map((marker) => marker.markerId).toList();
      expect(markerIds.contains(testMarkerId), isTrue);
    });

    test('adds marker widget to _markerWidgets and updates value notifier', () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);

      final markerWidgetIds =
          sut.markerWidgets.value.map((markerWidget) => markerWidget.markerId);
      expect(markerWidgetIds.contains(testMarkerId), isTrue);
    });
  });
  group('bulkAddMarkerWidget', () {
    test('when marker already exists throws assertion error', () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);

      expect(() {
        sut.bulkAddMarkerWidget(
            [(markerWidget: testMarkerWidget, marker: testMarker)]);
      }, throwsAssertionError);
    });

    test(
        'when markerIds of marker and markerwidget do not match throws assertion error',
        () {
      final testId1 = MarkerId('testId1');
      final testMarker = Marker(markerId: testId1);
      final testId2 = MarkerId('testId2');
      final testMarkerWidget = MarkerWidget(markerId: testId2);

      expect(() {
        sut.bulkAddMarkerWidget(
            [(markerWidget: testMarkerWidget, marker: testMarker)]);
      }, throwsAssertionError);
    });

    test('adds to _markers and updates markers value notifier', () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.bulkAddMarkerWidget(
          [(markerWidget: testMarkerWidget, marker: testMarker)]);
      final markerIds =
          sut.markers.value.map((marker) => marker.markerId).toList();
      expect(markerIds.contains(testMarkerId), isTrue);
    });

    test('adds marker widget to _markerWidgets and updates value notifier', () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.bulkAddMarkerWidget(
          [(markerWidget: testMarkerWidget, marker: testMarker)]);

      final markerWidgetIds =
          sut.markerWidgets.value.map((markerWidget) => markerWidget.markerId);
      expect(markerWidgetIds.contains(testMarkerId), isTrue);
    });
  });

  group('removeMarker', () {
    test('removes marker from _markers and markers value notifier', () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);

      expect(sut.markerForId(testMarkerId), isNotNull);

      sut.removeMarker(testMarkerId);

      expect(sut.markerForId(testMarkerId), isNull);
    });

    test(
        'removes marker widget from _markerWidgets and markerWidgets value notifier',
        () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);

      expect(sut.markerWidgetForId(testMarkerId), isNotNull);

      sut.removeMarker(testMarkerId);

      expect(sut.markerWidgetForId(testMarkerId), isNull);
    });

    test(
        'removes marker from markers value notifier value and removes markerWidget from markerWidgets value notifier value',
        () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);

      var markerMarkerIds = sut.markers.value.map((marker) => marker.markerId);
      expect(markerMarkerIds.contains(testMarkerId), isTrue);
      var markerWidgetsMarkerIds =
          sut.markerWidgets.value.map((markerWidget) => markerWidget.markerId);
      expect(markerWidgetsMarkerIds.contains(testMarkerId), isTrue);

      sut.removeMarker(testMarkerId);

      markerMarkerIds = sut.markers.value.map((marker) => marker.markerId);
      expect(markerMarkerIds.contains(testMarkerId), isFalse);
      markerWidgetsMarkerIds =
          sut.markerWidgets.value.map((markerWidget) => markerWidget.markerId);
      expect(markerWidgetsMarkerIds.contains(testMarkerId), isFalse);
    });

    test('when marker not being tracked throws assertion error', () {
      final testId = MarkerId('test');

      expect(() {
        sut.removeMarker(testId);
      }, throwsAssertionError);
    });

    test(
        'cancels any runnign animation and removes animationController from _animationControllers',
        () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);
      //The animation controller is set after the first build of the widget...manually add for test
      final animationController = AnimationController(
          vsync: TestVSync(), duration: Duration(seconds: 10));
      sut.addMarkerAnimationController(animationController, testMarkerId);
      expect(sut.animationControllerForId(testMarkerId), isNotNull);

      sut.removeMarker(testMarkerId);
      expect(sut.animationControllerForId(testMarkerId), isNull);
    });
  });

  group('bulkRemoveMarker', () {
    test('removes marker from _markers and markers value notifier', () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);

      expect(sut.markerForId(testMarkerId), isNotNull);

      sut.bulkRemoveMarker([testMarkerId]);

      expect(sut.markerForId(testMarkerId), isNull);
    });

    test(
        'removes marker widget from _markerWidgets and markerWidgets value notifier',
        () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);

      expect(sut.markerWidgetForId(testMarkerId), isNotNull);

      sut.bulkRemoveMarker([testMarkerId]);

      expect(sut.markerWidgetForId(testMarkerId), isNull);
    });

    test(
        'removes marker from markers value notifier value and removes markerWidget from markerWidgets value notifier value',
        () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);

      var markerMarkerIds = sut.markers.value.map((marker) => marker.markerId);
      expect(markerMarkerIds.contains(testMarkerId), isTrue);
      var markerWidgetsMarkerIds =
          sut.markerWidgets.value.map((markerWidget) => markerWidget.markerId);
      expect(markerWidgetsMarkerIds.contains(testMarkerId), isTrue);

      sut.bulkRemoveMarker([testMarkerId]);

      markerMarkerIds = sut.markers.value.map((marker) => marker.markerId);
      expect(markerMarkerIds.contains(testMarkerId), isFalse);
      markerWidgetsMarkerIds =
          sut.markerWidgets.value.map((markerWidget) => markerWidget.markerId);
      expect(markerWidgetsMarkerIds.contains(testMarkerId), isFalse);
    });

    test('when marker not being tracked throws assertion error', () {
      final testId = MarkerId('test');

      expect(() {
        sut.bulkRemoveMarker([testId]);
      }, throwsAssertionError);
    });

    test(
        'cancels any runnign animation and removes animationController from _animationControllers',
        () {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);
      final testMarkerWidget = MarkerWidget(markerId: testMarkerId);
      sut.addMarkerWidget(markerWidget: testMarkerWidget, marker: testMarker);
      //The animation controller is set after the first build of the widget...manually add for test
      final animationController = AnimationController(
          vsync: TestVSync(), duration: Duration(seconds: 10));
      sut.addMarkerAnimationController(animationController, testMarkerId);
      expect(sut.animationControllerForId(testMarkerId), isNotNull);

      sut.bulkRemoveMarker([testMarkerId]);
      expect(sut.animationControllerForId(testMarkerId), isNull);
    });
  });

  group('updateMarkerImage', () {
    test('when marker not in _markers throws assertion error', () {
      final testMarkerId = MarkerId('testId');

      expect(() {
        sut.updateMarkerImage(bitmapDescriptor: null, markerId: testMarkerId);
      }, throwsAssertionError);
    });
  });

  group('updateMarker', () {
    test('when markerId not in _markers throws assertion error', () async {
      final testMarkerId = MarkerId('testId');
      final testMarker = Marker(markerId: testMarkerId);

      expect(() async {
        await sut.updateMarker(testMarker);
      }, throwsAssertionError);
    });
  });
}
