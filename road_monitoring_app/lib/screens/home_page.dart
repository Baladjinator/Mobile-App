import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as wsp;
import 'package:location/location.dart';
import 'package:road_monitoring_app/main.dart';
import 'package:road_monitoring_app/models/camera_location.dart';
import 'package:road_monitoring_app/themes/constants.dart';
import 'package:road_monitoring_app/widgets/form_text_button.dart';

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
  final String apiKey = 'AIzaSyA_lJNz7OsdOvmP5XjXbXBqTwKIh9ASoJw';
  String placeLocation = "Search Location";
  Marker? lastMarker;
  double radius = 77800.0;

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  Set<Marker> markers = Set();
  Set<Marker> toRemove = Set();

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
    initialCameraPosition = LatLng(
      currentPosition.latitude!,
      currentPosition.longitude!,
    );

    isInitialized = true;
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

  void addCamera(CameraLocation camera) async {
    final Uint8List markerIcon =
        await getBytesFromAsset(camera.getIconPath(), 125);

    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(camera.getId()),
          position: LatLng(camera.getLat(), camera.getLon()),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
            title: camera.getName(),
            snippet: 'Tap to view',
            onTap: () => getModalBottomSheet(camera),
          ),
        ),
      );
    });
  }

  Future getModalBottomSheet(CameraLocation camera) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: bgColorDarkTheme,
      isScrollControlled: true,
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
                        image: camera.getImg().image,
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
                          'Lat: ${camera.getLat()}; Lon: ${camera.getLon()}',
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
                          camera.getCondition(),
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
                          camera.getDatetime(),
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
    );
  }

  @override
  void initState() {
    super.initState();

    getLocation();

    location.onLocationChanged.listen((LocationData currentLocation) async {
      List<CameraLocation> cameras = await restService.fetchCameras(
        currentLocation.latitude!,
        currentLocation.longitude!,
        radius,
      );

      setState(() {
        currentPosition = currentLocation;
        initialCameraPosition = LatLng(
          currentPosition.latitude!,
          currentPosition.longitude!,
        );

        markers.clear();

        for (CameraLocation camera in cameras) {
          addCamera(camera);
        }
      });
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    setState(() {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 6,
      );
      polylines[id] = polyline;
    });
  }

  // void addCamera(Camera camera) async {
  //   final Uint8List markerIcon =
  //       await getBytesFromAsset(camera.getIconPath(), 125);

  //   setState(() {
  //     markers.add(
  //       Marker(
  //         markerId: MarkerId(camera.getName()),
  //         position: camera.getPosition(),
  //         icon: BitmapDescriptor.fromBytes(markerIcon),
  //         infoWindow: InfoWindow(
  //           title: camera.getName(),
  //           snippet: 'Tap to view',
  //           onTap: () =>
  //           ),
  //         ),
  //       ),
  //     );
  //   });
  // }

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
            onPressed: () async {
              var place = await PlacesAutocomplete.show(
                cursorColor: contrastColorDarkTheme,
                logo: const SizedBox(),
                context: context,
                apiKey: apiKey,
                mode: Mode.fullscreen,
                strictbounds: false,
                components: [wsp.Component(wsp.Component.country, 'bg')],
              );

              if (place != null) {
                setState(() {
                  placeLocation = place.description.toString();
                });

                final plist = wsp.GoogleMapsPlaces(
                  apiKey: apiKey,
                  apiHeaders: await GoogleApiHeaders().getHeaders(),
                );

                String placeid = place.placeId ?? "0";
                final detail = await plist.getDetailsByPlaceId(placeid);
                final geometry = detail.result.geometry!;
                final lat = geometry.location.lat;
                final lang = geometry.location.lng;
                var newlatlang = LatLng(lat, lang);

                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: newlatlang,
                      zoom: 15.0,
                    ),
                  ),
                );

                setState(() {
                  if (lastMarker != null) {
                    markers.remove(lastMarker);
                  }

                  lastMarker = Marker(
                    markerId: MarkerId(placeid),
                    position: newlatlang,
                    infoWindow: InfoWindow(
                      title: '${detail.result.name}',
                      snippet: 'Tap to see more',
                      onTap: () {},
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    ),
                  );

                  markers.add(lastMarker!);
                });

                List<LatLng> polylineCoordinates = [];

                PolylineResult result =
                    await polylinePoints.getRouteBetweenCoordinates(
                  apiKey,
                  PointLatLng(
                    currentPosition.latitude!,
                    currentPosition.longitude!,
                  ),
                  PointLatLng(
                    newlatlang.latitude,
                    newlatlang.longitude,
                  ),
                  travelMode: TravelMode.driving,
                );

                if (result.points.isNotEmpty) {
                  result.points.forEach((PointLatLng point) {
                    polylineCoordinates.add(
                      LatLng(point.latitude, point.longitude),
                    );
                  });
                } else {
                  print(result.errorMessage);
                }

                print(polylineCoordinates.length);

                addPolyLine(polylineCoordinates);

                // ignore: use_build_context_synchronously
                showModalBottomSheet(
                  context: context,
                  backgroundColor: bgColorDarkTheme,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0.r),
                    ),
                  ),
                  builder: (context) {
                    return SizedBox(
                      height: 340.0.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25.0.w,
                          vertical: 25.0.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Point',
                                  style: TextStyle(
                                    fontSize: 20.0.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 10.0.w),
                                Text(
                                  'Current location',
                                  style: TextStyle(fontSize: 18.0.sp),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End Point',
                                  style: TextStyle(
                                    fontSize: 20.0.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 10.0.w),
                                Text(
                                  placeLocation,
                                  style: TextStyle(fontSize: 18.0.sp),
                                )
                              ],
                            ),
                            SizedBox(height: 5.0.h),
                            FormTextButton(
                              text: 'Show cameras',
                              onPressed: () {},
                            ),
                            Ink(
                              width: double.infinity,
                              height: 60.0.h,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: borderColorDarkTheme,
                                  width: 1.5,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0.r)),
                              ),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0.r)),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 18.0.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
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
              polylines: Set<Polyline>.of(polylines.values),
              circles: {
                Circle(
                  strokeWidth: 2,
                  strokeColor: bgColorDarkTheme,
                  circleId: const CircleId('nearbyArea'),
                  center: LatLng(
                    currentPosition.latitude!,
                    currentPosition.longitude!,
                  ),
                  radius: radius,
                )
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
