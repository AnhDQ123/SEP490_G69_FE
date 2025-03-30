class ShopProfile {
  final int id;
  final String name;
  final String? description;
  final String logo;
  final String backgroundImage;
  final String? menu;
  final String phone;
  final String openTime;
  final String closeTime;
  final String? registrationCertificate;
  final String? foodSafetyCertificate;
  final String address;
  final String isActive;
  final double rate;
  final int viewCount;
  final bool isShipping;
  final bool isOpening;
  final Owner owner;

  ShopProfile({
    required this.id,
    required this.name,
    this.description,
    required this.logo,
    required this.backgroundImage,
    this.menu,
    required this.phone,
    required this.openTime,
    required this.closeTime,
    this.registrationCertificate,
    this.foodSafetyCertificate,
    required this.address,
    required this.isActive,
    required this.rate,
    required this.viewCount,
    required this.isShipping,
    required this.isOpening,
    required this.owner,
  });

  factory ShopProfile.fromJson(Map<String, dynamic> json) {
    return ShopProfile(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
      backgroundImage: json['backgroundImage'],
      menu: json['menu'],
      phone: json['phone'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      registrationCertificate: json['registrationCertificate'],
      foodSafetyCertificate: json['foodSafetyCertificate'],
      address: json['address'],
      isActive: json['isActive'],
      rate: (json['rate'] as num).toDouble(),
      viewCount: json['viewCount'],
      isShipping: json['isShipping'],
      isOpening: json['isOpening'],
      owner: Owner.fromJson(json['owner']),
    );
  }
}

class Owner {
  final String username;
  final String email;
  final String phone;
  final Profile profile;

  Owner({
    required this.username,
    required this.email,
    required this.phone,
    required this.profile,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      profile: Profile.fromJson(json['profile']),
    );
  }
}

class Profile {
  final int id;
  final String name;
  final String avatar;
  final String? taxCode;
  final String? citizenIDNumber;
  final String? citizenIDCardFront;
  final String? citizenIDCardBack;
  final String? drivingLicenseFront;
  final String? drivingLicenseBack;
  final String? judicialRecord;
  final String? citizenIDExpiredDate;
  final String? drivingLicenseExpiredDate;

  Profile({
    required this.id,
    required this.name,
    required this.avatar,
    this.taxCode,
    this.citizenIDNumber,
    this.citizenIDCardFront,
    this.citizenIDCardBack,
    this.drivingLicenseFront,
    this.drivingLicenseBack,
    this.judicialRecord,
    this.citizenIDExpiredDate,
    this.drivingLicenseExpiredDate,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      taxCode: json['taxCode'],
      citizenIDNumber: json['citizenIDNumber'],
      citizenIDCardFront: json['citizenIDCardFront'],
      citizenIDCardBack: json['citizenIDCardBack'],
      drivingLicenseFront: json['drivingLicenseFront'],
      drivingLicenseBack: json['drivingLicenseBack'],
      judicialRecord: json['judicialRecord'],
      citizenIDExpiredDate: json['citizenIDExpiredDate'],
      drivingLicenseExpiredDate: json['drivingLicenseExpiredDate'],
    );
  }
}
