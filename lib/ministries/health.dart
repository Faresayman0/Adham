import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'maps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthScreen extends StatefulWidget {
  static const String routeName = 'health-screen';

  const HealthScreen({super.key});

  //const HealthScreen({super.key});
  // final Map<String, BitmapDescriptor> carIcons;

  // const HealthScreen({super.key, required this.carIcons});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  Map<LatLng, String> carsLocations = {};
  Map<String, Future<BitmapDescriptor>> carIcons = {};

  Future<void> fetchDataFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('Ministries')
        .doc('Health')
        .collection('vehicles')
        .get();

    for (var doc in querySnapshot.docs) {
      final location = doc['location'] as GeoPoint;
      final plateNumber = doc['plate_number'] as String;
      final latLng = LatLng(location.latitude, location.longitude);
      carsLocations[latLng] = plateNumber;
      carIcons[plateNumber] = Future.value(BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        "assets/ambulance.png",
      ));
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore(); // Fetch data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffC40915),
        title: const Center(
          child: Text(
            'Ministry of Health',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MapScreen(
              userLocation: const LatLng(29.992017, 31.314806),
              carsLocations: carsLocations,
              // carsLocations: {
              //   const LatLng(29.986353, 31.321824): 'car 1',
              //   const LatLng(29.994066, 31.313061): 'car 2',
              //   const LatLng(29.994861, 31.315796): 'car 3',
              // },
              
              // carIcons: {
              //   'car 1': Future.value(BitmapDescriptor.fromAssetImage(
              //       ImageConfiguration.empty, "assets/ambulance.png")),
              //   'car 2': Future.value(BitmapDescriptor.fromAssetImage(
              //       ImageConfiguration.empty, "assets/ambulance.png")),
              //   'car 3': Future.value(BitmapDescriptor.fromAssetImage(
              //       ImageConfiguration.empty, "assets/ambulance.png")),
              // },
              carIcons: carIcons,
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 10),
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
                      'Ambulances Available',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Image.asset('assets/ambulance.png'),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Arrives in 1 min',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'plate no : DSS223',
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
                          child: Image.asset('assets/ambulance.png'),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Arrives in 5 min',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'plate no : AAE331',
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
                          child: Image.asset('assets/ambulance.png'),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Arrives in 10 min',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'plate no : BBA113',
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
                    //width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffC40915),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15)),
                            onPressed: () {},
                            child: const Text(
                              'Dispatch Car',
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
