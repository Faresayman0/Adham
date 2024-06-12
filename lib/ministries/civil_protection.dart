import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'maps.dart';

// ignore: use_key_in_widget_constructors
class CivilProtection extends StatefulWidget {
  static const String routeName = 'civil-protection';

  @override
  State<CivilProtection> createState() => _CivilProtectionState();
}

class _CivilProtectionState extends State<CivilProtection> {

  Map<LatLng, String> carsLocations = {};
  Map<String, Future<BitmapDescriptor>> carIcons = {};

  Future<void> fetchDataFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('Ministries')
        .doc('CivilProtection')
        .collection('vehicles')
        .get();

    for (var doc in querySnapshot.docs) {
      final location = doc['location'] as GeoPoint;
      final plateNumber = doc['plate_number'] as String;
      final latLng = LatLng(location.latitude, location.longitude);
      carsLocations[latLng] = plateNumber;
      carIcons[plateNumber] = Future.value(BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        "assets/firetruck.png",
      ));
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffC40915),
        title: const Center(
          child: Text('Ministry of Civil Protection',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      // ignore: avoid_unnecessary_containers
      body: Column(
          children: [
            Expanded(
            child:
            MapScreen(
              userLocation: const LatLng(29.992017, 31.314806),
              carIcons: carIcons,
              carsLocations: carsLocations,
            ),
          ),
            const SizedBox(height: 15,),
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
                      Text('Fire Trucks Available',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Image.asset('assets/firetruck.png'),
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Arrives in 1 min',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text('plate no : DSS223',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                  const SizedBox(height: 10),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Image.asset('assets/firetruck.png'),
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Arrives in 5 min',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text('plate no : AAE331',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                  const SizedBox(height: 10),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Image.asset('assets/firetruck.png'),
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Arrives in 10 min',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text('plate no : BBA113',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                  const SizedBox(height: 5),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xffC40915),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15)),
                              onPressed: () {},
                              child: const Text('Dispatch Car',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
    );
  }
}