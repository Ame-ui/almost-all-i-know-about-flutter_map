import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_all_feature/utils/extensions.dart';
import 'package:flutter_map_all_feature/widgets/w_back_key.dart';
import 'package:flutter_map_all_feature/widgets/w_glassmorphic.dart';
import 'package:flutter_map_all_feature/widgets/w_label_dropdown.dart';

enum TileLayerMode { normal, fallback, cache }

class TileLayerPage extends StatefulWidget {
  const TileLayerPage({super.key});

  @override
  State<TileLayerPage> createState() => _TileLayerPageState();
}

class _TileLayerPageState extends State<TileLayerPage> {
  String mapUrl = '';
  TileLayerMode tileLayerMode = TileLayerMode.normal;
  final Map<String, String> mapList = {
    'OSM': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    'OpenTopoMap': 'https://a.tile.opentopomap.org/{z}/{x}/{y}.png',
    'CartoDB(Light)':
        'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
    'CartoDB(Dark)': 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
  };

  @override
  void initState() {
    mapUrl = mapList.entries.first.key;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(children: [
            // ===== normal base tile layer =====
            if (tileLayerMode == TileLayerMode.normal)
              TileLayer(urlTemplate: mapList[mapUrl]),

            // ===== tile layer with fallback url =====
            if (tileLayerMode == TileLayerMode.fallback)
              TileLayer(
                urlTemplate: 'https://invalid-map-url',
                fallbackUrl:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // fallback as osm tile
              ),

            // ===== cache map tiles with [cached_network_image] =====
            if (tileLayerMode == TileLayerMode.cache)
              TileLayer(
                  urlTemplate: mapList[mapUrl],
                  tileBuilder: (context, tileWidget, tile) {
                    String cacheImageTile = mapUrl;

                    cacheImageTile = cacheImageTile.replaceFirst(
                        "{z}", "${tile.coordinates.z}");
                    cacheImageTile = cacheImageTile.replaceFirst(
                        "{x}", "${tile.coordinates.x}");

                    cacheImageTile = cacheImageTile.replaceFirst(
                        "{y}", "${tile.coordinates.y}");
                    return FittedBox(
                      child: CachedNetworkImage(
                        imageUrl: cacheImageTile,
                        placeholder: (context, url) {
                          return Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.all(20),
                              child: const Opacity(
                                  opacity: 0.3,
                                  child: CupertinoActivityIndicator(
                                    color: Colors.blue,
                                  )));
                        },
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                      ),
                    );
                  })
          ]),
          Positioned(
              left: 20,
              top: MediaQuery.of(context).viewPadding.top + 10,
              child: const BackKey()),
          Positioned(
            right: 10,
            bottom: 20,
            left: 10,
            child: GlassmorphicWidget(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LabledDropdown(
                    label: 'Map Tile Layer',
                    value: mapUrl,
                    itemList: mapList.entries
                        .map(
                          (e) => e.key,
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => mapUrl = value!);
                    },
                  ),
                  10.heightBox(),
                  LabledDropdown(
                    label: 'Layer Mode',
                    value: tileLayerMode.name,
                    itemList: TileLayerMode.values
                        .map(
                          (e) => e.name,
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(
                          () => tileLayerMode = TileLayerMode.values.firstWhere(
                                (element) => element.name == value,
                              ));
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
