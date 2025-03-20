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

  Stream<List<Transactions>> getTransactions(String uid, DateTime month) {
    DateTime startOfMonth = DateTime(month.year, month.month, 1);
    DateTime endOfMonth = DateTime(month.year, month.month + 1, 0);

    print("Fetching transactions for UID: $uid, Month: $month");

    return _transactionCollection
        .where('uid', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .snapshots()
        .map((snapshot) {
      print("Fetched ${snapshot.docs.length} transactions");
      return snapshot.docs
          .map((doc) {
        print("Transaction Data: ${doc.data()}");
        return Transactions.fromJson(doc.data() as Map<String, dynamic>);
      })
          .toList();
    });
  }

  String formatCurrency(int amount) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'vi_VN', // Định dạng cho Việt Nam
      symbol: '', // Không cần ký hiệu "₫"
      decimalDigits: 0, // Không có số lẻ
    );
    return currencyFormat.format(amount);
  }

  Stream<Map<String, dynamic>> getMonthlySummary(String uid, DateTime month) {
    DateTime startOfMonth = DateTime(month.year, month.month, 1);
    DateTime endOfMonth = DateTime(month.year, month.month + 1, 0);

    print("Fetching monthly summary for UID: $uid, Month: $month");

    var transactionsStream = _transactionCollection
        .where('uid', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .snapshots()
        .map((snapshot) {
      print("Fetched ${snapshot.docs.length} transactions for summary");
      return snapshot.docs
          .map((doc) =>
          Transactions.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });

    return transactionsStream.map((transactions) {
      int totalExpenses = 0;
      int totalIncome = 0;

      for (var transaction in transactions) {
        print("Processing transaction: ${transaction.toJson()}");
        if (transaction.category.type == 'Expense') {
          totalExpenses += transaction.amount.toInt();
        } else if (transaction.category.type == 'Income') {
          totalIncome += transaction.amount.toInt();
        }
      }

      print("Total Expenses: $totalExpenses, Total Income: $totalIncome");

      return {
        'transactions': transactions,
        'totalExpenses': formatCurrency(totalExpenses),
        'totalIncome': formatCurrency(totalIncome),
        'balance': formatCurrency(totalIncome - totalExpenses)
      };
    });
  }

  Stream<Map<String, dynamic>> getCategorySummary(
      String uid, DateTime date, String filterType, bool isYearly) {

    // Xác định khoảng thời gian cần lọc
    DateTime startDate, endDate;
    if (isYearly) {
      // Lọc theo năm
      startDate = DateTime(date.year, 1, 1);
      endDate = DateTime(date.year + 1, 1, 0);
    } else {
      // Lọc theo tháng
      startDate = DateTime(date.year, date.month, 1);
      endDate = DateTime(date.year, date.month + 1, 0);
    }

    print("Fetching transactions for UID: $uid from $startDate to $endDate");
    print("Type: $filterType");

    // Lọc giao dịch theo UID, ngày tháng, và loại (Income/Expense)
    var transactionsStream = _transactionCollection
        .where('uid', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .where('category.type', isEqualTo: filterType) // Lọc theo Income hoặc Expense
        .snapshots()
        .map((snapshot) {
      print("Fetched ${snapshot.docs.length} transactions");
      return snapshot.docs
          .map((doc) {
        print("Transaction Data: ${doc.data()}");
        return Transactions.fromJson(doc.data() as Map<String, dynamic>);
      })
          .toList();
    });

    return transactionsStream.map((transactions) {
      Map<String, int> categoryTotals = {};
      int totalAmount = 0;

      for (var transaction in transactions) {
        String category = transaction.category.name;
        int amount = transaction.amount.toInt();

        totalAmount += amount;

        if (categoryTotals.containsKey(category)) {
          categoryTotals[category] = categoryTotals[category]! + amount;
        } else {
          categoryTotals[category] = amount;
        }
      }

      print("Total $filterType: $totalAmount");
      print("Category Totals: $categoryTotals");

      // Sắp xếp danh mục theo số tiền giảm dần
      List<MapEntry<String, int>> sortedCategories = categoryTotals.entries
          .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Lấy 5 danh mục có số tiền lớn nhất
      List<MapEntry<String, int>> top5Categories = sortedCategories.take(4).toList();

      // Gộp các danh mục còn lại vào mục "Other"
      int othersTotal = sortedCategories.skip(4).fold(0, (sum, item) => sum + item.value);

      // Chuẩn bị dữ liệu cho biểu đồ
      Map<String, dynamic> chartData = {
        'totalAmount': formatCurrency(totalAmount),
        'categories': [
          ...top5Categories.map((entry) =>
              MapEntry(entry.key, formatCurrency(entry.value))),
          if (othersTotal > 0) MapEntry('Khác', formatCurrency(othersTotal)),
        ]
      };

      print("Final Chart Data: $chartData");
      return chartData;
    });
  }

  Stream<Map<String, dynamic>> getTransactionSummary(
      String uid, DateTime date, String filterType, bool isYearly) {

    // Xác định khoảng thời gian cần lọc
    DateTime startDate, endDate;
    if (isYearly) {
      startDate = DateTime(date.year, 1, 1);
      endDate = DateTime(date.year + 1, 1, 0);
    } else {
      startDate = DateTime(date.year, date.month, 1);
      endDate = DateTime(date.year, date.month + 1, 0);
    }

    print("Fetching transaction summary for UID: $uid, From: $startDate to $endDate, Type: $filterType");

    var transactionsStream = _transactionCollection
        .where('uid', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .where('category.type', isEqualTo: filterType) // Lọc theo Income hoặc Expense
        .snapshots()
        .map((snapshot) {
      print("Fetched ${snapshot.docs.length} transactions for summary");
      return snapshot.docs
          .map((doc) => Transactions.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });

    return transactionsStream.map((transactions) {
      Map<String, int> categoryTotals = {};
      Map<String, String> categoryIcons = {}; // ✅ Lưu icon theo danh mục
      int totalAmount = 0;

      // ✅ Gộp danh mục trùng và lưu icon
      for (var transaction in transactions) {
        String category = transaction.category.name;
        String icon = transaction.category.icon; // ✅ Lấy icon
        int amount = transaction.amount.toInt();

        categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
        categoryIcons[category] = icon; // ✅ Lưu icon theo tên danh mục
        totalAmount += amount;
      }

      // ✅ Tạo danh sách chi tiết chi tiêu
      List<Map<String, dynamic>> budgetSummary = categoryTotals.entries.toList().asMap().entries.map((indexedEntry) {
        int index = indexedEntry.key; // Lấy chỉ số danh mục
        String categoryName = indexedEntry.value.key; // Tên danh mục
        int categoryAmount = indexedEntry.value.value; // Số tiền danh mục

        return {
          "name": categoryName,
          "icon": categoryIcons[categoryName], // Lấy icon từ danh sách
          "spend_amount": categoryAmount.toString(),
          "total_budget": totalAmount.toString(),
          "left_amount": (totalAmount - categoryAmount).toString(),
          "color": _getColorForCategory((index % 5) + 1),  // ✅ Chia dư để lấy màu
        };
      }).toList();


      print("Total $filterType: $totalAmount");

      return {
        'transactions': transactions,
        'totalAmount': formatCurrency(totalAmount),
        'budgetSummary': budgetSummary
      };
    });
  }



// Hàm lấy màu cho từng loại danh mục
  Color _getColorForCategory(int category) {
    switch (category) {
      case 1:
        return TColor.yellowChart;
      case 2:
        return TColor.blueChart;
      case 3:
        return TColor.redChart;
      case 4:
        return TColor.greenblueChart;
      case 5:
        return TColor.greenChart;
      default:
        return TColor.primary10; // Mặc định nếu có lỗi
    }
  }



}


