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

  // Hàm để lấy danh sách người dùng (như đã có trước đó)
  Stream<List<UserModel>> getUsers() {
    return _userCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
