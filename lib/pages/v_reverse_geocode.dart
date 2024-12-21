import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/utils/services/api_service.dart';
import 'package:flutter_map_all_feature/utils/services/map_service.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ReverseGeoPage extends StatefulWidget {
  const ReverseGeoPage({super.key});

  @override
  State<ReverseGeoPage> createState() => _ReverseGeoPageState();
}

class _ReverseGeoPageState extends State<ReverseGeoPage>
    with TickerProviderStateMixin {
  Timer timer = Timer(Duration.zero, () {});
  AnimationController? animationController;

  ValueNotifier<bool> xFetchingNotifier = ValueNotifier(false);
  MapController mapController = MapController();
  String address = '-';
  CancelToken? cancelToken;

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
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
                  const LatLng(16.819194804624143, 96.19101262357684),
              initialZoom: 14,
              minZoom: 12,
              maxZoom: 18,
              onMapEvent: (event) {
                if (event is MapEventMove) {
                  if (timer.isActive) {
                    timer.cancel();
                  }
                }
                if (event is MapEventMoveStart) {
                } else if (event is MapEventFlingAnimationEnd ||
                    event is MapEventFlingAnimationNotStarted) {
                  timer.cancel();
                  timer = Timer(const Duration(milliseconds: 500), () async {
                    xFetchingNotifier.value = true;
                    cancelToken?.cancel();
                    cancelToken = CancelToken();
                    address = await ApiService().getAddressByLatlng(
                            pos: mapController.camera.center,
                            cancelToken: cancelToken) ??
                        'Error';
                    setState(() {});
                    xFetchingNotifier.value = false;
                  });
                }
              },
            ),
            children: const [
              TileLayerWidget(),
            ],
          ),
          Center(
            child: Transform.translate(
              offset: const Offset(0, -45),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.red, width: 9),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    width: 3,
                    height: 15,
                  )
                ],
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        xFetchingNotifier.value = true;
                        // need permission.ACCESS_COARSE_LOCATION, permission.ACCESS_FINE_LOCATION
                        final locationPermission =
                            await Geolocator.checkPermission();
                        if (locationPermission == LocationPermission.denied) {
                          await Geolocator.requestPermission();
                        }
                        final pos = await Geolocator.getCurrentPosition(
                            locationSettings: const LocationSettings(
                                accuracy: LocationAccuracy.best));

                        MapService.animateCamera(
                          mapController: mapController,
                          animationController: animationController,
                          end: LatLng(pos.latitude, pos.longitude),
                          endZoom: mapController.camera.zoom,
                          vsync: this,
                          duration: const Duration(milliseconds: 1000),
                        );
                        address = await ApiService().getAddressByLatlng(
                                pos: mapController.camera.center) ??
                            'Error';
                        setState(() {});
                        xFetchingNotifier.value = false;
                      },
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, -4),
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 10),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(TablerIcons.current_location),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, -4),
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 10)
                      ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Address',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          10.heightBox(),
                          Text(
                            address,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          ValueListenableBuilder(
            valueListenable: xFetchingNotifier,
            builder: (BuildContext context, bool value, Widget? child) {
              return Visibility(
                visible: value,
                child: Positioned.fill(
                    child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                    ),
                  ),
                )),
              );
            },
          ),
          Positioned(
              left: 20,
              top: MediaQuery.of(context).viewPadding.top + 10,
              child: const BackKey()),
        ],
      ),
    );
  }
}
