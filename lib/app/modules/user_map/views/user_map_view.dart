import 'package:ffb_fe_flutter/app/modules/user_map/controllers/user_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class UserMapView extends StatelessWidget {
  UserMapView({super.key});

  final _searchController = TextEditingController();
  final _controller = Get.put(UserMapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bản đồ"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.currentPosition.value == null) {
          return _buildLoading();
        }
        return _buildMapWithControls();
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

  Widget _buildMapWithControls() {
    return Stack(
      children: [
        _buildGoogleMap(),
        _buildSearchPanel(),
        _buildCurrentLocationButton(),
      ],
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _controller.currentPosition.value!,
        zoom: 15,
      ),
      markers: _buildMarkers(),
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      onMapCreated: _controller.onMapCreated,
    );
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('current'),
        position: _controller.currentPosition.value!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: 'Vị trí hiện tại'),
      ),
    };

    return markers;
  }

  Widget _buildSearchPanel() {
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
                controller: _searchController,
                hint: 'Tìm kiếm vị trí',
                icon: Icons.search,
                onTap: () => _handleSearch(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    void Function()? onTap,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: onTap,  // Gọi hàm tìm kiếm khi nhấn nút tìm kiếm
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _controller.searchLocation(query);
    }
  }

  Widget _buildCurrentLocationButton() {
    return Positioned(
      bottom: 24,
      right: 16,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        onPressed: _controller.goToCurrentLocation,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }
}
