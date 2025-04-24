import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPageView extends StatefulWidget {
  const GoogleMapPageView({super.key});

  @override
  State<GoogleMapPageView> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPageView> {
  static const googlePlex = LatLng(
    20.999637,
    105.5366512,
  ); // Có thể get 2 tọa độ bằng API xong truyền vào đây gọi đến
  final locationController = Location();
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (_) async => await fetchLocationUpdates(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: googlePlex,
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: MarkerId('current location'),
            icon: BitmapDescriptor.defaultMarker,
            position: googlePlex,
          ),
        },
      ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if the location service is enabled
    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        // Show an error if location service is not enabled
        print("Location services are not enabled.");
        return;
      }
    }

    // Check if permission is granted
    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Show an error if permission is not granted
        print("Location permission not granted.");
        return;
      }
    }

    // Listen for location updates
    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
        print(currentPosition);
      }
    });
  }
}