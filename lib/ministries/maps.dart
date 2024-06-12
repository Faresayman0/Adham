import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  final LatLng userLocation;
  final Map<LatLng, String> carsLocations;
  final Map<String, Future<BitmapDescriptor>> carIcons;

  const MapScreen({
    Key? key,
    required this.userLocation,
    required this.carsLocations,
    required this.carIcons,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
  
}

class _MapScreenState extends State<MapScreen> {
  Set<Marker> myMarkers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  static const double averageSpeedKmPerHour = 40.0;

  double calculateDistance(LatLng point1, LatLng point2) {
    const R = 6371.0;

    double lat1 = point1.latitude * (pi / 180);
    double lon1 = point1.longitude * (pi / 180);
    double lat2 = point2.latitude * (pi / 180);
    double lon2 = point2.longitude * (pi / 180);

    double dlon = lon2 - lon1;
    double dlat = lat2 - lat1;

    double a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  Map<String, dynamic> findClosestCar() {
    double minDistance = double.infinity;
    LatLng closestCarLocation = widget.carsLocations.keys.first;
    String closestCarId = widget.carsLocations.values.first;

    for (MapEntry<LatLng, String> entry in widget.carsLocations.entries) {
      double distance = calculateDistance(widget.userLocation, entry.key);
      if (distance < minDistance) {
        minDistance = distance;
        closestCarLocation = entry.key;
        closestCarId = entry.value;
      }
    }

    return {'location': closestCarLocation, 'id': closestCarId};
  }

  String calculateEstimatedArrivalTime(double distance) {
    double estimatedTimeInHours = distance / averageSpeedKmPerHour;
    int estimatedTimeInMinutes = (estimatedTimeInHours * 60).round();
    return '$estimatedTimeInMinutes minutes';
  }

  @override
  void initState() {
    initializeMarkers();
    getPolyline();
    super.initState();
  }

  Future<void> initializeMarkers() async {
    myMarkers = {
      Marker(
        markerId: const MarkerId('user'),
        position: widget.userLocation,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "User's Location"),
      ),
      for (MapEntry<LatLng, String> entry in widget.carsLocations.entries)
        Marker(
          markerId: MarkerId(entry.value),
          position: entry.key,
          icon: await widget.carIcons[entry.value]!, // Use provided car icon
          // icon: await BitmapDescriptor.fromAssetImage(
          //      ImageConfiguration.empty, widget.carIcons[entry.value].toString()  ),
          infoWindow: InfoWindow(title: " ${entry.value}"),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.userLocation,
              zoom: 15,
            ),
            markers: myMarkers,
            mapType: MapType.normal,
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController googleMapController) {
              setState(() {
                initializeMarkers();
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Map<String, dynamic> closestCar = findClosestCar();
          LatLng closestCarLocation = closestCar['location'];
          String closestCarId = closestCar['id'];

          double distance =
              calculateDistance(widget.userLocation, closestCarLocation);

          String estimatedArrivalTime = calculateEstimatedArrivalTime(distance);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Closest car is: $closestCarId. Estimated arrival time: $estimatedArrivalTime"),
            ),
          );
        },
        child: const Icon(Icons.directions_car),
      ),
    );
  }

  addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        width: 2,
        polylineId: id,
        color: const Color(0xffC40915),
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

//   getPolyline() {
//   if (widget.carsLocations.isNotEmpty) {
//     for (MapEntry<LatLng, String> entry in widget.carsLocations.entries) {
//       LatLng carLocation = entry.key;
//       polylineCoordinates.add(carLocation);
//       polylineCoordinates.add(widget.userLocation);
//     }
//     addPolyLine();
//   }
// }

  getPolyline() async {
    polylineCoordinates.add(const LatLng(29.994066, 31.313061));
    polylineCoordinates.add(const LatLng(29.992017, 31.314806));
    polylineCoordinates.add(const LatLng(29.986353, 31.321824));
    polylineCoordinates.add(const LatLng(29.994861, 31.315796));

    addPolyLine();
  }
}
