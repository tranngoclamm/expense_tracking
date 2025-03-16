import 'dart:ffi';

import 'package:trackizer/model/category.dart';

class Budget {
  String uid;
  Category category;
  Int32 budget;

  Budget({required this.uid, required this.category, required this.budget});

  Budget.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid']! as String,
            category: json['category']! as Category,
            budget: json['budget']! as Int32);

  Budget copyWith({String? uid, Category? category, Int32? budget}) {
    return Budget(
        uid: uid ?? this.uid,
        category: category ?? this.category,
        budget: budget ?? this.budget);
  }

  Map<String, Object?> toJson() {
    return {'uid': uid, 'category': category, 'budget': budget};
  }
}
