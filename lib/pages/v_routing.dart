import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/models/m_routing.dart';

import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/utils/services/api_service.dart';
import 'package:flutter_map_all_feature/utils/services/map_service.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_draggabale_marker.dart';
import 'package:flutter_map_all_feature/widgets/w_glassmorphic.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:latlong2/latlong.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({super.key});

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage>
    with TickerProviderStateMixin {
  LatLng to = const LatLng(16.842824434298527, 96.18593488738198);
  LatLng from = const LatLng(16.812824434298527, 96.14593488738198);
  MapController mapController = MapController();
  OSMRouting? routing;
  StreamSubscription? polyLineStream;
  ValueNotifier<List<LatLng>> animatedLine = ValueNotifier([]);
  AnimationController? animationController;
  bool xFetching = false;

  @override
  void dispose() {
    mapController.dispose();
    polyLineStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCameraFit: CameraFit.bounds(
                    bounds: LatLngBounds.fromPoints([from, to]),
                    padding: const EdgeInsets.symmetric(horizontal: 20)),
                initialZoom: 14,
                minZoom: 0,
                maxZoom: 18,
              ),
              children: [
                const TileLayerWidget(),
                if (routing != null)
                  ValueListenableBuilder(
                    valueListenable: animatedLine,
                    builder: (BuildContext context, List<LatLng> value,
                        Widget? child) {
                      return PolylineLayer(polylines: [
                        Polyline(
                          points: value,
                          color: Colors.black,
                          strokeWidth: 7,
                        ),
                      ]);
                    },
                  ),
                if (routing != null)
                  MarkerLayer(
                      markers: routing!.steps.map(
                    (e) {
                      return Marker(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        point: routing!.route[e.startPoint],
                        rotate: false,
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.instruction,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                duration: const Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all()),
                            child: const Icon(
                              TablerIcons.directions,
                              size: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList()),
                MarkerLayer(markers: [
                  Marker(
                    point: from,
                    width: 35,
                    height: 35,
                    rotate: true,
                    child: DraggableMarker(
                      lable: 'P1',
                      background: Colors.red,
                      onDragEnd: (details) {
                        setState(() {
                          from = mapController.camera.pointToLatLng(Point(
                              details.offset.dx + 25, details.offset.dy + 25));
                        });
                      },
                    ),
                  ),
                  Marker(
                    point: to,
                    width: 35,
                    height: 35,
                    rotate: true,
                    child: DraggableMarker(
                      lable: 'P2',
                      background: Colors.purple,
                      onDragEnd: (details) {
                        setState(() {
                          to = mapController.camera.pointToLatLng(Point(
                              details.offset.dx + 25, details.offset.dy + 25));
                        });
                      },
                    ),
                  )
                ])
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).viewPadding.top + 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackKey(),
                10.widthBox(),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Drag markers to anywhere as you wish and click "Navigate" to draw route from P1 to P2, and "Start" to ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ))
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: GlassmorphicWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            xFetching = true;
                          });
                          routing =
                              await ApiService().getRouting(from: from, to: to);

                          setState(() {
                            xFetching = false;
                          });
                          if (routing == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Error getting route',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ));
                          } else {
                            // mapController.fitCamera(CameraFit.bounds(
                            //     bounds: mapController.camera.visibleBounds,
                            //     padding: EdgeInsets.zero));
                            MapService.animateCameraFit(
                                mapController: mapController,
                                animationController: animationController,
                                endBound: routing!.bound,
                                padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: MediaQuery.of(context)
                                            .size
                                            .height) *
                                    0.25,
                                vsync: this,
                                duration: const Duration(milliseconds: 1000));
                            animatePolyLine(routing!.route);
                          }
                        },
                        child: const Text(
                          'Navigate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    10.widthBox(),
                    // Expanded(
                    //   child: ElevatedButton(
                    //     onPressed: (xFetching ||
                    //             (routing?.route.isEmpty ?? true))
                    //         ? null
                    //         : () {
                    //             MapService.animateCamera(
                    //               mapController: mapController,
                    //               animationController: animationController,
                    //               end: routing!.route.first,
                    //               endZoom: 17,
                    //               vsync: this,
                    //               rotateDegree: 360 -
                    //                   MapService.calculateBearing(
                    //                       routing!
                    //                           .route[
                    //                               routing!.steps[1].startPoint]
                    //                           .latitude,
                    //                       routing!
                    //                           .route[
                    //                               routing!.steps[1].startPoint]
                    //                           .longitude,
                    //                       routing!
                    //                           .route[
                    //                               routing!.steps[2].startPoint]
                    //                           .latitude,
                    //                       routing!
                    //                           .route[
                    //                               routing!.steps[2].startPoint]
                    //                           .longitude),
                    //               duration: const Duration(milliseconds: 500),
                    //             );
                    //           },
                    //     child: const Text(
                    //       'Start',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
          if (xFetching)
            Positioned.fill(
                child: Container(
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: const CupertinoActivityIndicator(
                  color: Colors.blue,
                ),
              ),
            ))
        ],
      ),
    );
  }

  void animatePolyLine(List<LatLng> polyline) {
    polyLineStream?.cancel();
    animatedLine.value = [];
    final Stream stream = MapService.animatePolyLine(polyline: polyline);
    polyLineStream = stream.listen((event) {
      final List<LatLng> temp = List.from(animatedLine.value);
      temp.add(event);
      animatedLine.value = temp;
    });
  }
}
