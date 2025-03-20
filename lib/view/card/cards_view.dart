import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/model/user-model.dart';
import 'package:trackizer/model/user.dart';
import 'package:trackizer/service/user.dart';
import 'package:provider/provider.dart';
import 'package:trackizer/view/user_detail/UserDetailScreen.dart';
import 'package:trackizer/view/account_manage/admin_account_screen.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trackizer/view/authenticate/sign_in.dart';

import '../../main.dart';
import '../../service/auth.dart';
import '../reminder/reminder_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Tải thông tin người dùng khi khởi tạo
  }

  Future<void> _loadUserInfo() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    final uid = user?.uid;

    // Gọi hàm lấy thông tin người dùng
    userModel = await UserService().getUserByUid(uid!);
    setState(() {}); // Cập nhật lại trạng thái để làm mới giao diện
  }

  // Hàm mở link đánh giá trên Google Play
  void _openAppReview() async {
    const url = "https://play.google.com/store/apps/details?id=com.komorebi.kakeibo&hl=vi";
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Không thể mở link đánh giá");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context, listen: false);
    final uid = user?.uid;
    return WillPopScope(
      onWillPop: () async {
        _loadUserInfo(); // Khi quay trở lại, gọi lại hàm để load lại dữ liệu
        return true; // Cho phép quay lại
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 254, 221, 85),
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: userModel == null
            ? const Center(
                child: CircularProgressIndicator()) // Hiển thị vòng tròn tải
            : Column(
                children: [
                  // Phần header thông tin người dùng
                  Container(
                    color: const Color.fromARGB(255, 254, 221, 85),
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () async {
                        // Điều hướng đến màn hình chi tiết người dùng
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailScreen(
                                userModel:
                                    userModel!), // Truyền userModel vào màn hình chi tiết
                          ),
                        );
                        _loadUserInfo(); // Load lại dữ liệu khi quay lại từ UserDetailScreen
                      },
                      child: Row(
                        children: [
                          // Ảnh đại diện
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              userModel?.avatar?.replaceAll('\\', '/') ??
                                  'assets/img/avatar.png', // Đường dẫn ảnh đại diện
                            ),
                            radius: 30,
                          ),
                          const SizedBox(width: 16),
                          // Thông tin tên và ID người dùng
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel?.name ?? 'Chưa có tên',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'ID: ${userModel?.uid ?? 'Chưa có ID'}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Danh sách các mục
                  Expanded(
                    child: ListView(
                      children: [
                        FutureBuilder<bool>(
                          future: UserService().isAdmin(uid!), // Kiểm tra quyền admin
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(); // Tránh hiển thị menu khi đang kiểm tra
                            }
                            if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
                              return SizedBox(); // Nếu không phải admin thì ẩn đi
                            }
                            return buildMenuItem(
                              icon: Icons.star,
                              text: 'Quản lý tài khoản',
                              iconColor: Colors.orange,
                              onTap: () {
                                print("Đã ấn vào Quản lý tài khoản");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AdminAccountScreen()),
                                );
                              },
                            );
                          },
                        ),
                        buildMenuItem(
                          icon: Icons.thumb_up_alt_outlined,
                          text: 'Giới thiệu cho bạn bè',
                          iconColor: Colors.yellow[700]!,
                          onTap: () {
                            const appLink = "https://play.google.com/store/apps/details?id=com.example.app"; // Link ứng dụng
                            Clipboard.setData(ClipboardData(text: appLink)); // Sao chép vào clipboard
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Đã sao chép link ứng dụng!")),
                            );
                          },
                        ),
                        buildMenuItem(
                          icon: Icons.rate_review_outlined,
                          text: 'Đánh giá ứng dụng',
                          iconColor: Colors.orange,
                          onTap: _openAppReview,
                        ),
                        buildMenuItem(
                          icon: Icons.block,
                          text: 'Chặn quảng cáo',
                          iconColor: Colors.orange,
                        ),
                        buildMenuItem(
                          icon: Icons.add_alert_rounded,
                          text: 'Thông báo',
                          iconColor: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReminderScreen()),
                            );
                          },
                        ),
                        const Divider(), // Thêm ngăn cách giữa các mục
                        // Mục Đăng xuất
                        buildMenuItem(
                          icon: Icons.logout,
                          text: 'Đăng xuất',
                          iconColor: Colors.red,
                          onTap: () async {
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
                          },


                        ),

                        // Thêm mục mới ở đây
                        buildMenuItem(
                          icon: Icons.delete_forever,
                          text: 'Xóa tài khoản',
                          iconColor: Colors.red,
                          onTap: () async {
                            String? userUid = FirebaseAuth.instance.currentUser?.uid;

                            if (userUid == null) {
                              print("⚠️ Không tìm thấy UID người dùng!");
                              return;
                            }

                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Xác nhận xóa tài khoản"),
                                  content: const Text("Bạn có chắc chắn muốn xóa tài khoản này? Hành động này không thể hoàn tác."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text("Hủy"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text("Xóa"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              try {
                                await UserService().deleteUser(userUid, userUid); // Xóa tài khoản khỏi Firestore
                                print("✅ Tài khoản đã được xóa");
                                await AuthService().signOut();
                                // Chuyển về màn hình đăng nhập sau khi xóa tài khoản
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyApp()), // Đưa về màn hình khởi động
                                      (route) => false,
                                );

                              } catch (e) {
                                print("⚠️ Lỗi khi xóa tài khoản: $e");
                              }
                            }
                          },
                        ),

                      ],
                    ),
                  ),
                  // Thanh điều hướng dưới
                  BottomNavigationBar(
                    backgroundColor: Colors.white,
                    selectedItemColor: Colors.yellow[700],
                    unselectedItemColor: Colors.black54,
                    currentIndex: 4,
                    onTap: (index) {},
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Trang chủ',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.bar_chart),
                        label: 'Biểu đồ',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle,
                            size: 40, color: Colors.yellow[700]!),
                        label: '',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.report),
                        label: 'Báo cáo',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Tôi',
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  // Hàm để xây dựng một mục trong danh sách
  Widget buildMenuItem({
    required IconData icon,
    required String text,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(text),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
      onTap: () {
        if (onTap != null) {
          onTap(); // Gọi hàm onTap từ tham số
        }
      },
    );
  }
}
