import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../../service/map_service.dart';

class UserMapController extends GetxController {
  final Location _location = Location();
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  final mapService = Get.find<MapService>();

  GoogleMapController? _mapController;

  @override
  void onInit() {
    super.onInit();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      await _checkLocationPermission();
      _setupLocationListener();
    } catch (e) {
      _showError('Không thể truy cập vị trí', e.toString());
    }
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) throw Exception('Dịch vụ vị trí bị tắt');
    }

    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) {
        throw Exception('Quyền truy cập vị trí bị từ chối');
      }
    }
  }

  void _setupLocationListener() {
    _location.onLocationChanged.listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        final newPos = LatLng(locationData.latitude!, locationData.longitude!);
        currentPosition.value = newPos;
      }
    });
  }

  Future<void> goToCurrentLocation() async {
    if (currentPosition.value != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition.value!, 15),
      );
    }
  }

  void searchLocation(String query) async {
    try {
      final result = await mapService.getGeocode(query);
      if (result != null) {
        final position = LatLng(result.lat, result.lng);
        currentPosition.value = position;
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(position, 15),
        );
      } else {
        _showError('Không tìm thấy vị trí', 'Vui lòng thử lại với từ khóa khác.');
      }
    } catch (e) {
      _showError('Lỗi tìm kiếm', 'Có lỗi xảy ra khi tìm kiếm vị trí.');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (currentPosition.value != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition.value!, 15),
      );
    }
  }

  void _showError(String title, String message) {
    Get.snackbar(title, message,
      backgroundColor: Colors.red[100],
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
