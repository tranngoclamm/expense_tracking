import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:trackizer/model/category.dart';

class Transactions {
  String id;
  String uid;
  int amount;
  Category category;
  String description;
  DateTime date;

  Transactions({
    required this.id,
    required this.uid,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      id: json['id'],
      uid: json['uid'],
      amount: json['amount'],
      category: Category.fromJson(json['category']),
      description: json['description'],
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'amount': amount,
      'category': category.toJson(), // Chuyển đối tượng Category thành Map
      'description': description,
      'date': date,
    };
  }

  String getWeekday() {
    return DateFormat.EEEE().format(date);
  }

  Transactions copyWith(
      {String? id,
      String? uid,
      int? amount,
      Category? category,
      String? description,
      DateTime? date}) {
    return Transactions(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        description: description ?? this.description,
        date: date ?? this.date);
  }
}
