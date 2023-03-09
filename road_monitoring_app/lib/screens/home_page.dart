import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:road_monitoring_app/models/camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = Location();
  late LocationData currentPosition;
  late Marker marker;
  late GoogleMapController mapController;
  late LatLng initialCameraPosition;
  bool isInitialized = false;

  Set<Marker> markers = Set(); //markers for google map

  Camera camera1 = Camera(
      LatLng(42.806336, 23.2199877),
      "Petrohan",
      "snow",
      NetworkImage(
          'https://ichef.bbci.co.uk/news/976/cpsprodpb/C342/production/_88068994_thinkstockphotos-493881770.jpg'));
  Camera camera2 = Camera(
      LatLng(42.822262, 23.211637),
      "camera2",
      "sunny",
      NetworkImage(
          'https://ichef.bbci.co.uk/news/976/cpsprodpb/C342/production/_88068994_thinkstockphotos-493881770.jpg'));
  Camera camera3 = Camera(
      LatLng(42.811972, 23.229760),
      "camera3",
      "rainy",
      NetworkImage(
          'https://ichef.bbci.co.uk/news/976/cpsprodpb/C342/production/_88068994_thinkstockphotos-493881770.jpg'));

  @override
  void initState() {
    super.initState();
    getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("a");
      setState(() {
        currentPosition = currentLocation;
        initialCameraPosition =
            LatLng(currentPosition.latitude!, currentPosition.longitude!);
      });
    });

    addMarker(camera1);
    addMarker(camera2);
    addMarker(camera3);
  }

  //  Future<List<Adress>> _getAddress(double lat, double lang) async {
  //   final coordinates = new Coordinates(lat, lang);
  //   List<Address> add =
  //   await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   return add;
  // }

  getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentPosition = await location.getLocation();
    initialCameraPosition =
        LatLng(currentPosition.latitude!, currentPosition.longitude!);

    isInitialized = true;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );

    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void addMarker(Camera camera) async {
    final Uint8List markerIcon =
        await getBytesFromAsset(camera.getIconPath(), 125);

    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(camera.getName()),
          position: camera.getPosition(),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () => showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            builder: (context) {
              return SizedBox(
                height: 500.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  // markers.add(
  //   Marker(
  //     markerId: MarkerId(),
  //     position: startLocation,
  //     infoWindow: InfoWindow(
  //       title: 'Starting Point ',
  //       snippet: 'Start Marker',
  //     ),
  //     icon: markerbitmap,
  //   )
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps Sample App'),
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.abc),
          onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0.r),
              ),
            ),
            builder: (context) {
              return SizedBox(
                height: 650.0.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0.w,
                    vertical: 20.0.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        camera1.getName(),
                        style: TextStyle(
                          fontSize: 30.0.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 140.0.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0.r),
                            image: DecorationImage(
                              image: camera1.getCurrentView(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: isInitialized
          ? GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: initialCameraPosition,
                zoom: 15.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: markers,
              circles: {
                Circle(
                  strokeWidth: 2,
                  strokeColor: Colors.blue,
                  circleId: const CircleId(''),
                  center: LatLng(
                      currentPosition.latitude!, currentPosition.longitude!),
                  radius: 10000,
                )
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
