import 'package:flutter/material.dart';
import 'package:trackizer/model/user-model.dart';
import 'package:trackizer/service/user.dart'; // Import UserService để cập nhật Firestore
import 'package:flutter/services.dart'; // Để sử dụng Clipboard
import 'package:image_picker/image_picker.dart'; // Để sử dụng ImagePicker
import 'dart:io';

import '../../main.dart';
import '../../service/auth.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel userModel;

  UserDetailScreen({required this.userModel});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final ImagePicker _picker = ImagePicker();
  final UserService _userService = UserService();
  late UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel; // Khởi tạo từ model được truyền vào
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 254, 221, 85),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _showImageSourceDialog(context);
              },
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    userModel.avatar.replaceAll('\\', '/'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildListTile(
              title: 'ID',
              value: userModel.uid,
              icon: Icons.copy,
              onTap: () {
                _copyToClipboard(userModel.uid, context);
              },
            ),
            _buildListTile(
              title: 'Tên nick',
              value: userModel.name,
              icon: Icons.edit,
              onTap: () {
                _showEditDialog(context, 'Tên nick', userModel.name,
                    (newValue) {
                  _updateUserName(newValue);
                });
              },
            ),
            _buildListTile(
              title: 'Gmail',
              value: userModel.email,
              icon: Icons.edit,
              onTap: () {
                _showEditDialog(context, 'Email', userModel.email,
                        (newValue) {
                      _updateUserEmail(newValue);
                    });
              },
            ),
            _buildListTile(
              title: 'Giới tính',
              value: getDisplayGender(userModel.gender),
              icon: Icons.edit,
              onTap: () {
                _showGenderDialog(context, userModel.gender, (newGender) {
                  _updateUserGender(newGender);
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                onPressed: () async{
                    try {
                      await AuthService().signOut(); // Đợi signOut hoàn tất

                      // Chuyển về màn hình đăng nhập sau khi đăng xuất
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                            (route) => false,
                      );
                    } catch (e) {
                      print("⚠️ Lỗi khi đăng xuất: $e");
                    }

                  // Xử lý đăng xuất
                },
                child: const Text('Đăng xuất', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm cập nhật tên nick người dùng
  Future<void> _updateUserName(String newName) async {
    setState(() {
      userModel.name = newName; // Cập nhật trên giao diện
    });
    try {
      await _userService.updateUser(userModel);
      print("Tên nick đã được cập nhật thành công.");
    } catch (e) {
      print("Lỗi khi cập nhật tên nick: $e");
    }
  }

  // Hàm cập nhật gmail người dùng
  Future<void> _updateUserEmail(String newEmail) async {
    setState(() {
      userModel.email = newEmail; // Cập nhật trên giao diện
    });
    try {
      await _userService.updateUser(userModel);
      print("Gmail đã được cập nhật thành công.");
    } catch (e) {
      print("Lỗi khi cập nhật Gmail: $e");
    }
  }

  // Hàm cập nhật giới tính người dùng
  Future<void> _updateUserGender(String newGender) async {
    setState(() {
      userModel.gender = newGender; // Cập nhật trên giao diện
    });
    try {
      await _userService.updateUser(userModel);
      print("Giới tính đã được cập nhật thành công.");
    } catch (e) {
      print("Lỗi khi cập nhật giới tính: $e");
    }
  }

  // Xây dựng ListTile để hiển thị thông tin người dùng
  Widget _buildListTile({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        subtitle: Text(value, style: const TextStyle(color: Colors.grey)),
        trailing: Icon(icon, color: Colors.black54),
        onTap: onTap,
      ),
    );
  }

  // Hiện hộp thoại chỉnh sửa tên
  void _showEditDialog(BuildContext context, String title, String currentValue,
      Function(String) onSubmit) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sửa $title'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Nhập tên mới"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onSubmit(controller.text); // Gọi hàm onSubmit để cập nhật
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  // Hiện hộp thoại chọn giới tính
  void _showGenderDialog(
      BuildContext context, String currentGender, Function(String) onSubmit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn giới tính'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Nam'),
                value: 'male',
                groupValue: currentGender,
                onChanged: (value) {
                  onSubmit(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Nữ'),
                value: 'female',
                groupValue: currentGender,
                onChanged: (value) {
                  onSubmit(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Khác'),
                value: 'other',
                groupValue: currentGender,
                onChanged: (value) {
                  onSubmit(value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm chuyển đổi giá trị giới tính từ cơ sở dữ liệu thành giá trị hiển thị
  String getDisplayGender(String gender) {
    switch (gender) {
      case 'male':
        return 'Nam';
      case 'female':
        return 'Nữ';
      case 'other':
      default:
        return 'Khác';
    }
  }

  // Sao chép ID vào clipboard
  void _copyToClipboard(String id, BuildContext context) {
    Clipboard.setData(ClipboardData(text: id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã sao chép ID vào clipboard')),
    );
  }

  // Hiện hộp thoại chọn nguồn ảnh
  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn nguồn ảnh'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text('Lấy từ album'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Chọn ảnh từ camera hoặc album
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Xử lý ảnh được chọn
      setState(() {
        userModel.avatar = imageFile.path;
      });
      try {
        await _userService.updateUser(userModel);
        print("Ảnh đại diện đã được cập nhật.");
      } catch (e) {
        print("Lỗi khi cập nhật ảnh đại diện: $e");
      }
    }
  }
}
