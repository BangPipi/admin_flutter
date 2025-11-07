// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
// Bỏ import 'firebase_service.dart' (Không cần ở đây nữa)
import 'admin_panel_screen.dart';
import 'login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  final UserModel currentUser;
  // ĐÃ BỎ `_firebaseService`

  HomeScreen({Key? key, required this.currentUser}) : super(key: key);

  // ĐÃ SỬA HÀM NÀY
  Future<void> _logout(BuildContext context) async {
    // Không cần gọi service, chỉ cần điều hướng về màn hình Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Giữ nguyên UI của HomeScreen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                backgroundImage: currentUser.imageUrl != null
                    ? CachedNetworkImageProvider(currentUser.imageUrl!)
                    : null,
                child: currentUser.imageUrl == null
                    ? const Icon(Icons.person, size: 80)
                    : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Xin chào, ${currentUser.username}!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                currentUser.email,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: currentUser.isAdmin ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentUser.isAdmin ? 'ADMIN' : 'USER',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (currentUser.isAdmin)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminPanelScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text(
                      'Quản lý người dùng',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Thông tin tài khoản',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      _buildInfoRow('Username', currentUser.username),
                      _buildInfoRow('Email', currentUser.email),
                      // Mật khẩu được hiển thị ở đây nếu bạn muốn
                      // _buildInfoRow('Password', currentUser.password),
                      _buildInfoRow(
                        'Ngày tạo',
                        '${currentUser.createdAt.day}/${currentUser.createdAt.month}/${currentUser.createdAt.year}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}
