import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class CameraLocation {
  final String _id;
  final String _name;
  final double _lat;
  final double _lon;
  final String _condition;
  final Image _img;
  final String _datetime;

  CameraLocation(
    this._id,
    this._name,
    this._lat,
    this._lon,
    this._condition,
    this._img,
    this._datetime,
  );

  factory CameraLocation.fromJson(Map<String, dynamic> json) {
    return CameraLocation(
      json['id'],
      json['name'],
      json['lat'],
      json['lon'],
      json['image']['status'],
      Image.memory(base64Decode(json['image']['img'])),
      json['image']['date'],
    );
  }

  String getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  double getLat() {
    return _lat;
  }

  double getLon() {
    return _lon;
  }

  String getCondition() {
    switch (_condition) {
      case 'snow':
        return 'It is snowy';
      case 'rainy':
        return 'It is rainy';
      case 'water':
        return 'It is rainy';
      case 'dry':
        return 'It is dry';
      default:
        return 'It is rainy';
    }
  }

  Image getImg() {
    return _img;
  }

  String getDatetime() {
    return _datetime;
  }

  String getIconPath() {
    switch (_condition) {
      case 'snow':
        return 'assets/icons/snow.png';
      case 'rainy':
        return 'assets/icons/rainy.png';
      case 'water':
        return 'assets/icons/rainy.png';
      case 'dry':
        return 'assets/icons/sunny.png';
      default:
        return 'assets/icons/dry.png';
    }
  }
}
