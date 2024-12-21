import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/utils/app_constarnt.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/utils/services/map_service.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_glassmorphic.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';

import 'package:latlong2/latlong.dart';

class AnimatedPolylinePage extends StatefulWidget {
  const AnimatedPolylinePage({super.key});

  @override
  State<AnimatedPolylinePage> createState() => _AnimatedPolylinePageState();
}

class _AnimatedPolylinePageState extends State<AnimatedPolylinePage> {
  final List<LatLng> _polyline = List.from(AppConstarnt.dummyPolyline);
  ValueNotifier<List<LatLng>> animatedLine = ValueNotifier([]);

  StreamSubscription? polyLineStream;

  @override
  void initState() {
    animatedLine.value = _polyline;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      FlutterMap(
        options: MapOptions(
          initialCameraFit: CameraFit.coordinates(
              coordinates: _polyline,
              padding: const EdgeInsets.symmetric(horizontal: 20)),
          initialZoom: 14,
          minZoom: 12,
          maxZoom: 18,
          onTap: (tapPosition, point) {
            setState(() {
              _polyline.add(point);
              animatedLine.value = _polyline;
            });
          },
        ),
        children: [
          const TileLayerWidget(),
          ValueListenableBuilder(
            valueListenable: animatedLine,
            builder: (BuildContext context, List<LatLng> value, Widget? child) {
              return PolylineLayer(
                // scale to simplify the polyline when zooming out
                simplificationTolerance: 0.4,
                polylines: [
                  Polyline(
                    points: value,
                    borderColor: Colors.black.withOpacity(0.5),
                    color: Colors.purple,
                    // gradientColors: [
                    // Colors.red,
                    // Colors.orange,
                    // Colors.yellow,
                    // Colors.green,
                    // Colors.blue,
                    // Colors.purple,
                    // Colors.pink
                    // ],
                    strokeWidth: 7,
                  ),
                ],
              );
            },
          ),
          // ValueListenableBuilder(
          //   valueListenable: animatedLine,
          //   builder: (BuildContext context, List<LatLng> value, Widget? child) {
          //     return MarkerLayer(
          //         markers: value
          //             .map(
          //               (e) => Marker(
          //                 point: e,
          //                 child: Text(
          //                   '${value.indexOf(e)}',
          //                   style: TextStyle(
          //                     color: Colors.black.withOpacity(0.5),
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.w600,
          //                   ),
          //                 ),
          //               ),
          //             )
          //             .toList());
          //   },
          // ),
        ],
      ),
      Positioned(
          left: 20,
          right: 20,
          top: MediaQuery.of(context).viewPadding.top + 10,
          child: Row(
            children: [
              const BackKey(),
              10.widthBox(),
              Expanded(
                  child: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  'Click "Animate" to animate the polyline from start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ))
            ],
          )),
      Positioned(
        left: 20,
        right: 20,
        bottom: 20,
        child: GlassmorphicWidget(
          child: Column(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(
                        Size(MediaQuery.of(context).size.width, 50))),
                onPressed: () {
                  animatePolyLine();
                },
                child: const Text(
                  'Animate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]));
  }

  void animatePolyLine() {
    polyLineStream?.cancel();
    animatedLine.value = [];
    final Stream stream = MapService.animatePolyLine(polyline: _polyline);
    polyLineStream = stream.listen((event) {
      final List<LatLng> temp = List.from(animatedLine.value);
      temp.add(event);
      animatedLine.value = temp;
    });
  }
}
