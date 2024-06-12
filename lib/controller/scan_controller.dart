import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart' as location;
// ignore: depend_on_referenced_packages
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart'
    as permission_interface;

class ScanController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late String detectedText = "";
  late String previousLetter;
  bool isProcessing = false;
  late List<String> labels;
  late List<String> detectedLetters;
  late String allDetectedText;

  final location.Location _location = location.Location();

  var isCameraInitialized = false.obs;
  var isDetecting = false;
  var cameraCount = 0;

  @override
  void onInit() {
    super.onInit();
    previousLetter = "";
    initCamera();
    initTFLite();
    detectedLetters = [];
    allDetectedText = "";
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
    cameraController.dispose();
  }

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[1], ResolutionPreset.low);
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);
      update();
    } else {
      if (kDebugMode) {
        print("Permission denied");
      }
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
      model: "assets/final_final_model_unquant.tflite",
      labels: "assets/final_final_labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  var singleTime = false;
  objectDetector(CameraImage image) async {
    if (isProcessing) {
      return;
    }
    isProcessing = true;

    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
      rotation: 90,
      threshold: 0.5,
    );

    isProcessing = false;

    if (detector != null) {
      detectedText = _extractLabels(detector);
      if (kDebugMode) {
        print("Detector: $detector");
      }
      _checkForSOS(detectedText);
    }
  }

  void _checkForSOS(String detectedText) async {
    if (detectedText.contains("S O S")) {
      if (kDebugMode) {
        print("Emergency is on the way!");
      }

      try {
        location.LocationData? locationData = await _getLocation();
        if (locationData != null) {
          await FirebaseFirestore.instance.collection('Emergency').add({
            'message': 'SOS',
            'timestamp': FieldValue.serverTimestamp(),
            'latitude': locationData.latitude,
            'longitude': locationData.longitude,
          });
          if (kDebugMode) {
            print('Emergency message with location submitted successfully!');
          }
        } else {
          if (kDebugMode) {
            print('Failed to get location data.');
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print('Failed to submit emergency message: $error');
        }
      }
    }
  }

  Future<location.LocationData?> _getLocation() async {
    bool serviceEnabled;
    location.PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == location.PermissionStatus.denied) {
      // Update this line
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != location.PermissionStatus.granted) {
        // Update this line
        return null;
      }
    }

    return await _location.getLocation();
  }

  String _extractLabels(List<dynamic> detector) {
    detectedLetters = [];
    for (var item in detector) {
      String label = item['label'].toString().replaceAll(RegExp(r'\d'), '');
      detectedLetters.add(label);
      detectedText += "$label ";
    }
    allDetectedText += detectedLetters.join();
    return allDetectedText;
  }
}