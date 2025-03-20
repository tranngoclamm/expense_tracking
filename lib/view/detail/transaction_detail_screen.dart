import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackizer/model/transaction.dart';
import 'package:trackizer/service/transation.dart';
import 'package:trackizer/view/detail/edit_transaction_detail_screen.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Transactions transaction;

  TransactionDetailScreen({required this.transaction});

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late Transactions transaction;

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction; // Khởi tạo transaction
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(transaction.date);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết thông tin'),
        backgroundColor: const Color.fromARGB(255, 254, 221, 85),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  transaction.category.icon,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildDetailRow('Số tiền', '${formatCurrency(transaction.amount)}'),
            SizedBox(height: 16),
            _buildDetailRow(
                'Loại giao dịch',
                transaction.category.type == "Expenses"
                    ? "Chi phí"
                    : "Thu nhập"),
            SizedBox(height: 16),
            _buildDetailRow('Ngày', formattedDate),
            SizedBox(height: 16),
            _buildDescription('Mô tả', transaction.description),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _editTransaction(context); // Gọi hàm chỉnh sửa
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 151, 151, 151),
                    minimumSize: const Size(150, 50),
                  ),
                  child: Text('Sửa'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteTransaction(context, transaction);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(150, 50),
                  ),
                  child: Text('Xóa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            content,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String label, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            description,
            style: TextStyle(fontSize: 16),
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _editTransaction(BuildContext context) async {
    final updatedTransaction = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTransactionScreen(transaction: transaction),
      ),
    );

    // Nếu updatedTransaction không null, cập nhật lại giao dịch
    if (updatedTransaction != null && updatedTransaction is Transactions) {
      setState(() {
        transaction = updatedTransaction; // Cập nhật transaction
      });
    }
  }

  void _deleteTransaction(
      BuildContext context, Transactions transaction) async {
    // Hiển thị hộp thoại xác nhận
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn xóa giao dịch này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại mà không xóa
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                // Gọi hàm xóa từ TransactionService
                await TransactionService().deleteTransaction(transaction.id);
                Navigator.of(context).pop(); // Đóng hộp thoại sau khi xóa
                Navigator.of(context).pop(); // Quay lại màn hình trước đó
              },
              child: const Text('Xóa'),
              style: TextButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  String formatCurrency(int amount) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return currencyFormat.format(amount);
  }
}
