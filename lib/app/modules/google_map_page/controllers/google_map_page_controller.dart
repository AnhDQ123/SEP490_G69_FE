import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../../models/map.dart';
import '../../../service/map_service.dart';

class GoogleMapPageController extends GetxController {
  final Location _location = Location();
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  final RxString currentAddress = ''.obs;
  final mapService = Get.find<MapService>();
  GoogleMapController? _mapController;

  final RxList<LatLng> polylinePoints = <LatLng>[].obs;
  final Rx<LatLng?> destinationMarker = Rx<LatLng?>(null);
  final RxBool isLoading = false.obs;
  final RxString originAddress = ''.obs;
  final RxString destinationAddress = ''.obs;

  // Biến lưu trữ thời gian ước tính cho việc di chuyển
  final RxString estimatedTime = ''.obs;

  double roundToDecimalPlaces(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }



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
        _updateCurrentAddress(newPos);
      }
    });
  }

  // Cập nhật vị trí hiện tại và địa chỉ của nó
  Future<void> _updateCurrentAddress(LatLng position) async {
    try {
      final result = await mapService.getReverseGeocode(position.latitude, position.longitude);
      currentAddress.value = result.address;
      if (originAddress.isEmpty) originAddress.value = result.address;  // Nếu chưa có điểm xuất phát, lấy luôn
    } catch (e) {
      print('Lỗi reverse geocode: $e');
    }
  }

// Hàm này sẽ được gọi khi người dùng nhấn nút "Lấy vị trí hiện tại"
  Future<void> getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      final newPos = LatLng(locationData.latitude!, locationData.longitude!);
      currentPosition.value = newPos;
      await _updateCurrentAddress(newPos);  // Cập nhật địa chỉ của vị trí hiện tại
    } catch (e) {
      _showError('Lỗi', 'Không thể lấy vị trí hiện tại');
    }
  }


  Future<void> getRouteAndDraw(String origin, String destination) async {
    try {
      isLoading.value = true;
      polylinePoints.clear();
      destinationMarker.value = null;

      // Geocode cả 2 địa chỉ song song để tiết kiệm thời gian
      final results = await Future.wait([
        mapService.getGeocode(origin),
        mapService.getGeocode(destination),
      ]);

      if (results.any((r) => r == null || r.address.isEmpty)) {
        throw Exception('Không tìm thấy địa chỉ');
      }

      // Làm tròn tọa độ
      final originLatLng = LatLng(
        roundToDecimalPlaces(results[0].lat, 2),
        roundToDecimalPlaces(results[0].lng, 2),
      );

      final destLatLng = LatLng(
        roundToDecimalPlaces(results[1].lat, 2),
        roundToDecimalPlaces(results[1].lng, 2),
      );

      originAddress.value = results[0].address;
      destinationAddress.value = results[1].address;
      destinationMarker.value = destLatLng;

      // Lấy tuyến đường
      final routeResult = await mapService.getRoute(
        '${originLatLng.latitude},${originLatLng.longitude}',
        '${destLatLng.latitude},${destLatLng.longitude}',
      );

      if (routeResult.routes.isEmpty) {
        throw Exception('Không tìm thấy tuyến đường');
      }

      // Lấy thời gian ước tính từ response
      final leg = routeResult.routes[0].legs[0]; // Giả sử chỉ có một route và một leg
      estimatedTime.value = leg.duration.inMinutes.toString() + ' phút';  // Thời gian ước tính từ Leg

      _processRoute(routeResult, originLatLng, destLatLng);
    } catch (e) {
      _showError('Lỗi tìm đường', e.toString());
      // Thay vì hiển thị lỗi với exception, hiển thị một thông báo chung
      // Get.snackbar('Lỗi', 'Có lỗi xảy ra khi tìm đường, vui lòng thử lại sau',
      //   backgroundColor: Colors.red[100],
      // );
      // print('Lỗi tìm đường: $e');
    } finally {
      isLoading.value = false;
    }
  }



  void _processRoute(RouteResult result, LatLng origin, LatLng destination) {
    final points = result.routes.expand((route) =>
        route.legs.expand((leg) =>
            leg.steps.expand((step) =>
                _decodePolyline(step.polyline.points)
            )
        )
    ).toList();

    polylinePoints.value = points;
    _zoomToRoute(origin, destination, points);
  }

  void _zoomToRoute(LatLng origin, LatLng destination, List<LatLng> points) {
    if (_mapController != null && points.isNotEmpty) {
      final bounds = _getLatLngBounds([origin, destination, ...points]);
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  Future<void> goToCurrentLocation() async {
    if (currentPosition.value != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition.value!, 15),
      );
    }
  }

  // Giải mã polyline từ chuỗi
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      while (true) {
        int b = encoded.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1f) << shift;
        shift += 5;
        if (b < 0x20) break;
      }
      int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;
      while (true) {
        int b = encoded.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1f) << shift;
        shift += 5;
        if (b < 0x20) break;
      }
      int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  // Tính toán LatLngBounds để zoom vừa vào tuyến đường
  LatLngBounds _getLatLngBounds(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;

    for (var point in points) {
      if (minLat == null || point.latitude < minLat!) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat!) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng!) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng!) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  void _showError(String title, String message) {
    Get.snackbar(title, message,
      backgroundColor: Colors.red[100],
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (currentPosition.value != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition.value!, 15),
      );
    }
  }
}