import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:trackizer/service/user.dart';
import 'package:trackizer/model/user-model.dart';
import 'package:trackizer/model/user.dart';

class AdminAccountScreen extends StatefulWidget {
  @override
  _AdminAccountScreenState createState() => _AdminAccountScreenState();
}

class _AdminAccountScreenState extends State<AdminAccountScreen> {
  late String currentUid;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AppUser?>(context, listen: false);
    currentUid = user?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý tài khoản',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 254, 221, 85),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: UserService().getUsers(currentUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          print("Tài khoản: $snapshot.data");
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có người dùng nào."));
          }

          List<UserModel> users = snapshot.data!;
          print("Tài khoản: $users");
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar ?? 'https://i.pravatar.cc/150'),
                        radius: 25,
                      ),

                      // Email
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(user.email ?? 'Unknown'),
                        ),
                      ),

                      // Role + Chỉnh sửa
                      Row(
                        children: [
                          Text(user.role),
                          if (currentUid != user.uid) // Không cho tự chỉnh sửa mình
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showRoleDialog(user),
                            ),
                        ],
                      ),

                      // Nút xóa (Admin mới được xóa)
                      if (currentUid != user.uid)
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteUser(user.uid),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Hộp thoại chỉnh sửa quyền
  void _showRoleDialog(UserModel user) {
    String selectedRole = user.role;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Chỉnh sửa quyền"),
          content: DropdownButton<String>(
            value: selectedRole,
            items: ["User", "Admin"].map((String role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  UserService().updateUserRole(currentUid, user.uid, value);
                });
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              child: Text("Hủy"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // Hàm xóa tài khoản
  void deleteUser(String targetUid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa"),
          content: Text("Bạn có chắc chắn muốn xóa tài khoản này không?"),
          actions: [
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Xóa"),
              onPressed: () {
                UserService().deleteUser(currentUid, targetUid);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
