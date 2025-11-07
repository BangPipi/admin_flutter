// lib/services/firebase_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';

// KHÔNG CẦN import 'firebase_auth.dart'

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<String?> registerUser(UserModel user) async {
    try {
      // Mật khẩu sẽ được lưu dưới dạng plaintext theo user.toMap()
      DatabaseReference newUserRef = _database.child('users').push();
      await newUserRef.set(user.toMap());

      return newUserRef.key; // Trả về ID (key) mới
    } catch (e) {
      print('Error registering user: $e');
      // Ném lỗi ra để UI (register_screen) bắt
      throw Exception('Lỗi khi đăng ký: $e');
    }
  }

  // Login user (ĐÃ VIẾT LẠI)
  Future<UserModel?> loginUser(String email, String password) async {
    try {
      // 1. Truy vấn database để tìm người dùng có email trùng khớp
      DataSnapshot snapshot = await _database
          .child('users')
          .orderByChild('email')
          .equalTo(email)
          .get();

      if (!snapshot.exists) {
        print('Email không tìm thấy');
        return null; // Không tìm thấy email
      }

      Map<dynamic, dynamic> users = snapshot.value as Map<dynamic, dynamic>;
      
      for (var key in users.keys) {
        var userMap = users[key] as Map<dynamic, dynamic>;
        
        // 3. So sánh mật khẩu plaintext
        if (userMap['password'] == password) {
          // Đúng mật khẩu!
          return UserModel.fromMap(key, userMap);
        }
      }

      print('Sai mật khẩu');
      return null; // Sai mật khẩu
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // Get all users (Admin only) - Giữ nguyên
  Stream<List<UserModel>> getAllUsers() {
    return _database.child('users').onValue.map((event) {
      List<UserModel> users = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> usersMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        usersMap.forEach((key, value) {
          users.add(UserModel.fromMap(key, value as Map<dynamic, dynamic>));
        });
      }
      return users;
    });
  }

  Future<bool> updateUser(String userId, UserModel user) async {
    try {
      // Chỉ cập nhật các trường này
      // Mật khẩu sẽ KHÔNG bị ghi đè
      Map<String, dynamic> updates = {
        'username': user.username,
        'email': user.email,
        'isAdmin': user.isAdmin,
        'imageUrl': user.imageUrl,
      };

      await _database.child('users').child(userId).update(updates);
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Delete user (ĐÃ SỬA - Xóa hoàn toàn)
  Future<bool> deleteUser(String userId) async {
    try {
      // Vì không còn Auth, chỉ cần xóa khỏi RTDB là xong
      await _database.child('users').child(userId).remove();
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }
}
