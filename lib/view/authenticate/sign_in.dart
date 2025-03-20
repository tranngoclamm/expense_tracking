import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/service/auth.dart';
import '../../common/color_extension.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String pass = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
        backgroundColor: Colors.yellow[700],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/iconlogin.png',
                  height: 350,
                  width: 350,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0), // Bo góc 25px
                    ),
                    prefixIcon: const Icon(Icons.person),
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
                  height: 16,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0), // Bo góc 25px
                    ),
                    prefixIcon: const Icon(Icons.lock), // Thêm biểu tượng khóa
                  ),
                  onChanged: (val) {
                    setState(() => pass = val);
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Chưa nhập mật khẩu';
                    } else if (val.length < 6) {
                      return 'Mật khẩu phải ít nhất 6 kí tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  child: Text('Đăng nhập'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0), // Bo góc 25px
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      dynamic result =
                          await _auth.signInWithEmailAndPassword(email, pass);

                      // Kiểm tra lỗi trả về thay vì chỉ kiểm tra null
                      if (result is FirebaseAuthException) {
                        setState(
                            () => error = result.message ?? 'Lỗi đăng nhập');
                      } else if (result == null) {
                        setState(() => error = 'Sai email hoặc mật khẩu');
                      }
                    }
                  },
                ),
                Text(
                  error,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 117, 88, 86), fontSize: 20.0),
                ),
                const Spacer(),
                Text(
                  "Bạn chưa có tài khoản?",
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
                  child: const Text('Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
