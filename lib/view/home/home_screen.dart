import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:trackizer/model/transaction.dart';
import 'package:trackizer/model/user.dart';
import 'package:trackizer/service/transation.dart';
import 'package:trackizer/view/detail/transaction_detail_screen.dart';
import 'package:trackizer/view/detail/edit_transaction_detail_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: selectedDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String formatCurrency(int amount) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return currencyFormat.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final uid = user?.uid;

    // print("Current UID: $uid"); // Kiểm tra UID có tồn tại không

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ Thu Chi', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 254, 221, 85),
      ),
      body: Column(
        children: [
          StreamBuilder<Map<String, dynamic>>(
            stream: TransactionService().getMonthlySummary(uid!, selectedDate),
            builder: (context, snapshot) {
              print("getMonthlySummary - ConnectionState: ${snapshot.connectionState}");

              if (snapshot.connectionState == ConnectionState.waiting) {
                print("Waiting for data...");
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                print("Error in getMonthlySummary: ${snapshot.error}");
                return Text("Lỗi: ${snapshot.error}");
              }

              print("Transaction snapshot data: ${snapshot.data}");

              if (snapshot.hasData) {
                final totalExpenses = snapshot.data!['totalExpenses'] ?? 0;
                final totalIncome = snapshot.data!['totalIncome'] ?? 0;
                final balance = snapshot.data!['balance'] ?? 0;

                return Container(
                  color: const Color.fromARGB(255, 254, 221, 85),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${selectedDate.year}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Thg ${selectedDate.month}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Chi phí", style: TextStyle(color: Colors.black)),
                          Text("$totalExpenses", style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Thu nhập", style: TextStyle(color: Colors.black)),
                          Text("$totalIncome", style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Số dư", style: TextStyle(color: Colors.black)),
                          Text("$balance", style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return const Text("Không có dữ liệu");
            },
          ),
          Expanded(
            child: StreamBuilder<List<Transactions>>(
              stream: TransactionService().getTransactions(uid, selectedDate),
              builder: (context, snapshot) {
                print("getTransactions - ConnectionState: ${snapshot.connectionState}");

                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("Waiting for transactions...");
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print("Error in getTransactions: ${snapshot.error}");
                  return Text("Lỗi: ${snapshot.error}");
                }

                print("Transactions snapshot data: ${snapshot.data}");

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final transactions = snapshot.data!;

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Slidable(
                        key: ValueKey(transaction.id),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditTransactionScreen(
                                      transaction: transaction,
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Sửa',
                            ),
                            SlidableAction(
                              onPressed: (context) async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Xác nhận xóa'),
                                    content: const Text('Bạn có chắc chắn muốn xóa giao dịch này không?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(false),
                                        child: const Text('Hủy'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          TransactionService().deleteTransaction(transaction.id);
                                          Navigator.of(ctx).pop(true);
                                        },
                                        child: const Text('Xóa'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Xóa',
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            transaction.category.icon,
                            width: 40,
                            height: 40,
                          ),
                          title: Text(
                            transaction.category.name.isNotEmpty
                                ? transaction.category.name
                                : transaction.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(transaction.category.type == 'Expense'
                              ? 'Chi phí'
                              : 'Thu nhập'),
                          trailing: Text(
                            transaction.category.type == 'Expense'
                                ? "-${formatCurrency(transaction.amount)}"
                                : formatCurrency(transaction.amount),
                            style: TextStyle(
                              color: transaction.category.type == 'Expense'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailScreen(
                                    transaction: transaction),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }

                return const Text("Không có giao dịch nào trong tháng này.");
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Transactions transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc muốn xóa giao dịch này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại mà không xóa
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                await TransactionService().deleteTransaction(
                    transaction.id); // Gọi hàm xóa giao dịch từ Firestore
                Navigator.of(context).pop(); // Đóng hộp thoại sau khi xóa
              },
              child: Text('Xóa'),
              style: TextButton.styleFrom(
                iconColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
