import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  // Thay đổi thông tin này sau khi đăng ký Cloudinary
  static const String CLOUD_NAME = 'dgfdjsfuj'; // Ví dụ: dxxxxx
  static const String UPLOAD_PRESET = 'unsigned_present'; // Tên preset bạn tạo

  final CloudinaryPublic cloudinary = CloudinaryPublic(
    CLOUD_NAME,
    UPLOAD_PRESET,
    cache: false,
  );

  // Upload image
  Future<String?> uploadImage(File imageFile) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: 'flutter_users',
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      return response.secureUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Delete image (optional - cần API Key và Secret)
  Future<bool> deleteImage(String publicId) async {
    try {
      // Note: Delete requires API credentials, not available in cloudinary_public
      // You would need to use cloudinary package with API key and secret
      // For now, we'll just return true
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }
}
