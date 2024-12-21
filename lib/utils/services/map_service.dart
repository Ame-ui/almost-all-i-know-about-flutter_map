import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapService {
  static void animateCameraFit(
      {required MapController mapController,
      required AnimationController? animationController,
      required LatLngBounds endBound,
      required TickerProvider vsync,
      required Duration duration,
      Curve curve = Curves.fastOutSlowIn,
      EdgeInsets padding = EdgeInsets.zero}) {
    if (animationController != null ||
        (animationController?.isAnimating ?? false)) {
      animationController!.stop();
      animationController.dispose();
    }
    final currentBound = mapController.camera.visibleBounds;

    final startSouthWest = currentBound.southWest;
    final startNorthEast = currentBound.northEast;

    final endSouthWest = endBound.southWest;
    final endNorthEast = endBound.northEast;

    final corner1LatTween = Tween<double>(
        begin: startSouthWest.latitude, end: endSouthWest.latitude);
    final corner1LngTween = Tween<double>(
        begin: startSouthWest.longitude, end: endSouthWest.longitude);

    final corner2LatTween = Tween<double>(
        begin: startNorthEast.latitude, end: endNorthEast.latitude);
    final corner2LngTween = Tween<double>(
        begin: startNorthEast.longitude, end: endNorthEast.longitude);

    final paddingTween = EdgeInsetsTween(begin: EdgeInsets.zero, end: padding);

    animationController ??= AnimationController(vsync: vsync);
    animationController.duration = duration;
    final Animation<double> animation =
        CurvedAnimation(parent: animationController, curve: curve);
    animationController.addListener(
      () {
        mapController.fitCamera(
          CameraFit.bounds(
            bounds: LatLngBounds(
              LatLng(corner1LatTween.evaluate(animation),
                  corner1LngTween.evaluate(animation)),
              LatLng(
                corner2LatTween.evaluate(animation),
                corner2LngTween.evaluate(animation),
              ),
            ),
            padding: paddingTween.evaluate(animation),
          ),
        );
      },
    );
    animationController.addStatusListener(
      (status) {
        if (status.isCompleted || status.isDismissed) {
          animationController!.dispose();
        }
      },
    );

    animationController.forward();
  }

  static void animateCamera({
    required MapController mapController,
    required AnimationController? animationController,
    required LatLng end,
    required double endZoom,
    required TickerProvider vsync,
    required Duration duration,
    double rotateDegree = 0,
    Curve curve = Curves.fastOutSlowIn,
  }) {
    if (animationController != null ||
        (animationController?.isAnimating ?? false)) {
      animationController!.stop();
      animationController.dispose();
    }
    final camera = mapController.camera;
    final latTween =
        Tween<double>(begin: camera.center.latitude, end: end.latitude);
    final lngTween =
        Tween<double>(begin: camera.center.longitude, end: end.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: endZoom);

    animationController ??= AnimationController(vsync: vsync);
    animationController.duration = duration;
    final Animation<double> animation =
        CurvedAnimation(parent: animationController, curve: curve);
    animationController.addListener(
      () {
        mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation),
        );
        mapController.rotate(rotateDegree);
      },
    );
    animationController.addStatusListener(
      (status) {
        if (status.isCompleted || status.isDismissed) {
          animationController!.dispose();
        }
      },
    );

    animationController.forward();
  }

  static List<LatLng> addMidpointsBetweenTwoLatLngs(
      LatLng start, LatLng end, int numOfMid) {
    List<LatLng> result = [];

    if (numOfMid <= 0) {
      return [start, end];
    }

    final double latDiff = (end.latitude - start.latitude) / (numOfMid + 1);
    final double lngDiff = (end.longitude - start.longitude) / (numOfMid + 1);

    result.add(start);

    // Add midpoints to the result
    for (int i = 1; i <= numOfMid; i++) {
      final double midLat = start.latitude + i * latDiff;
      final double midLng = start.longitude + i * lngDiff;
      result.add(LatLng(midLat, midLng));
    }

    // Add end point to the result
    result.add(end);

    return result;
  }

  static Stream animatePolyLine({required List<LatLng> polyline}) {
    // only needed when you want more smoother animation
    final detailsList = _adjustPolyLineForAnimation(polyline, 100);
    double duration = _interpolate(detailsList.length, 200, 1300, 100, 2600);

    duration = duration < 1000 ? 1000 : duration;
    final Stream<LatLng> stream = Stream.periodic(
      const Duration(milliseconds: 17),
      (computationCount) => detailsList[computationCount],
    ).take(detailsList.length);

    return stream;
  }

  static double _interpolate(int x, int x1, int y1, int x2, int y2) {
    return y1 + (x - x1) * (y2 - y1) / (x2 - x1);
  }

  static List<LatLng> _adjustPolyLineForAnimation(
      List<LatLng> latLngList, double distanceFilter) {
    List<LatLng> result = [];

    for (int i = 0; i < latLngList.length - 1; i++) {
      LatLng startPoint = latLngList[i];
      LatLng endPoint = latLngList[i + 1];
      double distance = Geolocator.distanceBetween(startPoint.latitude,
          startPoint.longitude, endPoint.latitude, endPoint.longitude);
      if (distance >= distanceFilter) {
        var list = MapService.addMidpointsBetweenTwoLatLngs(
            startPoint, endPoint, min((distance / 200).ceil(), 3));
        result.addAll(list);
      } else {
        result.add(endPoint);
      }
    }

    return result;
  }

  static double calculateBearing(
      double startLat, double startLng, double endLat, double endLng) {
    // Convert latitude and longitude from degrees to radians
    final lat1 = degreeToRadian(startLat);
    final lng1 = degreeToRadian(startLng);
    final lat2 = degreeToRadian(endLat);
    final lng2 = degreeToRadian(endLng);

    // Calculate the difference in longitude
    final dLng = lng2 - lng1;

    // Calculate the bearing
    final y = sin(dLng) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    final bearingRad = atan2(y, x);

    // Convert the bearing from radians to degrees
    // to keep degree between 0-360 ([degree] + 360 and % 360 )
    final bearingDeg = (radianToDegree(bearingRad) + 360) % 360;

    return bearingDeg;
  }

  static double degreeToRadian(double degree) => degree * pi / 180;

  static double radianToDegree(double radian) => radian * 180 / pi;
}
