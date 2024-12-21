import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class CurrentLocationPage extends StatefulWidget {
  const CurrentLocationPage({super.key});

  @override
  State<CurrentLocationPage> createState() => _CurrentLocationPageState();
}

class _CurrentLocationPageState extends State<CurrentLocationPage> {
  StreamSubscription? locationStream;
  ValueNotifier<LatLng> currentLocation = ValueNotifier(const LatLng(0, 0));
  MapController mapController = MapController();
  bool xGrant = false;
  bool xGetCurrentLocation = false;
  @override
  void initState() {
    gettingCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    locationStream?.cancel();
    mapController.dispose();
    super.dispose();
  }

  void gettingCurrentLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      final result = await Geolocator.requestPermission();
      // if result is LocationPermission.deniedForever
      // you should use  AppSettings.openAppSettings(); with app_settings package
      if (result == LocationPermission.whileInUse ||
          result == LocationPermission.always) {
        setState(() {
          xGrant = true;
        });
      }
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        locationStream = Geolocator.getPositionStream().listen(
          (event) {
            final newLocation = LatLng(event.latitude, event.longitude);
            if (currentLocation.value.latitude == 0) {
              mapController.move(newLocation, 16);
              setState(() {
                xGetCurrentLocation = true;
              });
            }
            currentLocation.value = newLocation;
            // to add compass heading use flutter_compass and just rotate the marker
          },
        );
      },
    );
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
              initialZoom: 14,
              minZoom: 0,
              maxZoom: 18,
            ),
            children: [
              TileLayerWidget(),
              ValueListenableBuilder(
                valueListenable: currentLocation,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return MarkerLayer(markers: [
                    Marker(
                        width: 25,
                        height: 25,
                        point: value,
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 7),
                          ),
                        ))
                  ]);
                },
              ),
            ],
          ),
          if (!xGetCurrentLocation)
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
            )),
          Positioned(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).viewPadding.top + 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackKey(),
                10.widthBox(),
                if (!xGrant)
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      'Please allow location permission',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ))
              ],
            ),
          ),
          // Positioned(
          //   left: 20,
          //   right: 20,
          //   bottom: 20,
          //   child: GlassmorphicWidget(
          //     child: Text(
          //       '',
          //       style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
