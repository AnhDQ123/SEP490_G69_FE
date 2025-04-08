class UserProfile {
  final int id;
  final String name;
  final String address;
  final String? avatar;
  final String gender;
  final String dob;
  final String phone;
  final String email;

  UserProfile({
    required this.id,
    required this.name,
    required this.address,
    this.avatar,
    required this.gender,
    required this.dob,
    required this.phone,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      avatar: json['avatar'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
