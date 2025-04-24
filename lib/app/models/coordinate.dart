//
//
// class CoordinateModel {
//   final double lat;
//   final double lng;
//
//   CoordinateModel({required this.lat, required this.lng});
//
//   factory CoordinateModel.fromJson(List<dynamic> json) {
//     if (json.length < 2) throw Exception("Invalid coordinate data");
//     return CoordinateModel(
//       lat: json[0],
//       lng: json[1],
//     );
//   }
//
// }
//

class CoordinateModel {
  final double lat;
  final double lng;

  CoordinateModel({required this.lat, required this.lng});

  factory CoordinateModel.fromJson(List<dynamic> json) {
    if (json.length < 2) throw Exception("Dữ liệu tọa độ không hợp lệ");
    return CoordinateModel(
      lat: json[0],
      lng: json[1],
    );
  }
}

