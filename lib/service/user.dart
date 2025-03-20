import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackizer/model/user-model.dart';

class UserService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  // Hàm để cập nhật thông tin người dùng
  Future<void> updateUser(UserModel user) async {
    try {
      await _userCollection.doc(user.uid).update(user.toJson());
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Cập nhật quyền của người dùng (chỉ admin có thể làm)
  Future<void> updateUserRole(String adminUid, String targetUid, String newRole) async {
    try {
      UserModel? adminUser = await getUserByUid(adminUid);
      if (adminUser == null || adminUser.role != 'Admin') {
        print('Bạn không có quyền chỉnh sửa vai trò');
        return;
      }

      await _userCollection.doc(targetUid).update({'role': newRole});
      print('Cập nhật vai trò thành công');
    } catch (e) {
      print('Lỗi khi cập nhật vai trò: $e');
    }
  }

  // Hàm để lấy thông tin người dùng theo UID
  Future<UserModel?> getUserByUid(String uid) async {
    try {
      DocumentSnapshot doc = await _userCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

// Lấy danh sách người dùng (chỉ admin mới có thể xem)
  Stream<List<UserModel>> getUsers(String currentUid) async* {
    UserModel? currentUser = await getUserByUid(currentUid);
    if (currentUser == null || currentUser.role != 'Admin') {
      print('Bạn không có quyền xem danh sách tài khoản');
      yield [];
      return;
    }

    yield* _userCollection.snapshots().map((snapshot) {
      print("📄 Firestore trả về ${snapshot.docs.length} tài khoản");

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("📌 Dữ liệu từ Firestore: $data");

        return UserModel.fromJson(data);
      }).toList();
    });
  }

  // Xóa tài khoản (admin có thể xóa tài khoản bất kỳ, user chỉ xóa được tài khoản của chính họ)
  Future<void> deleteUser(String requesterUid, String targetUid) async {
    try {
      UserModel? requester = await getUserByUid(requesterUid);
      if (requester == null) {
        print('Người dùng không tồn tại');
        return;
      }

      // Chỉ admin mới có quyền xóa tài khoản khác, user chỉ xóa được tài khoản của chính họ
      if (requester.role != 'Admin' && requesterUid != targetUid) {
        print('Bạn không có quyền xóa tài khoản này');
        return;
      }

      await _userCollection.doc(targetUid).delete();
      print('Xóa tài khoản thành công');
    } catch (e) {
      print('Lỗi khi xóa tài khoản: $e');
    }
  }

  // Kiểm tra xem người dùng có phải admin không
  Future<bool> isAdmin(String uid) async {
    try {
      UserModel? user = await getUserByUid(uid);
      return user != null && user.role == 'Admin';
    } catch (e) {
      print('Lỗi kiểm tra quyền admin: $e');
      return false;
    }
  }

}


