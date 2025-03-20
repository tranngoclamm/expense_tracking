import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackizer/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackizer/model/user-model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<AppUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        UserModel userModel = UserModel(
            uid: user.uid,
            name: "unknown",
            email: email,
            role: "User",
            avatar: "assets\\img\\avatar.png",
            gender: "Other");
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());

      // Trả về lỗi chi tiết hơn để giúp debug và hiển thị lỗi
      return e;
    }
  }
}
