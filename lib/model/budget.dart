import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  String id;        // ID của ngân sách
  String userId;    // ID của người dùng
  double amount;    // Số tiền ngân sách
  DateTime month;   // Tháng áp dụng ngân sách

  Budget({
    required this.id,
    required this.userId,
    required this.amount,
    required this.month,
  });

  // Chuyển đổi từ JSON sang Object
  Budget.fromJson(Map<String, dynamic> json)
      : this(
    id: json['id'] as String,
    userId: json['userId'] as String,
    amount: (json['amount'] as num).toDouble(),
    month: (json['month'] as Timestamp).toDate(),
  );

  // Tạo bản sao (copy) để cập nhật dữ liệu
  Budget copyWith({String? id, String? userId, double? amount, DateTime? month}) {
    return Budget(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      month: month ?? this.month,
    );
  }

  // Chuyển đổi Object sang JSON để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'month': Timestamp.fromDate(month),
    };
  }
}
