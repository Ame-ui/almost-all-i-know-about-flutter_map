import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/utils/enums.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_custom_marker.dart';
import 'package:flutter_map_all_feature/widgets/w_glassmorphic.dart';
import 'package:flutter_map_all_feature/widgets/w_label_dropdown.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';
import 'package:latlong2/latlong.dart';

class MarkerPage extends StatefulWidget {
  const MarkerPage({super.key});

  @override
  State<MarkerPage> createState() => _MarkerPageState();
}

class _MarkerPageState extends State<MarkerPage> {
  List<LatLng> markerList = [
    const LatLng(16.812824434298527, 96.18593488738198)
  ];
  LatLng selectedMarker = const LatLng(0, 0);
  MarkerOption markerOption = MarkerOption.add;
  String markerAlignment = 'center';
  bool xRotate = true;

  final Map<String, Alignment> _alignments = {
    'topLeft': Alignment.topLeft,
    'bottomLeft': Alignment.bottomLeft,
    'centerLeft': Alignment.centerLeft,
    'topRight': Alignment.topRight,
    'bottomRight': Alignment.bottomRight,
    'centerRight': Alignment.centerRight,
    'topCenter': Alignment.topCenter,
    'bottomCenter': Alignment.bottomCenter,
    'center': Alignment.center
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter:
                  const LatLng(16.812824434298527, 96.18593488738198),
              initialZoom: 15,
              minZoom: 12,
              maxZoom: 18,
              onTap: (tapPosition, point) {
                switch (markerOption) {
                  case MarkerOption.update:
                    markerList[markerList.indexOf(selectedMarker)] = point;
                    selectedMarker = point;
                    break;

                  case MarkerOption.add:
                    markerList.add(point);

                    break;
                  default:
                }
                setState(() {});
              },
            ),
            children: [
              const TileLayerWidget(),

              MarkerLayer(
                markers: markerList
                    .map(
                      (e) => Marker(
                        point: e,
                        width: 50,
                        height: 50,
                        alignment: _alignments[markerAlignment],
                        rotate: xRotate,
                        child: CustomMarker(
                          xSelected: selectedMarker == e,
                          onTap: () {
                            switch (markerOption) {
                              case MarkerOption.update:
                                if (selectedMarker == e) {
                                  selectedMarker = const LatLng(0, 0);
                                } else {
                                  selectedMarker = e;
                                }
                                break;
                              case MarkerOption.remove:
                                markerList.remove(e);
                                break;
                              default:
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
              // add dot to indicate the center of each marker to show alignment
              MarkerLayer(
                  markers: markerList
                      .map(
                        (e) => Marker(
                            width: 5,
                            height: 5,
                            point: e,
                            alignment: Alignment.center,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(color: Colors.white)),
                            )),
                      )
                      .toList()),
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
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    markerOption == MarkerOption.add
                        ? 'Tap on map to move marker'
                        : markerOption == MarkerOption.update
                            ? 'Tap the marker you want to update'
                            : 'Tap the marker you want to remove',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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
                  child: Column(
                children: [
                  LabledDropdown(
                    label: 'Marker Option',
                    value: markerOption.name,
                    itemList: MarkerOption.values
                        .map(
                          (e) => e.name,
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        markerOption = MarkerOption.values.firstWhere(
                          (element) => element.name == value,
                        );
                      });
                      if (markerOption == MarkerOption.update) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(
                            'Now the map to update the selected marker',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ));
                      }
                    },
                  ),
                  10.heightBox(),
                  LabledDropdown(
                    label: 'Marker Alignment',
                    value: markerAlignment,
                    itemList: _alignments.keys
                        .map(
                          (e) => e,
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        markerAlignment = value!;
                      });
                    },
                  ),
                  20.heightBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rotate marker',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        value: xRotate,
                        onChanged: (value) {
                          setState(() {
                            xRotate = value;
                          });
                        },
                      )
                    ],
                  )
                ],
              )))
        ],
      ),
    );
  }
}
