import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../controllers/google_map_page_controller.dart';

class GoogleMapPageView extends StatelessWidget {
  GoogleMapPageView({super.key});

  final _originController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final destination = Get.arguments['destination'] as String; // Nhận địa chỉ đích
    final controller = Get.put(GoogleMapPageController());

    // Cập nhật controller với địa chỉ đích
    _destinationController.text = destination;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Bản đồ tìm kiếm"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.currentPosition.value == null) {
          return _buildLoading();
        }
        return _buildMapWithControls(controller);
      }),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildMapWithControls(GoogleMapPageController controller) {
    return Stack(
      children: [
        _buildGoogleMap(controller),
        _buildSearchPanel(controller),
        _buildRouteDetails(controller),
        if (controller.isLoading.value) _buildLoadingIndicator(),
        _buildCurrentLocationButton(controller),
      ],
    );
  }

  Widget _buildGoogleMap(GoogleMapPageController controller) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: controller.currentPosition.value!,
        zoom: 15,
      ),
      markers: _buildMarkers(controller),
      polylines: _buildPolylines(controller),
      onMapCreated: controller.onMapCreated,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
    );
  }

  Set<Marker> _buildMarkers(GoogleMapPageController controller) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('current'),
        position: controller.currentPosition.value!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: 'Vị trí hiện tại'),
      ),
    };

    if (controller.destinationMarker.value != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: controller.destinationMarker.value!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: 'Điểm đến'),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines(GoogleMapPageController controller) {
    return {
      if (controller.polylinePoints.isNotEmpty)
        Polyline(
          polylineId: const PolylineId('route'),
          points: controller.polylinePoints,
          color: Colors.blue,
          width: 5,
          geodesic: true,
        ),
    };
  }

  Widget _buildSearchPanel(GoogleMapPageController controller) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildAddressField(
                controller: _originController,
                hint: 'Điểm xuất phát',
                icon: Icons.location_on,
                onTap: () => _handleGetCurrentLocation(controller),
              ),
              const SizedBox(height: 8),
              _buildAddressField(
                controller: _destinationController,
                hint: 'Điểm đến',
                icon: Icons.flag,
              ),
              const SizedBox(height: 8),
              _buildSearchButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteDetails(GoogleMapPageController controller) {
    return Positioned(
      bottom: 80,
      left: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Obx(() {
            return Text(
              'Thời gian ước tính: ${controller.estimatedTime.value}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          }),
        ),
      ),
    );
  }




// Hàm để lấy vị trí hiện tại
  void _handleGetCurrentLocation(GoogleMapPageController controller) {
    // Kiểm tra xem vị trí hiện tại đã có chưa, nếu chưa thì lấy từ GPS
    if (controller.currentPosition.value != null) {
      _originController.text = controller.currentAddress.value;  // Đưa địa chỉ của vị trí hiện tại vào trường
    } else {
      Get.snackbar('Lỗi', 'Không thể lấy vị trí hiện tại.',
        backgroundColor: Colors.orange[100],
      );
    }
  }


  Widget _buildAddressField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    void Function()? onTap,  // Thêm sự kiện onTap để lấy vị trí hiện tại
  }) {
    return TextField(
      controller: controller,
      onTap: onTap,  // Gọi hàm lấy vị trí hiện tại khi người dùng nhấn vào trường này
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue),
        suffixIcon: icon == Icons.location_on
            ? IconButton(
          icon: Icon(Icons.my_location),
          onPressed: onTap,
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }


  Widget _buildSearchButton(GoogleMapPageController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () => _handleSearch(controller),
        child: const Text('TÌM ĐƯỜNG', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _handleSearch(GoogleMapPageController controller) {
    final origin = _originController.text.trim();
    final destination = _destinationController.text.trim();

    if (origin.isEmpty || destination.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập cả điểm đi và điểm đến',
        backgroundColor: Colors.orange[100],
      );
      return;
    }

    controller.getRouteAndDraw(origin, destination);
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildCurrentLocationButton(GoogleMapPageController controller) {
    return Positioned(
      bottom: 24,
      right: 16,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        onPressed: controller.goToCurrentLocation,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }
}
