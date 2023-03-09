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
      json['condition'],
      Image.memory(base64Decode(json['img'])),
      json['datetime'],
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
    return _condition;
  }

  Image getImg() {
    return _img;
  }

  String getDatetime() {
    return _datetime;
  }
}
