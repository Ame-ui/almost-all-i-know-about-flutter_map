import 'package:dio/dio.dart';
import 'package:flutter_map_all_feature/models/m_routing.dart';
import 'package:latlong2/latlong.dart';

class ApiService {
  Dio dio = Dio();

  Future<String?> getAddressByLatlng(
      {required LatLng pos, CancelToken? cancelToken}) async {
    Response response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse?lat=${pos.latitude}&lon=${pos.longitude}&format=json&accept-language=en',
        cancelToken: cancelToken);

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      // return response.data
      return response.data['display_name'];
    }
    return null;
  }

  Future<OSMRouting?> getRouting(
      {required LatLng from, required LatLng to}) async {
    Response response = await dio.get(
      'https://api.openrouteservice.org/v2/directions/driving-car?'
      'api_key=5b3ce3597851110001cf6248ad1861d574784c50aaa59ed01cbb01a2&'
      'start=${from.longitude},${from.latitude}&'
      'end=${to.longitude},${to.latitude}',
    );

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return OSMRouting.fromJson(response.data);
    }
    return null;
  }
}
