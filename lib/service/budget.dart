import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackizer/model/budget.dart';

class BudgetService {
  final CollectionReference _budgetCollection =
  FirebaseFirestore.instance.collection('budgets');

  Future<void> setOrUpdateBudget(String userId, double amount) async {
    try {
      DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
      QuerySnapshot snapshot = await _budgetCollection
          .where('userId', isEqualTo: userId)
          .where('month', isEqualTo: Timestamp.fromDate(currentMonth))
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Nếu đã có ngân sách, cập nhật số tiền
        await _budgetCollection.doc(snapshot.docs.first.id).update({'amount': amount});
      } else {
        // Nếu chưa có, tạo mới
        Budget newBudget = Budget(
          id: _budgetCollection.doc().id,
          userId: userId,
          amount: amount,
          month: currentMonth,
        );
        await _budgetCollection.doc(newBudget.id).set(newBudget.toJson());
      }
    } catch (e) {
      print("Error setting/updating budget: $e");
    }
  }

  Future<Budget?> getBudgetByUserAndMonth(String userId, DateTime month) async {
    try {
      QuerySnapshot snapshot = await _budgetCollection
          .where('userId', isEqualTo: userId)
          .where('month', isEqualTo: Timestamp.fromDate(DateTime(month.year, month.month, 1)))
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Budget.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching budget: $e');
    }
    return null;
  }
}
