// // import 'package:flutter/material.dart';
// // import 'package:flutter_map/flutter_map.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:latlong2/latlong.dart';
// // import 'package:location/location.dart' as loc;
// // import '../../../service/map_service.dart';
// //
// //
// // class OsmMapPickerScreen extends StatefulWidget {
// //   const OsmMapPickerScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<OsmMapPickerScreen> createState() => _OsmMapPickerScreenState();
// // }
// //
// // class _OsmMapPickerScreenState extends State<OsmMapPickerScreen> {
// //   LatLng _pickedLocation = LatLng(10.762622, 106.660172); // default HCM
// //   final _addressController = TextEditingController();
// //   final _mapService = MapService();
// //   final MapController mapController = MapController();
// //
// //
// //   void _handleTap(LatLng latlng) {
// //     setState(() {
// //       _pickedLocation = latlng;
// //     });
// //   }
// //
// //   Future<void> _searchAddress() async {
// //     final address = _addressController.text.trim();
// //     if (address.isEmpty) return;
// //
// //     final result = await _mapService.getCoordinates(address);
// //     if (result != null) {
// //       final coord = LatLng(result.lat, result.lng);
// //       print("📍 Đã nhận được tọa độ mới: $coord"); // 👈 thêm dòng này
// //
// //       setState(() {
// //         _pickedLocation = coord;
// //       });
// //       mapController.move(coord, 15.0); // 👈 map nhảy theo marker
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Không tìm thấy địa chỉ')),
// //       );
// //     }
// //   }
// //
// //   Future<void> _goToCurrentLocation() async {
// //     loc.Location location = loc.Location();
// //
// //     // Kiểm tra và yêu cầu quyền
// //     bool serviceEnabled = await location.serviceEnabled();
// //     if (!serviceEnabled) {
// //       serviceEnabled = await location.requestService();
// //       if (!serviceEnabled) return;
// //     }
// //
// //     loc.PermissionStatus permissionGranted = await location.hasPermission();
// //     if (permissionGranted == loc.PermissionStatus.denied) {
// //       permissionGranted = await location.requestPermission();
// //       if (permissionGranted != loc.PermissionStatus.granted) return;
// //     }
// //
// //     // Lấy vị trí hiện tại
// //     loc.LocationData locationData = await location.getLocation();
// //     final latlng = LatLng(locationData.latitude!, locationData.longitude!);
// //
// //     print("📍 Vị trí hiện tại: $latlng");
// //
// //     // Cập nhật map và địa chỉ
// //     _updateAddressFromLatLng(latlng);
// //   }
// //
// //   Future<void> _updateAddressFromLatLng(LatLng latlng) async {
// //     try {
// //       List<Placemark> placemarks = await placemarkFromCoordinates(
// //         latlng.latitude,
// //         latlng.longitude,
// //       );
// //
// //       if (placemarks.isNotEmpty) {
// //         final place = placemarks.first;
// //         final address =
// //             "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
// //
// //         setState(() {
// //           _addressController.text = address; // 👈 update vào ô tìm kiếm
// //           _pickedLocation = latlng; // 👈 cập nhật marker
// //         });
// //
// //         mapController.move(latlng, 15.0); // 👈 di chuyển bản đồ
// //       }
// //     } catch (e) {
// //       print("❌ Lỗi reverse geocoding: $e");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Chọn địa điểm - OSM")),
// //       body: Stack(
// //         children: [
// //           FlutterMap(
// //             mapController: mapController,
// //             options: MapOptions(
// //               center: _pickedLocation,
// //               zoom: 15.0,
// //               onTap: (_, latlng) => _updateAddressFromLatLng(latlng),
// //             ),
// //             children: [
// //               TileLayer(
// //                 urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
// //                 userAgentPackageName: 'com.example.yourapp',
// //               ),
// //               MarkerLayer(
// //                 markers: [
// //                   Marker(
// //                     point: _pickedLocation,
// //                     width: 40,
// //                     height: 40,
// //                     child: const Icon(Icons.location_on, size: 40, color: Colors.red),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //           Positioned(
// //             top: 20,
// //             left: 15,
// //             right: 15,
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _addressController,
// //                     decoration: InputDecoration(
// //                       hintText: "Nhập địa chỉ...",
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       contentPadding: EdgeInsets.symmetric(horizontal: 12),
// //                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(width: 8),
// //                 ElevatedButton(
// //                   onPressed: _searchAddress,
// //                   child: Icon(Icons.search),
// //                 )
// //               ],
// //             ),
// //           ),
// //           Positioned(
// //             top: 80,
// //             right: 15,
// //             child: FloatingActionButton.small(
// //               onPressed: _goToCurrentLocation,
// //               backgroundColor: Colors.blueAccent,
// //               child: Icon(Icons.my_location),
// //             ),
// //           ),
// //
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart' as loc;
//
// import '../../../service/map_service.dart';
//
// class OsmMapPickerScreen extends StatefulWidget {
//   const OsmMapPickerScreen({Key? key}) : super(key: key);
//
//   @override
//   State<OsmMapPickerScreen> createState() => _OsmMapPickerScreenState();
// }
//
// class _OsmMapPickerScreenState extends State<OsmMapPickerScreen> {
//   LatLng _pickedLocation = LatLng(21.0285, 105.8542); // Default: Hanoi
//   final _addressController = TextEditingController();
//   final _mapService = MapService();
//   final MapController mapController = MapController();
//
//   Future<void> _updateAddressFromLatLng(LatLng latlng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         latlng.latitude,
//         latlng.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         final address =
//             "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
//
//         setState(() {
//           _addressController.text = address;
//           _pickedLocation = latlng;
//         });
//
//         mapController.move(latlng, 15.0);
//       }
//     } catch (e) {
//       print("❌ Lỗi reverse geocoding: $e");
//     }
//   }
//
//   Future<void> _goToCurrentLocation() async {
//     final location = loc.Location();
//
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return;
//     }
//
//     loc.PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == loc.PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != loc.PermissionStatus.granted) return;
//     }
//
//     final current = await location.getLocation();
//     final latlng = LatLng(current.latitude!, current.longitude!);
//     await _updateAddressFromLatLng(latlng);
//   }
//
//   Future<void> _searchAddress() async {
//     final address = _addressController.text.trim();
//     if (address.isEmpty) return;
//
//     final gps = await loc.Location().getLocation();
//
//     final result = await _mapService.getCoordinates(
//       address,
//       lat: gps.latitude,
//       lng: gps.longitude,
//     );
//
//     if (result != null) {
//       final coord = LatLng(result.lat, result.lng);
//       setState(() {
//         _pickedLocation = coord;
//       });
//       mapController.move(coord, 15.0);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Không tìm thấy địa chỉ')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Chọn địa điểm - OSM")),
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: mapController,
//             options: MapOptions(
//               center: _pickedLocation,
//               zoom: 15.0,
//               onTap: (_, latlng) => _updateAddressFromLatLng(latlng),
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//                 userAgentPackageName: 'com.example.yourapp',
//               ),
//               MarkerLayer(
//                 markers: [
//                   Marker(
//                     point: _pickedLocation,
//                     width: 40,
//                     height: 40,
//                     child: const Icon(Icons.location_on, size: 40, color: Colors.red),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Positioned(
//             top: 20,
//             left: 15,
//             right: 15,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _addressController,
//                     decoration: InputDecoration(
//                       hintText: "Nhập địa chỉ...",
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _searchAddress,
//                   child: Icon(Icons.search),
//                 )
//               ],
//             ),
//           ),
//           Positioned(
//             top: 80,
//             right: 15,
//             child: FloatingActionButton.small(
//               onPressed: _goToCurrentLocation,
//               backgroundColor: Colors.blueAccent,
//               child: Icon(Icons.my_location),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
