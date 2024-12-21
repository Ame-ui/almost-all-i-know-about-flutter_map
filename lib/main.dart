import 'package:flutter/material.dart';
import 'package:flutter_map_all_feature/pages/v_animate_polyline.dart';
import 'package:flutter_map_all_feature/pages/v_current_location.dart';
import 'package:flutter_map_all_feature/pages/v_map_camera_bound.dart';
import 'package:flutter_map_all_feature/pages/v_map_camera_latlng.dart';
import 'package:flutter_map_all_feature/pages/v_map_interactive_flag.dart';
import 'package:flutter_map_all_feature/pages/v_map_tile_layer.dart';
import 'package:flutter_map_all_feature/pages/v_animate_markers.dart';
import 'package:flutter_map_all_feature/pages/v_marker.dart';
import 'package:flutter_map_all_feature/pages/v_polygon.dart';
import 'package:flutter_map_all_feature/pages/v_polyline.dart';
import 'package:flutter_map_all_feature/pages/v_reverse_geocode.dart';
import 'package:flutter_map_all_feature/pages/v_routing.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(useMaterial3: false), home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Map<IconData, Widget> pagelist = {
    TablerIcons.map: const TileLayerPage(),
    Icons.pinch: const MapInteractivePage(),
    TablerIcons.map_pin: const MarkerPage(),
    TablerIcons.map_pin_x: const AnimateMarkerPage(),
    TablerIcons.route_2: const PolylinePage(),
    TablerIcons.route_x_2: const AnimatedPolylinePage(),
    TablerIcons.pentagon: const PolygonPage(),
    TablerIcons.focus_centered: const MapCameraLatlngPage(),
    TablerIcons.photo_sensor: const MapCameraBoundPage(),
    TablerIcons.map_pin_search: const ReverseGeoPage(),
    TablerIcons.route: const RoutingPage(),
    TablerIcons.location: const CurrentLocationPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
          child: Column(
        children: [
          SizedBox(
            height: (MediaQuery.of(context).viewPadding.top),
          ),
          Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  Widget page = pagelist.values.toList()[index];
                  IconData icon = pagelist.keys.toList()[index];
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => page,
                      ));
                    },
                    child: Row(
                      children: [
                        40.widthBox(),
                        Icon(
                          icon,
                          color: Colors.white,
                        ),
                        20.widthBox(),
                        Text(
                          page.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: pagelist.values.length),
          ),
        ],
      )),
    );
  }
}
