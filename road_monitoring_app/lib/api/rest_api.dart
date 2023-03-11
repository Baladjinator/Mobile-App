import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:road_monitoring_app/models/camera_location.dart';

class RestApi {
  final String SERVER_IP = 'https://roadhaze.mdatsev.dev';

  Future<int> attemptLogIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$SERVER_IP/user/login'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return response.statusCode;
  }

  Future<int> attemptSignUp(String email, String password) async {
    final response = await http.post(
      Uri.parse('$SERVER_IP/user/signup'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return response.statusCode;
  }

  Future<List<CameraLocation>> fetchCameras(
      double lat, double lon, double radius) async {
    //final encodedData = Uri.encodeQueryComponent("{'lon': $lon, 'lat': $lat}");
    final response = await http.post(
      Uri.parse('$SERVER_IP/location/nearby'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "lat": lat,
        "lon": lon,
        "radius": radius,
      }),
    );

    //print(response.body);
    return parseResponse(response.body);
  }

  static List<CameraLocation> parseResponse(String responseBody) {
    List<dynamic> parses = jsonDecode(responseBody);
    return parses
        .map<CameraLocation>((json) => CameraLocation.fromJson(json))
        .toList();
  }
}
