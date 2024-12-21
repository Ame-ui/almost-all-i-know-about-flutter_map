import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

class TileLayerWidget extends StatelessWidget {
  const TileLayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      // urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      urlTemplate: 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
    );
  }
}
