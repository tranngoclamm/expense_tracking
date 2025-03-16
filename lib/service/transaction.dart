import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackizer/model/transaction.dart';
import 'package:intl/intl.dart';

import '../common/color_extension.dart';

class TransactionService {
  final CollectionReference _transactionCollection =
  FirebaseFirestore.instance.collection('transactions');

  // Thêm mới Transaction
  Future<void> addTransaction(Transactions transaction) async {
    try {
      DocumentReference docRef = _transactionCollection.doc();
      await docRef.set(transaction.copyWith(id: docRef.id).toJson());
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

  // Cập nhật Transaction
  Future<void> updateTransaction(Transactions transaction) async {
    try {
      await _transactionCollection
          .doc(transaction.id) // Sử dụng `id` làm document ID
          .update(transaction.toJson());
    } catch (e) {
      print('Error updating transaction: $e');
    }
  }

  // Xóa Transaction
  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionCollection
          .doc(id)
          .delete(); // Sử dụng `id` làm document ID
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

}


