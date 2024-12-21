import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/utils/services/map_service.dart';
import 'package:flutter_map_all_feature/utils/enums.dart';

import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_glassmorphic.dart';
import 'package:flutter_map_all_feature/widgets/w_label_dropdown.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';
import 'package:latlong2/latlong.dart';

class MapCameraLatlngPage extends StatefulWidget {
  const MapCameraLatlngPage({super.key});

  @override
  State<MapCameraLatlngPage> createState() => _MapCameraLatlngPageState();
}

class _MapCameraLatlngPageState extends State<MapCameraLatlngPage>
    with TickerProviderStateMixin {
  MapController mapController = MapController();
  MoveOption cameraMoveOption = MoveOption.normal;
  ValueNotifier<List<String>> mapEvent = ValueNotifier([]);
  ValueNotifier<bool> xEveneListExpand = ValueNotifier(false);
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
  }

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
              initialCenter:
                  const LatLng(16.812824434298527, 96.18593488738198),
              initialZoom: 15,
              minZoom: 12,
              maxZoom: 18,
              onMapEvent: (mapE) {
                final List<String> list = List.from(mapEvent.value);
                final newE = mapE.toString().replaceAll('Instance of ', '');
                if (list.isNotEmpty) {
                  if (!(list.last == newE)) {
                    list.add(newE);
                  }
                } else {
                  list.add(newE);
                }
                mapEvent.value = list;
              },
              onTap: (tapPosition, point) {
                switch (cameraMoveOption) {
                  case MoveOption.normal:
                    mapController.move(point, mapController.camera.zoom);
                    break;
                  case MoveOption.animation:
                    MapService.animateCamera(
                        mapController: mapController,
                        animationController: animationController,
                        end: point,
                        endZoom: mapController.camera.zoom,
                        vsync: this,
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.fastOutSlowIn);
                    break;
                }
              },
            ),
            children: const [
              TileLayerWidget(),
            ],
          ),
          Positioned(
              right: 20,
              left: 20,
              bottom: 20,
              child: GlassmorphicWidget(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ValueListenableBuilder(
                        valueListenable: xEveneListExpand,
                        builder: (BuildContext context, bool xExpand,
                            Widget? child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Map Event',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              5.widthBox(),
                              xExpand
                                  ? Expanded(
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        color: Colors.white.withOpacity(0.5),
                                        child: ValueListenableBuilder(
                                          valueListenable: mapEvent,
                                          builder: (BuildContext context,
                                              List<String> value,
                                              Widget? child) {
                                            final reservedList =
                                                value.reversed.toList();
                                            return ListView.builder(
                                              reverse: true,
                                              itemCount: reservedList.length,
                                              itemBuilder: (context, index) =>
                                                  Text(
                                                reservedList[index],
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: ValueListenableBuilder(
                                          valueListenable: mapEvent,
                                          builder: (BuildContext context,
                                              List<String> value,
                                              Widget? child) {
                                            return FittedBox(
                                              child: Text(
                                                value.isEmpty
                                                    ? '-'
                                                    : value.last,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                              Column(
                                children: [
                                  if (xExpand)
                                    IconButton(
                                        onPressed: () {
                                          mapEvent.value = [];
                                        },
                                        icon: const Icon(Icons.clear)),
                                  IconButton(
                                    icon: Icon(xExpand
                                        ? Icons.arrow_downward
                                        : Icons.list),
                                    onPressed: () {
                                      xEveneListExpand.value =
                                          !xEveneListExpand.value;
                                    },
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),
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
                  ],
                ),
              )),
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
                      'Tap on map to move camera',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ))
                ],
              )),
          const Center(
              child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 5,
          ))
        ],
      ),
    );
  }
}
