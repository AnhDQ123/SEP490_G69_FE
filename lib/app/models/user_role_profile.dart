class UserRoleProfile {
  final int id;
  final int? shopId;
  final String? shopStatus;
  final int? roleId;
  final String? roleName;
  final String? shipperStatus;

  UserRoleProfile({
    required this.id,
    this.shopId,
    this.shopStatus,
    this.roleId,
    this.roleName,
    this.shipperStatus,
  });

  factory UserRoleProfile.fromJson(Map<String, dynamic> json) {
    return UserRoleProfile(
      id: json['id'],
      shopId: json['shopId'],
      shopStatus: json['shopStatus'],
      roleId: json['roleId'],
      roleName: json['roleName'],
      shipperStatus: json['shipperStatus'],
    );
  }

  bool get isShopOwner => shopId != null && shopStatus == 'ACTIVE';
  bool get isShipper => shipperStatus == 'ACTIVE';

}
