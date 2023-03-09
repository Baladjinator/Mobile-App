import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:road_monitoring_app/models/camera_image.dart';

class Camera {
  final LatLng _position;
  final String _name;
  String _condition;
  NetworkImage _currentView;
  //List<CameraImage> _history;

  Camera(
    this._position,
    this._name,
    this._condition,
    this._currentView,
  );

  LatLng getPosition() {
    return _position;
  }

  String getName() {
    return _name;
  }

  String getCondition() {
    return _condition;
  }

  NetworkImage getCurrentView() {
    return _currentView;
  }

  String getIconPath() {
    switch (_condition) {
      case 'snow':
        return 'assets/icons/snow.png';
      case 'rainy':
        return 'assets/icons/rainy.png';
      case 'sunny':
        return 'assets/icons/sunny.png';
      default:
        return 'assets/icons/snow.png';
    }
  }
}
