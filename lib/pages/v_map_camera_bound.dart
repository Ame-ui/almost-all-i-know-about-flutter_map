import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/utils/enums.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/utils/services/map_service.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_draggabale_marker.dart';
import 'package:flutter_map_all_feature/widgets/w_glassmorphic.dart';
import 'package:flutter_map_all_feature/widgets/w_label_dropdown.dart';
import 'package:flutter_map_all_feature/widgets/w_padding_textfield.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';
import 'package:latlong2/latlong.dart';

class MapCameraBoundPage extends StatefulWidget {
  const MapCameraBoundPage({super.key});

  @override
  State<MapCameraBoundPage> createState() => _MapCameraBoundPageState();
}

class _MapCameraBoundPageState extends State<MapCameraBoundPage>
    with TickerProviderStateMixin {
  MapController mapController = MapController();
  LatLng corner1 = const LatLng(16.842824434298527, 96.18593488738198);
  LatLng corner2 = const LatLng(16.812824434298527, 96.14593488738198);
  MoveOption cameraMoveOption = MoveOption.normal;
  PaddingOption paddingOption = PaddingOption.all;
  AnimationController? animationController;

  EdgeInsets padding = EdgeInsets.zero;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              // restrict the map to only moveable withing Yangon Region
              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(
                  // latlng bround of Yangon according to chatGPT
                  const LatLng(16.6922, 95.9890),
                  const LatLng(17.0701, 96.2632),
                ),
              ),
              interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
              initialCenter:
                  const LatLng(16.812824434298527, 96.18593488738198),
              initialCameraFit: CameraFit.bounds(
                  bounds: LatLngBounds.fromPoints([corner1, corner2]),
                  padding: const EdgeInsets.symmetric(horizontal: 20)),
              initialZoom: 13,
            ),
            children: [
              const TileLayerWidget(),

              // corner polyline
              PolylineLayer(polylines: [
                Polyline(points: [
                  corner1,
                  LatLng(corner1.latitude, corner2.longitude),
                  corner2,
                  LatLng(corner2.latitude, corner1.longitude),
                  corner1
                ], color: Colors.black, strokeWidth: 5)
              ]),

              // corner markers
              MarkerLayer(markers: [
                Marker(
                    point: corner1,
                    width: 50,
                    height: 50,
                    child: DraggableMarker(
                      lable: 'C1',
                      background: Colors.red,
                      onDragEnd: (details) {
                        setState(() {
                          corner1 = mapController.camera.pointToLatLng(Point(
                              details.offset.dx + 25, details.offset.dy + 25));
                        });
                      },
                    )),
                Marker(
                    point: corner2,
                    width: 50,
                    height: 50,
                    child: DraggableMarker(
                      lable: 'C2',
                      background: Colors.purple,
                      onDragEnd: (details) {
                        setState(() {
                          corner2 = mapController.camera.pointToLatLng(Point(
                              details.offset.dx + 25, details.offset.dy + 25));
                        });
                      },
                    ))
              ])
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      'Drag Corner markers(C1, C2) to form a bound and click "Fit"to fit the map camera to that bound',
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
              bottom: 20,
              left: 20,
              right: 20,
              child: GlassmorphicWidget(
                  child: Column(
                children: [
                  LabledDropdown(
                    label: 'Camera Move Option',
                    value: cameraMoveOption.name,
                    itemList: MoveOption.values
                        .map(
                          (e) => e.name,
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        cameraMoveOption = MoveOption.values.firstWhere(
                          (element) => element.name == value,
                        );
                      });
                    },
                  ),
                  5.heightBox(),
                  LabledDropdown(
                    label: 'Padding Option',
                    value: paddingOption.name,
                    itemList: PaddingOption.values
                        .map(
                          (e) => e.name,
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        padding = EdgeInsets.zero;
                        paddingOption = PaddingOption.values.firstWhere(
                          (element) => element.name == value,
                        );
                      });
                    },
                  ),
                  5.heightBox(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        if (paddingOption == PaddingOption.all)
                          Row(
                            children: List.generate(
                              1,
                              (index) => Expanded(
                                  child: PaddingTextField(
                                key: const ValueKey('all'),
                                label: 'All',
                                onChanged: (value) {
                                  padding = EdgeInsets.all(
                                      double.tryParse(value.toString()) ?? 0);
                                },
                              )),
                            ),
                          ),
                        if (paddingOption == PaddingOption.symmetric)
                          Row(
                            children: List.generate(
                                2,
                                (index) => Expanded(
                                      child: PaddingTextField(
                                        key: ValueKey('symmetric$index'),
                                        label: index == 0
                                            ? 'horizontal'
                                            : 'vertical',
                                        onChanged: (value) {
                                          if (index == 0) {
                                            padding = EdgeInsets.symmetric(
                                                horizontal: double.tryParse(
                                                        value.toString()) ??
                                                    0,
                                                vertical: padding.vertical);
                                          } else {
                                            padding = EdgeInsets.symmetric(
                                                horizontal: padding.horizontal,
                                                vertical: double.tryParse(
                                                        value.toString()) ??
                                                    0);
                                          }
                                        },
                                      ),
                                    )),
                          ),
                        if (paddingOption == PaddingOption.only)
                          Row(
                            children: List.generate(
                                4,
                                (index) => Expanded(
                                      child: PaddingTextField(
                                        key: ValueKey('only$index'),
                                        label: index == 0
                                            ? 'L'
                                            : index == 1
                                                ? 'R'
                                                : index == 2
                                                    ? 'T'
                                                    : 'B',
                                        onChanged: (value) {
                                          switch (index) {
                                            case 0:
                                              padding = EdgeInsets.only(
                                                  left: double.tryParse(
                                                          value.toString()) ??
                                                      0,
                                                  right: padding.right,
                                                  top: padding.top,
                                                  bottom: padding.bottom);
                                              break;
                                            case 1:
                                              padding = EdgeInsets.only(
                                                  left: padding.left,
                                                  right: double.tryParse(
                                                          value.toString()) ??
                                                      0,
                                                  top: padding.top,
                                                  bottom: padding.bottom);
                                              break;
                                            case 2:
                                              padding = EdgeInsets.only(
                                                  left: padding.left,
                                                  right: padding.right,
                                                  top: double.tryParse(
                                                          value.toString()) ??
                                                      0,
                                                  bottom: padding.bottom);
                                              break;
                                            case 3:
                                              padding = EdgeInsets.only(
                                                  left: padding.left,
                                                  right: padding.right,
                                                  top: padding.top,
                                                  bottom: double.tryParse(
                                                          value.toString()) ??
                                                      0);
                                              break;
                                            default:
                                              padding = EdgeInsets.zero;
                                          }
                                        },
                                      ),
                                    )),
                          )
                      ],
                    ),
                  ),
                  10.heightBox(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        switch (cameraMoveOption) {
                          case MoveOption.normal:
                            mapController.fitCamera(
                              CameraFit.bounds(
                                  bounds: LatLngBounds(corner1, corner2),
                                  padding: padding),
                            );
                            break;
                          case MoveOption.animation:
                            MapService.animateCameraFit(
                                mapController: mapController,
                                animationController: animationController,
                                endBound: LatLngBounds(corner1, corner2),
                                vsync: this,
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.fastOutSlowIn,
                                padding: padding);
                            break;
                        }
                      },
                      child: const Text(
                        'Fit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ))),
        ],
      ),
    );
  }
}
