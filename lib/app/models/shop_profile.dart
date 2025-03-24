import 'dart:io';

class ShopProfile {
  String name;
  String description;
  String address;
  File? logo;
  String sellType;
  File? citizenIDFront;
  File? citizenIDBack;
  File? registrationCert;
  File? foodSafetyCert;
  File? menu;
  String taxCode;
  String citizenIDNumber;
  String citizenIDExpiredDate;
  String userId;

  ShopProfile({
    required this.name,
    required this.description,
    required this.address,
    this.logo,
    required this.sellType,
    this.citizenIDFront,
    this.citizenIDBack,
    this.registrationCert,
    this.foodSafetyCert,
    this.menu,
    required this.taxCode,
    required this.citizenIDNumber,
    required this.citizenIDExpiredDate,
    required this.userId,
  });

  // Chuyển đổi thành Map<String, String> (chỉ với các dữ liệu dạng text)
  Map<String, String> toMap() {
    return {
      "name": name,
      "description": description,
      "address": address,
      "sellType": sellType,
      "taxCode": taxCode,
      "citizenIDNumber": citizenIDNumber,
      "citizenIDExpiredDate": citizenIDExpiredDate,
      "userId": userId,
    };
  }
}
