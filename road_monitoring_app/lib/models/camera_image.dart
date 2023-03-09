import 'package:flutter/material.dart';

class CameraImage {
  final Image _image;
  final DateTime _dateTime;

  CameraImage(this._image, this._dateTime);

  Image getImage() {
    return _image;
  }

  DateTime getDateTime() {
    return _dateTime;
  }
}
