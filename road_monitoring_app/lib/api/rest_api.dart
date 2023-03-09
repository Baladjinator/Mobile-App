import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:road_monitoring_app/models/camera.dart';
import 'package:road_monitoring_app/models/camera_location.dart';

class RestApi {
  final String SERVER_IP = 'http://10.0.224.186:9009/user';

  Future<int> attemptLogIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$SERVER_IP/login'),
      headers: <String, String>{
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
      Uri.parse('$SERVER_IP/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return response.statusCode;
  }

  Future<List<CameraLocation>> fetchCameras(double lat, double lon) async {
    final encodedData = Uri.encodeQueryComponent("{'lon': $lon, 'lat': $lat}");
    final response =
        await http.get(Uri.parse('$SERVER_IP/nearby?data=$encodedData'));

    return parseResponse(response.body);
  }

  static List<CameraLocation> parseResponse(String responseBody) {
    List<dynamic> parses = jsonDecode(responseBody);
    return parses
        .map<CameraLocation>((json) => CameraLocation.fromJson(json))
        .toList();
  }
}
