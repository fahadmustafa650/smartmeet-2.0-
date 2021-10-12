import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_gmaps/.env.dart';
//import 'package:flutter_gmaps/directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'directions.dart';

const mapApiKey = 'AIzaSyAofr6MTAVjER_EanHr_GFsMGzOcehOeUU';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    print('originLat=${origin.latitude}');
    print('originLong=${origin.longitude}');
    print('destinationLat=${destination.latitude}');
    print('destinationLong=${destination.longitude}');
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': mapApiKey,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.data);
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
