// lib/models/user.dart
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
    // ✅ Handle multiple MongoDB ID formats
    String? userId;
    
    if (json['_id'] != null) {
      if (json['_id'] is Map && json['_id']['\$oid'] != null) {
        // Format 1: {"_id": {"$oid": "507f1f77bcf86cd799439011"}}
        userId = json['_id']['\$oid'] as String;
      } else if (json['_id'] is String) {
        // Format 2: {"_id": "507f1f77bcf86cd799439011"}
        userId = json['_id'] as String;
      }
    } else if (json['id'] != null) {
      // Format 3: {"id": "507f1f77bcf86cd799439011"}
      userId = json['id'] as String;
    }

    print('🔍 === USER FROM JSON DEBUG ===');
    print('🔍 Raw _id: ${json['_id']}');
    print('🔍 Parsed userId: $userId');
    print('🔍 Username: ${json['username']}');
    print('🔍 ============================');

    return User(
      id: userId,
      username: json['username'] as String,
      email: json['email'] as String,
      imagePath: json['imagePath'] as String?,
      passwordHash: json['passwordHash'] as String? ?? '',
      defaultAddress: json['defaultAddress'] as String?,
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