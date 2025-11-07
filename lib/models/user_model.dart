class UserModel {
  String? id;
  String username;
  String email;
  String password;
  String? imageUrl;
  bool isAdmin;
  DateTime createdAt;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.imageUrl,
    this.isAdmin = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Firebase Map
  factory UserModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return UserModel(
      id: id,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      imageUrl: map['imageUrl'],
      isAdmin: map['isAdmin'] ?? false,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }

  // Copy with method
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? imageUrl,
    bool? isAdmin,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      imageUrl: imageUrl ?? this.imageUrl,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
