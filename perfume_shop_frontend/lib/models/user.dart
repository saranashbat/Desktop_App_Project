// user.dart
class User {
  String? id;
  String username;
  String email;
  String? imagePath;
  String passwordHash;
  String? defaultAddress;

  User({
    this.id,
    required this.username,
    required this.email,
    this.imagePath,
    required this.passwordHash,
    this.defaultAddress,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id']?['\$oid'], // if MongoDB ObjectId comes this way
      username: json['username'],
      email: json['email'],
      imagePath: json['imagePath'],
      passwordHash: json['passwordHash'],
      defaultAddress: json['defaultAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'imagePath': imagePath,
      'passwordHash': passwordHash,
      'defaultAddress': defaultAddress,
    };
  }
}
