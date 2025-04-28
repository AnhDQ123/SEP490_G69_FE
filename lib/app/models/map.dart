class GeocodeResult {
  final String address;
  final double lat;
  final double lng;

  GeocodeResult({required this.address, required this.lat, required this.lng});

  // Phương thức từ JSON về đối tượng GeocodeResult
  factory GeocodeResult.fromJson(Map<String, dynamic> json) {
    return GeocodeResult(
      address: json['results'][0]['formatted_address'],
      lat: json['results'][0]['geometry']['location']['lat'],
      lng: json['results'][0]['geometry']['location']['lng'],
    );
  }
}

class RouteResult {
  final String status;
  final List<Route> routes;

  RouteResult({required this.status, required this.routes});

  factory RouteResult.fromJson(Map<String, dynamic> json) {
    return RouteResult(
      status: json['status'],
      routes: (json['routes'] as List)
          .map((e) => Route.fromJson(e))
          .toList(),
    );
  }
}

class Route {
  final List<Leg> legs;

  Route({required this.legs});

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      legs: (json['legs'] as List).map((e) => Leg.fromJson(e)).toList(),
    );
  }
}

class Leg {
  final String startAddress;
  final String endAddress;
  final List<Step> steps;
  final Duration duration; // Thêm trường duration cho thời gian của leg


  Leg({required this.startAddress, required this.endAddress, required this.steps, required this.duration,});

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      startAddress: json['start_address'],
      endAddress: json['end_address'],
      steps: (json['steps'] as List).map((e) => Step.fromJson(e)).toList(),
      duration: Duration(seconds: json['duration']['value']), // Lấy thời gian trong duration
    );
  }
}

class Step {
  final String htmlInstructions;
  final Polyline polyline;
  final Duration duration;  // Thêm duration cho mỗi bước


  Step({required this.htmlInstructions, required this.polyline, required this.duration,});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      htmlInstructions: json['html_instructions'],
      polyline: Polyline.fromJson(json['polyline']),
      duration: Duration(seconds: json['duration']['value']), // Lấy thời gian trong bước
    );
  }
}

class Polyline {
  final String points;

  Polyline({required this.points});

  factory Polyline.fromJson(Map<String, dynamic> json) {
    return Polyline(
      points: json['points'],
    );
  }
}
