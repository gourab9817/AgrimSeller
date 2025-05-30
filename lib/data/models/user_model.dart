// User model for authentication
class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? address;
  final String? idNumber;
  final bool isEmailVerified;
  final String? profilePictureUrl;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.phoneNumber,
    this.address,
    this.idNumber,
    this.isEmailVerified = false,
    this.profilePictureUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      idNumber: json['idNumber'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      profilePictureUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'idNumber': idNumber,
      'isEmailVerified': isEmailVerified,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? phoneNumber,
    String? address,
    String? idNumber,
    bool? isEmailVerified,
    String? profilePictureUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      idNumber: idNumber ?? this.idNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }
} 