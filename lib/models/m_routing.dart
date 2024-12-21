import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OSMRouting {
  LatLngBounds bound;
  double distanceInMeter;
  double durationInSec;
  List<RoutingStep> steps;
  int wayPointLength;
  List<LatLng> route;

  OSMRouting(
      {required this.bound,
      required this.distanceInMeter,
      required this.durationInSec,
      required this.steps,
      required this.wayPointLength,
      required this.route});
  factory OSMRouting.fromJson(Map data) {
    final bboxList = (data['bbox'] as Iterable).toList();
    final firstSegment = ((data['features'] as Iterable).first['properties']
            ['segments'] as Iterable)
        .first;
    print(firstSegment['steps']);
    return OSMRouting(
        bound: LatLngBounds(
            LatLng(bboxList[1], bboxList[0]), LatLng(bboxList[3], bboxList[2])),
        distanceInMeter: firstSegment['distance'] ?? 0,
        durationInSec: firstSegment['duration'] ?? 0,
        steps: (firstSegment['steps'] as Iterable)
            .map(
              (e) => RoutingStep.fromJson(e),
            )
            .toList(),
        wayPointLength: ((data['features'] as Iterable).first['properties']
                    ['way_points'] as Iterable)
                .last ??
            0,
        route: ((data['features'] as Iterable).first['geometry']['coordinates']
                as Iterable)
            .map(
          (e) {
            final latlngList = (e as Iterable);
            return LatLng(latlngList.last, latlngList.first);
          },
        ).toList());
  }
}

class RoutingStep {
  double distance;
  double duration;
  String instruction;
  int startPoint;
  int endPoint;
  int type;

  RoutingStep(
      {required this.distance,
      required this.duration,
      required this.instruction,
      required this.type,
      required this.startPoint,
      required this.endPoint});

  factory RoutingStep.fromJson(Map data) {
    return RoutingStep(
      distance: data['distance'] ?? 0,
      duration: data['duration'] ?? 0,
      type: data['type'] ?? -1,
      instruction: data['instruction'] ?? '',
      startPoint: (data['way_points'] as Iterable).first ?? 0,
      endPoint: (data['way_points'] as Iterable).last ?? 0,
    );
  }
}
