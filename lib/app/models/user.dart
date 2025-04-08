// class UserModel {
//   final int id;
//   final String name;
//   final String phone;
//   final String password;
//   final String token;
//
//   UserModel({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.password,
//     required this.token,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'],
//       name: json['name'],
//       phone: json['phone'],
//       password: json['password'],
//       token: json['token'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'phone': phone,
//       'password': password,
//       'token': token,
//     };
//   }
// }
