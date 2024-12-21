import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/widgets/w_glassmorphic.dart';
import 'package:flutter_map_all_feature/widgets/w_tile_layer.dart';

class MapInteractivePage extends StatefulWidget {
  const MapInteractivePage({super.key});

  @override
  State<MapInteractivePage> createState() => _MapInteractivePageState();
}

class _MapInteractivePageState extends State<MapInteractivePage> {
  Map<String, int> flagList = {
    'all': InteractiveFlag.all,
    'none': InteractiveFlag.none,
    'rotate': InteractiveFlag.rotate,
    'drag': InteractiveFlag.drag,
    'pinchMove': InteractiveFlag.pinchMove,
    'pinchZoom': InteractiveFlag.pinchZoom,
    'flingAnimation': InteractiveFlag.flingAnimation,
    'doubleTapDragZoom': InteractiveFlag.doubleTapDragZoom,
    'doubleTapZoom': InteractiveFlag.doubleTapZoom,
  };
  int selectedFlag = InteractiveFlag.drag;
  MapController mapController = MapController();
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
            options: MapOptions(
              interactionOptions: InteractionOptions(
                flags: selectedFlag,
                enableMultiFingerGestureRace: true,
                debugMultiFingerGestureWinner: true,
                pinchZoomWinGestures: MultiFingerGesture.pinchZoom,
                pinchMoveWinGestures: MultiFingerGesture.pinchMove,
              ),
            ),
            children: const [
              TileLayerWidget(),
            ],
          ),
          Center(
            child: Container(
              width: 10,
              height: 10,
              color: Colors.black,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: GlassmorphicWidget(
              child: Wrap(
                spacing: 5,
                children: List.generate(
                  flagList.length,
                  (index) {
                    final int flag = flagList.values.toList()[index];
                    return ChoiceChip(
                      selected: InteractiveFlag.hasFlag(flag, selectedFlag),
                      onSelected: (value) {
                        if (value) {
                          selectedFlag = selectedFlag | flag;
                        } else {
                          selectedFlag = selectedFlag & ~flag;
                        }
                        setState(() {});
                      },
                      selectedColor: Colors.blue,
                      showCheckmark: true,
                      label: Text(
                        flagList.keys.toList()[index],
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
          )
        ],
      ),
    );
  }
}
