import 'package:flutter/material.dart';
import 'package:trackizer/service/auth.dart';
import '../../common/color_extension.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String pass = '';
  String pass2 = '';
  String error = '';

  void _register() async {
    // Xử lý logic đăng ký

    if (pass == pass2) {
      // Đăng ký thành công
      Navigator.pop(context); // Quay lại màn hình đăng nhập sau khi đăng ký
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Lỗi đăng ký"),
          content: Text("Mật khẩu xác nhận không khớp!"),
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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        backgroundColor: Colors.yellow[700],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/iconregis.png',
                  height: 350,
                  width: 350,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Chưa nhập email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0), // Bo góc 25px
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => pass = val);
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Chưa nhập mật khẩu';
                    } else if (val.length < 6) {
                      return 'Mật khẩu phải lớn hơn 6 kí tự';
                    }
                    return null; // Trả về null nếu hợp lệ
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0), // Bo góc 25px
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => pass2 = val);
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'phải nhập xác nhận mật khẩu';
                    } else if (val.length < 6) {
                      return 'mật khẩu phải lớn hơn 6 kí tự';
                    }
                    return null; // Trả về null nếu hợp lệ
                  },
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  child: Text('Đăng ký'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (pass == pass2) {
                        dynamic result = await _auth
                            .registerWithEmailAndPassword(email, pass);

                        if (result == null) {
                          setState(() => error = 'hãy nhập email hợp lệ');
                        }
                      } else {
                        setState(() => error = 'Xác nhận mật khẩu không khớp');
                      }
                    }
                  },
                ),
                const SizedBox(height: 12.0),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 20.0),
                ),
                const Spacer(),
                Text(
                  "Bạn đã có tài khoản?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.gray70, fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0), // Bo góc 25px
                    ),
                  ),
                  onPressed: () async {
                    widget.toggleView();
                  },
                  child: const Text('Đăng nhập'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
