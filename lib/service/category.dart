import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackizer/model/category.dart'; // Cập nhật đường dẫn của bạn tới model

class CategoryService {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  Future<void> addCategory(Category category) async {
    try {
      DocumentReference docRef = _categoryCollection.doc();

      await docRef.set(category.toJson());
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _categoryCollection.get();
      return snapshot.docs
          .map((doc) => Category.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<void> updateCategory(String docId, Category updatedCategory) async {
    try {
      await _categoryCollection.doc(docId).update(updatedCategory.toJson());
    } catch (e) {
      print('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(String docId) async {
    try {
      await _categoryCollection.doc(docId).delete();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }
}
