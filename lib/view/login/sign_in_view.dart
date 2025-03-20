import 'package:flutter/material.dart';
import 'package:trackizer/view/main_tab/main_tab_view.dart';
import 'package:trackizer/view/login/sign_up_view.dart';
import 'package:trackizer/view/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == "user" && password == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MainTabView()), // Thay HomeScreen bằng màn hình chính nếu có
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Lỗi đăng nhập"),
          content: Text("Tên đăng nhập hoặc mật khẩu không chính xác!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegisterScreen()), // Màn hình đăng ký
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Thêm logo ở đây
            Image.asset(
              'assets/img/iconlogin.png', // Thay bằng đường dẫn tới ảnh logo của bạn
              height: 350, // Tăng chiều cao logo
              width: 350, // Tăng chiều rộng logo nếu cần
            ),
            SizedBox(height: 24),
            // Ô nhập tên đăng nhập
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Tên đăng nhập',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Bo góc 25px
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            SizedBox(height: 16),
            // Ô nhập mật khẩu
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Bo góc 25px
                ),
                prefixIcon: Icon(Icons.lock), // Thêm biểu tượng khóa
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            // Nút đăng nhập
            ElevatedButton(
              onPressed: _login,
              child: Text('Đăng nhập'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0), // Bo góc 25px
                ),
              ),
            ),

            SizedBox(height: 16),
            // Nút chuyển sang màn hình đăng ký
            TextButton(
              onPressed: _goToRegister,
              child: Text('Chưa có tài khoản? Đăng ký ngay'),
            ),
          ],
        ),
      ),
    );
  }
}
