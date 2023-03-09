import 'package:location/location.dart';
import 'package:road_monitoring_app/models/camera.dart';

class User {
  final String _id;
  final String _email;
  final String _password;
  LocationData? _currentLocation;
  late List<Camera> _favourites;

  User(
    this._id,
    this._email,
    this._password,
  ) {
    _favourites = List.empty(growable: true);
  }

  void addFavourite(Camera favourite) {
    _favourites.add(favourite);
  }

  String getId() {
    return _id;
  }

  String getEmail() {
    return _email;
  }

  String getPassword() {
    return _password;
  }

  LocationData? getCurrentLocation() {
    return _currentLocation;
  }

  List<Camera>? getfavourites() {
    return _favourites;
  }

  void setCurrentLocation(LocationData currentLocation) {
    _currentLocation = currentLocation;
  }
}
