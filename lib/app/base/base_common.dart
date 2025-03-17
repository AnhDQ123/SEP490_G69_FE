import 'dart:developer';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseCommon {
  static BaseCommon? _instance;
  String? accessToken;
  String? refreshToken;
  // UserSession? accountSession;
  String? deviceToken;
  String? ownPhone;
  String locale = 'en';

  BaseCommon._internal();

  static BaseCommon get instance {
    _instance ??= BaseCommon._internal();
    return _instance!;
  }

  Map<String, String> headerRequest({bool isUsingToken = true}) {
    if (isUsingToken) {
      return {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      };
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8'
    };
  }

  Future<void> saveToken(String jwt) async {
    accessToken = jwt;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', jwt);
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
    ownPhone = decodedToken['sub'];
  }

  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = '';
    refreshToken = '';
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken') ?? '';
    refreshToken = prefs.getString('refreshToken') ?? '';
    locale = prefs.getString('locale') ?? 'en';
    log("accessToken: $accessToken");
  }

  Future<void> changeLocale(String value) async {
    locale = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', value);
  }
}
