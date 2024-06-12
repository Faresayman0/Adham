// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:location/location.dart';

class LocationService {
  Future<LocationData> getLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        throw Exception();
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception();
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }
}



// class MyLocationManager {
//   Location myLocation = Location();

//   Future<bool> isPermissionGranted() async {
//     var permissionStatus = await myLocation.hasPermission();
//     return permissionStatus == PermissionStatus.granted;
//   }

//   Future<bool> requestPermissin() async {
//     var permissionStatus = await myLocation.requestPermission();
//     return permissionStatus == PermissionStatus.granted;
//   }

//   Future<bool> isServiceEnabled() async {
//     var serviceEnabled = await myLocation.serviceEnabled();
//     return serviceEnabled;
//   }

//   Future<bool> requesrServics() async {
//     var serviceEnabled = await myLocation.requestService();
//     return serviceEnabled;
//   }

//   Future<LocationData?> getUserLocation() async {
//     var permissionStatus = await requestPermissin();
//     var serviceEnabled = await requesrServics();
//     if (!permissionStatus || !serviceEnabled) {
//       return null;
//     }
//     return myLocation.getLocation();
//   }

//   Stream<LocationData> updataUserLocation() {
//     return myLocation.onLocationChanged;
//   }
// }