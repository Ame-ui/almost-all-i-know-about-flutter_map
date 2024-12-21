import 'package:latlong2/latlong.dart';

class AppConstarnt {
  static const List<LatLng> dummyPolyline = [
    LatLng(16.815799, 96.189821),
    LatLng(16.815902, 96.189734),
    LatLng(16.81641, 96.189253),
    LatLng(16.817182, 96.188481),
    LatLng(16.817569, 96.188021),
    LatLng(16.818514, 96.186757),
    LatLng(16.818647, 96.186571),
    LatLng(16.819226, 96.185759),
    LatLng(16.819737, 96.185074),
    LatLng(16.820223, 96.184429),
    LatLng(16.820638, 96.183938),
    LatLng(16.821955, 96.182573),
    LatLng(16.822062, 96.182553),
    LatLng(16.822313, 96.182603),
    LatLng(16.822632, 96.18285),
    LatLng(16.822832, 96.183082),
    LatLng(16.82296, 96.183265),
    LatLng(16.823321, 96.183818),
    LatLng(16.823635, 96.184366),
    LatLng(16.823787, 96.184611),
    LatLng(16.823954, 96.184757),
    LatLng(16.82441, 96.185088),
    LatLng(16.824994, 96.185564),
    LatLng(16.825152, 96.185692),
    LatLng(16.826052, 96.186432),
    LatLng(16.826551, 96.186833),
    LatLng(16.826863, 96.18709),
    LatLng(16.8272, 96.187378),
    LatLng(16.827601, 96.187708),
    LatLng(16.82783, 96.187961),
    LatLng(16.82789, 96.188057),
    LatLng(16.828164, 96.188495),
    LatLng(16.828457, 96.189097),
    LatLng(16.828766, 96.189749),
    LatLng(16.828882, 96.189977),
    LatLng(16.829054, 96.190335),
    LatLng(16.829072, 96.190373),
    LatLng(16.829523, 96.191402),
    LatLng(16.829788, 96.191942),
    LatLng(16.829899, 96.192167),
    LatLng(16.830188, 96.192547),
    LatLng(16.830278, 96.192647),
    LatLng(16.830698, 96.193081),
    LatLng(16.830892, 96.193281),
    LatLng(16.831282, 96.193672),
    LatLng(16.831584, 96.193962),
    LatLng(16.831771, 96.194142),
    LatLng(16.83239, 96.194771),
    LatLng(16.83286, 96.19524),
    LatLng(16.833074, 96.195462),
    LatLng(16.833417, 96.195815),
    LatLng(16.83367, 96.196068),
    LatLng(16.833851, 96.19625),
    LatLng(16.834765, 96.197185),
    LatLng(16.834854, 96.197276),
    LatLng(16.835556, 96.197995),
    LatLng(16.835671, 96.198126),
    LatLng(16.8359, 96.198367),
    LatLng(16.836106, 96.198578),
    LatLng(16.836425, 96.198899),
    LatLng(16.836548, 96.199023),
    LatLng(16.83684, 96.199317),
    LatLng(16.837176, 96.199655),
    LatLng(16.837636, 96.20016),
    LatLng(16.837987, 96.200531),
    LatLng(16.838717, 96.201281),
    LatLng(16.839394, 96.201976),
    LatLng(16.839443, 96.202028),
    LatLng(16.840172, 96.202758),
    LatLng(16.840297, 96.202884),
    LatLng(16.840583, 96.203177),
    LatLng(16.84085, 96.203453),
    LatLng(16.841714, 96.204361),
    LatLng(16.842277, 96.204953),
    LatLng(16.842351, 96.205024),
    LatLng(16.842434, 96.205108),
    LatLng(16.842572, 96.205261),
    LatLng(16.842685, 96.205435),
    LatLng(16.842708, 96.205564),
    LatLng(16.842698, 96.205683),
    LatLng(16.8423, 96.207189),
    LatLng(16.842254, 96.20732),
    LatLng(16.842198, 96.20743),
    LatLng(16.842124, 96.20752),
    LatLng(16.842001, 96.207606),
    LatLng(16.84179, 96.207672),
    LatLng(16.841027, 96.207637),
    LatLng(16.840993, 96.207632),
    LatLng(16.84099, 96.2077142)
  ];

  static const Map<int, String> maneuverTypeToTablerIcon = {
    0: 'arrow_narrow_left', // Turn left
    1: 'arrow_narrow_left', // Turn slight left
    2: 'arrow_narrow_up', // Continue straight
    3: 'arrow_narrow_right', // Turn slight right
    4: 'arrow_narrow_right', // Turn right
    5: 'corner_down_left', // Make a sharp left turn
    6: 'corner_down_right', // Make a sharp right turn
    7: 'arrow_loop_left', // Perform a U_turn
    8: 'circle_dashed', // Enter roundabout
    9: 'circle_dashed', // Leave roundabout
    10: 'map_pin', // Reach a destination
    11: 'arrow_right', // Depart/start route
    12: 'road', // Enter a highway/motorway
    13: 'arrow_autofit_right', // Keep right
    14: 'arrows_left-right', // Change lanes
    15: 'exit', // Take an exit
    16: 'compass', // Head towards a specific direction
  };
}
