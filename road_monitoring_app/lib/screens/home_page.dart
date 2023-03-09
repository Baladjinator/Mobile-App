import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:road_monitoring_app/main.dart';
import 'package:road_monitoring_app/models/camera.dart';
import 'package:road_monitoring_app/models/camera_location.dart';
import 'package:road_monitoring_app/services/place_service.dart';
import 'package:road_monitoring_app/themes/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = Location();
  late LocationData currentPosition;
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
    location.onLocationChanged.listen((LocationData currentLocation) async {
      print("aaaaa");

      // List<CameraLocation> cameras = await restService.fetchCameras(
      //     currentLocation.latitude!, currentLocation.longitude!);

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
          infoWindow: InfoWindow(
            title: camera.getName(),
            snippet: 'Tap to view',
            onTap: () => showModalBottomSheet(
              backgroundColor: bgColorDarkTheme,
              isScrollControlled: true,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0.r),
                ),
              ),
              builder: (context) {
                return SizedBox(
                  height: 470.0.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.0.w,
                      vertical: 25.0.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              camera.getName(),
                              style: TextStyle(
                                fontSize: 30.0.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.star_rounded,
                                size: 30.0.sp,
                              ),
                            )
                          ],
                        ),
                        Center(
                          child: Container(
                            height: 180.0.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0.r),
                              image: DecorationImage(
                                image: camera.getCurrentView(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/location.png',
                                  height: 40.0.h,
                                ),
                                SizedBox(width: 10.0.w),
                                Text(
                                  'Kostinbrod, Bulgaria',
                                  style: TextStyle(fontSize: 18.0.sp),
                                )
                              ],
                            ),
                            SizedBox(height: 12.0.h),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/condition.png',
                                  height: 40.0.h,
                                ),
                                SizedBox(width: 12.0.w),
                                Text(
                                  'Rainy',
                                  style: TextStyle(
                                    fontSize: 18.0.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 12.0.h),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/date.png',
                                  height: 40.0.h,
                                ),
                                SizedBox(width: 12.0.w),
                                Text(
                                  '12:30, 09/03/2023',
                                  style: TextStyle(fontSize: 18.0.sp),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
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
        elevation: 0.0,
        backgroundColor: const Color(0xFF0A0D14),
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFF38444D),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            Text(
              'Road',
              style: TextStyle(
                fontSize: 24.0.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Haze',
              style: TextStyle(
                fontSize: 24.0.sp,
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_rounded,
              size: 24.0.sp,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.star_rounded,
              size: 24.0.sp,
            ),
          )
        ],
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
                  strokeColor: bgColorDarkTheme,
                  circleId: const CircleId('nearbyArea'),
                  center: LatLng(
                      currentPosition.latitude!, currentPosition.longitude!),
                  radius: 10000.0,
                )
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
    // return FutureBuilder(
    //   // We will put the api call here
    //   future: null,
    //   builder: (context, snapshot) => query == ''
    //       ? Container(
    //           padding: EdgeInsets.all(16.0),
    //           child: Text('Enter your address'),
    //         )
    //       : snapshot.hasData
    //           ? ListView.builder(
    //               itemBuilder: (context, index) => ListTile(
    //                 // we will display the data returned from our future here
    //                 title: Text(snapshot.data[index]),
    //                 onTap: () {
    //                   close(context, snapshot.data[index]);
    //                 },
    //               ),
    //               itemCount: snapshot.data.length,
    //             )
    //           : Container(child: Text('Loading...')),
    // );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }
}

// class AddressSearchDelegate extends SearchDelegate {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       )
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return null;
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return FutureBuilder(
//       // We will put the api call here
//       future: null,
//       builder: (context, snapshot) => query == ''
//           ? Container(
//               padding: EdgeInsets.all(16.0),
//               child: Text('Enter your address'),
//             )
//           : snapshot.hasData
//               ? ListView.builder(
//                   itemBuilder: (context, index) => ListTile(
//                     // we will display the data returned from our future here
//                     title: Text(snapshot.data[index]),
//                     onTap: () {
//                       close(context, snapshot.data[index]);
//                     },
//                   ),
//                   itemCount: snapshot.data!.length,
//                 )
//               : Container(child: Text('Loading...')),
//     );
//   }
// }
