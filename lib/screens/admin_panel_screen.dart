// lib/screens/admin_panel_screen.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../widgets/user_card.dart';
// ĐÃ THÊM: Import để thêm người dùng
import 'register_screen.dart'; 

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _firebaseService = FirebaseService();

  void _showEditDialog(UserModel user) {
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    // Chúng ta không sửa mật khẩu ở đây
    // Chúng ta sẽ cho admin tự sửa `isAdmin` trong database

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa người dùng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Mật khẩu và isAdmin sẽ được giữ nguyên
              UserModel updatedUser = user.copyWith(
                username: usernameController.text,
                email: emailController.text,
              );

              bool success = await _firebaseService.updateUser(
                user.id!,
                updatedUser,
              );

              // SỬA LỖI ASYNC GAP
              if (!mounted) return;
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? 'Cập nhật thành công!' : 'Cập nhật thất bại!',
                  ),
                ),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa người dùng "${user.username}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Hàm này giờ đã xóa hoàn toàn người dùng
              bool success = await _firebaseService.deleteUser(user.id!);

              // SỬA LỖI ASYNC GAP
              if (!mounted) return;
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? 'Xóa thành công!' : 'Xóa thất bại!',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  // HÀM MỚI ĐỂ THÊM NGƯỜI DÙNG TỪ ADMIN PANEL
  // (Chúng ta tái sử dụng RegisterScreen cho đơn giản)
  void _showAddUserScreen() {
     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _firebaseService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Không có người dùng nào'),
            );
          }

          List<UserModel> users = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserCard(
                user: users[index],
                onEdit: () => _showEditDialog(users[index]),
                onDelete: () => _showDeleteDialog(users[index]),
              );
            },
          );
        },
      ),
      // NÚT MỚI ĐỂ THÊM USER
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserScreen,
        tooltip: 'Thêm người dùng',
        child: const Icon(Icons.add),
      ),
    );
  }
}
