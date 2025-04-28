import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../base/api_base_url.dart';
import '../models/map.dart';

class MapService extends GetxService {
  final String _baseUrl = ApiBaseUrl.baseUrl;
  final _cache = <String, dynamic>{};

  Future<GeocodeResult> getGeocode(String address) async {
    final cacheKey = 'geocode-$address';
    if (_cache.containsKey(cacheKey)) {
      return GeocodeResult.fromJson(_cache[cacheKey]);
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/map/geocode/$address'));
      _handleResponse(response);

      final data = json.decode(response.body);
      _cache[cacheKey] = data;
      return GeocodeResult.fromJson(data);
    } catch (e) {
      print('Error fetching geocode: $e');
      rethrow; // Rethrow the error to propagate it
    }
  }

  Future<GeocodeResult> getReverseGeocode(double lat, double lng) async {
    final cacheKey = 'reverse-geocode-$lat-$lng';
    if (_cache.containsKey(cacheKey)) {
      return GeocodeResult.fromJson(_cache[cacheKey]);
    }

    final response = await http.get(Uri.parse('$_baseUrl/api/map/reverse-geocode/$lat/$lng'));
    _handleResponse(response);

    final data = json.decode(response.body);
    _cache[cacheKey] = data;
    return GeocodeResult.fromJson(data);
  }

  // Phương thức gọi API Route
  Future<RouteResult> getRoute(String origin, String destination) async {
    final cacheKey = 'route-$origin-$destination';
    if (_cache.containsKey(cacheKey)) {
      return RouteResult.fromJson(_cache[cacheKey]);
    }

    final response = await http.get(Uri.parse('$_baseUrl/api/map/getRoute?origin=$origin&destination=$destination'));
    _handleResponse(response);

    final data = json.decode(response.body);
    _cache[cacheKey] = data;
    return RouteResult.fromJson(data);
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      print('API error: ${response.statusCode} - ${response.body}');
      throw Exception('API request failed: ${response.statusCode}');
    }
  }


}
