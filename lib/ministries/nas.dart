import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'maps.dart';

// ignore: use_key_in_widget_constructors
class NasScreen extends StatefulWidget {
  static const String routeName = 'nas-screen';

  @override
  State<NasScreen> createState() => _NasScreenState();
}

class _NasScreenState extends State<NasScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffC40915),
        title: const Center(
          child: Text('NAS',
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
              carsLocations: {
                const LatLng(29.986353, 31.321824): 'car 1',
                const LatLng(29.994066, 31.313061): 'car 2',
                const LatLng(29.994861, 31.315796): 'car 3',
              },
              carIcons: {
                'car 1': Future.value(BitmapDescriptor.fromAssetImage(
                    ImageConfiguration.empty, "assets/ambulance.png")),
                'car 2': Future.value(BitmapDescriptor.fromAssetImage(
                    ImageConfiguration.empty, "assets/firetruck.png")),
                'car 3': Future.value(BitmapDescriptor.fromAssetImage(
                    ImageConfiguration.empty, "assets/policecar.png")),
              },
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 10),
            Expanded(
              child: Column(
                children: [
                  const Text('Available Vehicles',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_drop_down),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Image.asset('assets/firetruck.png'),
                          ),
                          const Text('Fire Trucks',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 10),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_drop_down),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Image.asset('assets/ambulance.png'),
                          ),
                          const Text('Ambulance Car',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 10),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_drop_down),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Image.asset('assets/policecar.png'),
                          ),
                          const Text('Police Car',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
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
