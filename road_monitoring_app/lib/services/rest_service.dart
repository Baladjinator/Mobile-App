import 'package:road_monitoring_app/api/rest_api.dart';
import 'package:road_monitoring_app/models/camera_location.dart';

class RestService {
  final RestApi _api;

  RestService(this._api);

  Future<int> attemptLogIn(String email, String password) async {
    return await _api.attemptLogIn(email, password);
  }

  Future<int> attemptSignUp(String email, String password) async {
    return await _api.attemptSignUp(email, password);
  }

  Future<List<CameraLocation>> fetchCameras(double lat, double lon) async {
    return await _api.fetchCameras(lat, lon);
  }
}
