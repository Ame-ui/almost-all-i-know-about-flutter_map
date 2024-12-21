import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/utils/enums.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_glassmorphic.dart';
import 'package:flutter_map_all_feature/widgets/w_label_dropdown.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';
import 'package:latlong2/latlong.dart';

class AnimateMarkerPage extends StatefulWidget {
  const AnimateMarkerPage({super.key});

  @override
  State<AnimateMarkerPage> createState() => _AnimateMarkerPageState();
}

class _AnimateMarkerPageState extends State<AnimateMarkerPage>
    with TickerProviderStateMixin {
  ValueNotifier<LatLng> animatedMarkerPos =
      ValueNotifier(const LatLng(16.812824434298527, 96.18593488738198));
  AnimationController? animationController;
  MoveOption markerMoveOption = MoveOption.normal;
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
                switch (markerMoveOption) {
                  case MoveOption.normal:
                    animatedMarkerPos.value = point;
                    break;
                  case MoveOption.animation:
                    if (animationController?.isAnimating ?? false) {
                      animationController?.stop();
                    }
                    animationController = AnimationController(
                        vsync: this,
                        duration: const Duration(milliseconds: 1000));
                    final latTween = Tween<double>(
                        begin: animatedMarkerPos.value.latitude,
                        end: point.latitude);
                    final lngTween = Tween<double>(
                        begin: animatedMarkerPos.value.longitude,
                        end: point.longitude);

                    final Animation<double> animation = CurvedAnimation(
                        parent: animationController!,
                        curve: Curves.fastOutSlowIn);
                    animationController!.addListener(
                      () {
                        animatedMarkerPos.value = LatLng(
                            latTween.evaluate(animation),
                            lngTween.evaluate(animation));
                      },
                    );
                    animationController!.addStatusListener(
                      (status) {
                        if (status.isCompleted || status.isDismissed) {
                          animationController!.dispose();
                        }
                      },
                    );

                    animationController!.forward();
                    break;
                }
              },
            ),
            children: [
              const TileLayerWidget(),
              ValueListenableBuilder(
                valueListenable: animatedMarkerPos,
                builder: (BuildContext context, LatLng value, Widget? child) {
                  return MarkerLayer(markers: [
                    Marker(
                      width: 50,
                      height: 50,
                      alignment: Alignment.topCenter,
                      point: value,
                      child: const Icon(
                        Icons.location_pin,
                        size: 50,
                      ),
                    )
                  ]);
                },
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
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Tap on map to move marker',
                    style: TextStyle(
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
                  child: LabledDropdown(
                label: 'Marker Move Option',
                value: markerMoveOption.name,
                itemList: MoveOption.values
                    .map(
                      (e) => e.name,
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    markerMoveOption = MoveOption.values.firstWhere(
                      (element) => element.name == value,
                    );
                  });
                },
              )))
        ],
      ),
    );
  }
}
