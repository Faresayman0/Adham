//import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: use_key_in_widget_constructors
class ClerkScreen extends StatefulWidget {
  static const String routeName = 'map';

  @override
  State<ClerkScreen> createState() => _ClerkScreenState();
}

class _ClerkScreenState extends State<ClerkScreen> {

  CameraPosition routeCameraPosition = const CameraPosition(
    target: LatLng(29.992017, 31.314806),
    zoom: 15,
  );

  Set<Marker> myMarker = {
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(29.992017, 31.314806),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: "User A"),
    ),
    const Marker(
      markerId: MarkerId('2'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(29.986353, 31.321824),
      infoWindow: InfoWindow(title: "User B"),
    ),
    const Marker(
      markerId: MarkerId('3'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(29.994066, 31.313061),
      infoWindow: InfoWindow(title: "User C"),
    ),
  };

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  String googleAPiKey = "AIzaSyA_rwYvuT-LZGEDM8gVJzgtn6yrobRttnI";

  @override
  void initState() {
    //setMarkerCustomImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffC40915),
        title: const Center(
            child: Text(
          'Clerk',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Column(children: [
        SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: routeCameraPosition,
            markers: myMarker,
            mapType: MapType.normal,
            polylines: Set<Polyline>.of(polylines.values),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_drop_down),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Emergencies',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC40915)),
                onPressed: () {},
                child: const Text(
                  'Report To NAS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC40915)),
                onPressed: () {},
                child: const Text(
                  'Report To Ministry of Health',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC40915)),
                onPressed: () {},
                child: const Text(
                  'Report To Ministry of Interior',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffC40915),
                ),
                onPressed: () {},
                child: const Text(
                  'Report To Ministry of Civil Protection',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        )),
      ]),
    );
  }
}
