import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_glassmorphic.dart';
import 'package:flutter_map_all_feature/widgets/w_label_dropdown.dart';
import 'package:flutter_map_all_feature/widgets/w_labled_color_picker.dart';
import 'package:flutter_map_all_feature/widgets/w_padding_textfield.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';
import 'package:latlong2/latlong.dart';

class PolygonPage extends StatefulWidget {
  const PolygonPage({super.key});

  @override
  State<PolygonPage> createState() => _PolygonPageState();
}

class _PolygonPageState extends State<PolygonPage> {
  List<LatLng> polygonPoint = [
    const LatLng(16.819194804624143, 96.19101262357684),
    const LatLng(16.815761390163278, 96.18986957167036),
    const LatLng(16.818477943005206, 96.19446148708776)
  ];
  Color borderColor = Colors.purple;
  Color polygonColor = Colors.purple;

  double borderThickness = 5;
  double colorOpacity = 0.3;
  StrokeCap lineEnd = StrokeCap.round;

  String linePattern = 'dotted';

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
          initialCenter: LatLng(16.819194804624143, 96.19101262357684),
          // initialCameraFit: const CameraFit.coordinates(coordinates: [
          //   LatLng(16.819194804624143, 96.19101262357684),
          //   LatLng(16.815761390163278, 96.18986957167036),
          // ], padding: EdgeInsets.symmetric(horizontal: 20)),
          initialZoom: 14,
          minZoom: 12,
          maxZoom: 18,
          onTap: (tapPosition, point) {
            setState(() {
              polygonPoint.add(point);
            });
          },
        ),
        children: [
          const TileLayerWidget(),
          PolygonLayer(
            // scale to simplify the Polygon when zooming out
            simplificationTolerance: 0.4,
            polygons: [
              Polygon(
                  points: polygonPoint,
                  borderColor: borderColor,
                  borderStrokeWidth: borderThickness,
                  color: polygonColor.withOpacity(colorOpacity),
                  pattern: linePatternList[linePattern]!,
                  strokeCap: lineEnd,
                  label: 'Poly Zone',
                  labelPlacement: PolygonLabelPlacement.polylabel,
                  rotateLabel: true,
                  labelStyle: TextStyle(
                      color: borderColor, fontWeight: FontWeight.bold)),
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
                  'Tap the map to add to add points to polygon ',
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
                          pickerColor: polygonColor,
                          onChange: (color) => setState(() {
                                polygonColor = color;
                              }),
                          lable: 'Line Color'),
                    ),
                    Expanded(
                        child: PaddingTextField(
                      label: 'Line thickness(0-100)',
                      onChanged: (value) {
                        setState(() {
                          colorOpacity = min(
                              (double.tryParse(value.toString()) ?? 30).abs() /
                                  100,
                              1);
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
