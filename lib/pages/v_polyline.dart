import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/utils/app_constarnt.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_glassmorphic.dart';
import 'package:flutter_map_all_feature/widgets/w_label_dropdown.dart';
import 'package:flutter_map_all_feature/widgets/w_labled_color_picker.dart';
import 'package:flutter_map_all_feature/widgets/w_padding_textfield.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';
import 'package:latlong2/latlong.dart';

class PolylinePage extends StatefulWidget {
  const PolylinePage({super.key});

  @override
  State<PolylinePage> createState() => _PolylinePageState();
}

class _PolylinePageState extends State<PolylinePage> {
  List<LatLng> polylinePoints = List.from(AppConstarnt.dummyPolyline);
  Color borderColor = Colors.black;
  Color lineColor = Colors.purple;

  double borderThickness = 1;
  double lineThickness = 5;
  StrokeCap lineEnd = StrokeCap.round;

  String linePattern = 'solid';

  Map<String, StrokePattern> linePatternList = {
    'solid': const StrokePattern.solid(),
    'dashed': StrokePattern.dashed(segments: const [30, 15]),
    'dotted': const StrokePattern.dotted()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      FlutterMap(
        options: MapOptions(
          initialCameraFit: CameraFit.coordinates(
              coordinates: polylinePoints,
              padding: const EdgeInsets.symmetric(horizontal: 20)),
          initialZoom: 14,
          minZoom: 12,
          maxZoom: 18,
          onTap: (tapPosition, point) {
            setState(() {
              polylinePoints.add(point);
            });
          },
        ),
        children: [
          const TileLayerWidget(),
          PolylineLayer(
            // scale to simplify the polyline when zooming out
            simplificationTolerance: 0.4,
            polylines: [
              Polyline(
                points: polylinePoints,
                borderColor: borderColor,
                borderStrokeWidth: borderThickness,
                color: lineColor,
                strokeWidth: lineThickness,
                pattern: linePatternList[linePattern]!,
                strokeCap: lineEnd,
              ),
            ],
          ),
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
                  'Tap the map to add more point to polyline',
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
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LabledColorPicker(
                          pickerColor: lineColor,
                          onChange: (color) => setState(() {
                                lineColor = color;
                              }),
                          lable: 'Line Color'),
                    ),
                    Expanded(
                        child: PaddingTextField(
                      label: 'Line thickness',
                      onChanged: (value) {
                        setState(() {
                          lineThickness =
                              double.tryParse(value.toString()) ?? 5;
                        });
                      },
                    )),
                  ],
                ),
                5.heightBox(),
                Row(
                  children: [
                    Expanded(
                      child: LabledColorPicker(
                          pickerColor: borderColor,
                          onChange: (color) => setState(() {
                                borderColor = color;
                              }),
                          lable: 'Border Color'),
                    ),
                    Expanded(
                        child: PaddingTextField(
                      label: 'Border thickness',
                      onChanged: (value) {
                        setState(() {
                          borderThickness =
                              double.tryParse(value.toString()) ?? 5;
                        });
                      },
                    )),
                  ],
                ),
                5.heightBox(),
                LabledDropdown(
                  label: 'Line End',
                  value: lineEnd.name,
                  itemList: StrokeCap.values
                      .map(
                        (e) => e.name,
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    lineEnd = StrokeCap.values.firstWhere(
                      (element) => element.name == value,
                    );
                  }),
                ),
                5.heightBox(),
                LabledDropdown(
                  label: 'Line style',
                  value: linePattern,
                  itemList: linePatternList.keys.toList(),
                  onChanged: (value) {
                    setState(() {
                      linePattern = value!;
                    });
                  },
                )
              ],
            ),
          )))
    ]));
  }
}
