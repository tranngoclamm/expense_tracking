import 'dart:math';
import 'package:trackizer/service/category.dart';
import 'package:trackizer/service/transation.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/model/user.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:trackizer/service/transation.dart';
import 'package:trackizer/view/add_subscription/add_subscription_view.dart';
import 'package:trackizer/view/settings/settings_view.dart';
import '../../common_widget/subscription_cell.dart';
import '../../model/budget.dart';
import '../../service/budget.dart';
import '../../service/gemini.dart';
double? _currentBudget = 0;
String uid = "0";

String normalizeNumber(String input) {
  return input.replaceAll(RegExp(r'[^0-9]'), '');
}

String formatVN(double number) {
  return number.toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
}


class CalenderView extends StatefulWidget {
  const CalenderView({super.key});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  int selectTab = 0;
  double _currentBudget = 0;
  CalendarAgendaController calendarAgendaControllerNotAppBar =
      CalendarAgendaController();
  late DateTime selectedDateNotAppBBar;
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadBudget());
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // ID quảng cáo test
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Quảng cáo banner lỗi: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  Future<void> _loadBudget() async {
    final user = Provider.of<AppUser?>(context, listen: false);
    uid = user!.uid!;
    Budget? budget = await BudgetService().getBudgetByUserAndMonth(uid, DateTime.now());
    if (budget != null) {
      // _currentBudget = budget.amount;
      setState(() {
        _currentBudget = budget.amount;
      });
    } else{
      _currentBudget = 0;
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header với Tab bar
          Container(
            color: TColor.yellowHeader, // Màu vàng của header
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(
                  "Báo cáo", // Tiêu đề chính
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nút "Phân tích"
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectTab =
                                0; // Khi nhấn vào nút này, cập nhật selectTab là 0
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectTab == 0
                              ? Colors.black
                              : TColor.yellowHeader, // Đổi màu khi được chọn
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7.0),
                              bottomLeft: Radius.circular(7.0),
                            ),
                          ),
                          side: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          'Phân tích',
                          style: TextStyle(
                            color: selectTab == 0
                                ? TColor.yellowHeader
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 0),

                    // Nút "Tài khoản"
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectTab =
                                1; // Khi nhấn vào nút này, cập nhật selectTab là 1
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectTab == 1
                              ? Colors.black
                              : TColor.yellowHeader, // Đổi màu khi được chọn
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(7.0),
                              bottomRight: Radius.circular(7.0),
                            ),
                          ),
                          side: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          'Đề xuất',
                          style: TextStyle(
                            color: selectTab == 1
                                ? TColor.yellowHeader
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Tạo khoảng cách

          // Hiển thị nội dung dựa trên giá trị của selectTab
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: selectTab == 0
                  ? _buildPhanTichContent() // Hiển thị nội dung của "Phân tích"
                  : _buildDeXuatContent(), // Hiển thị nội dung của "Tài khoản"
            ),
          ),
        ],
      ),
    );
  }

  // Nội dung khi tab "Phân tích" được chọn
  Widget _buildPhanTichContent() {
    final user = Provider.of<AppUser?>(context);
    uid = user!.uid!;
    DateTime currentMonth = DateTime.now();
    return Column(
      children: [
        StreamBuilder<Map<String, dynamic>>(
          stream: TransactionService().getMonthlySummary(uid, currentMonth),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final totalExpenses = snapshot.data!['totalExpenses'] ?? 0;
              final totalIncome = snapshot.data!['totalIncome'] ?? 0;
              final balance = snapshot.data!['balance'] ?? 0;
              print("totalExpenses1: $totalExpenses");
              print("totalIncome1: $totalIncome");
              print("_currentBudget:1 $_currentBudget");

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Căn lề trái cho nội dung
                      children: [
                        // Tiêu đề và mũi tên điều hướng
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Căn đều các phần tử trong Row
                          children: [
                            Text(
                              "Thống kê hàng tháng",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold, // Chữ in đậm
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 16), // Icon mũi tên điều hướng
                          ],
                        ),
                        const SizedBox(
                            height:
                                10), // Khoảng cách giữa tiêu đề và nội dung bên dưới
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.start, // Căn đều các phần tử
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Căn đều các phần tử
                              children: [
                                Text("Thg ${currentMonth.month}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Spacer(), // Khoảng trống giữa các mục để căn đều
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Chi phí",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text("${totalExpenses}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Số dư",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text("${balance}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Thu nhập",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                Text("${totalIncome}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ngân sách hàng tháng
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      GestureDetector(
                        onTap: _showBudgetInputDialog,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ngân sách hàng tháng",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    value: (_currentBudget > 0)
                                        ? (1.0 - ((double.tryParse(normalizeNumber(totalExpenses)) ?? 0.0) /
                                        (double.tryParse(_currentBudget.toString()) ?? 1.0)))
                                        : 0, // Nếu ngân sách là 0, giá trị = 0 để tránh lỗi NaN
                                    strokeWidth: 4,
                                    backgroundColor: Colors.grey.shade300, // Màu nền vòng tròn
                                    color: TColor.yellowHeader, // Màu tiến trình
                                  ),
                                ),
                                Text(
                                  (_currentBudget > 0)
                                      ? "${(100 - ((double.tryParse(normalizeNumber(totalExpenses)) ?? 0.0) /
                                      (double.tryParse(_currentBudget.toString()) ?? 1.0)) * 100).round()}%"
                                      : "--", // Nếu ngân sách = 0, hiển thị "--"
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),


                              ],
                            ),

                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Còn lại:",
                                        style: TextStyle(
                                            fontSize: 14, color: TColor.gray),
                                      ),
                                      Text(
                                        formatVN((double.tryParse(_currentBudget.toString()) ?? 0) -
                                            (double.tryParse(normalizeNumber(totalExpenses)) ?? 0.0)),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _showBudgetInputDialog,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Ngân sách:",
                                        style: TextStyle(
                                            fontSize: 14, color: TColor.gray),
                                      ),
                                      Text(
                                        formatVN(_currentBudget!),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                              ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Chi phí:",
                                        style: TextStyle(
                                            fontSize: 14, color: TColor.gray),
                                      ),
                                      Text(
                                        "${totalExpenses}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Quảng cáo Banner ở cuối màn hình
                  if (_isAdLoaded)
                    Container(
                      alignment: Alignment.center,
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    ),

                  const SizedBox(height: 30),
                ],
              );
            }
            return const Text("Đã có lỗi xảy ra");
          },
        ),
      ],
    );
  }

  void _showBudgetInputDialog() {
    TextEditingController budgetController = TextEditingController();
    budgetController.text = _currentBudget! > 0 ? _currentBudget.toString() : '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Thiết lập ngân sách hàng tháng",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Nhập số tiền (VNĐ)",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  double newBudget = budgetController.text.isEmpty ? 0 : double.tryParse(budgetController.text) ?? 0;
                  if (newBudget > 1) {
                    await BudgetService().setOrUpdateBudget(uid, newBudget);
                    _loadBudget();
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vui lòng nhập số tiền hợp lệ")),
                    );
                  }
                },
                child: Text("Lưu"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeXuatContent() {
    DateTime currentMonth = DateTime.now();

    return SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
    child: Column(
        children: [

        // --- STREAMBUILDER LẤY DỮ LIỆU CHI TIÊU ---
        StreamBuilder<Map<String, dynamic>>(
          stream: TransactionService().getMonthlySummary(uid, currentMonth),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Không có dữ liệu"));
            }

            Map<String, dynamic> summaryData = snapshot.data!;
            List<Map<String, dynamic>> expenses = (summaryData['transactions'] as List)
                .map((transaction) => {
              "category": transaction.category.name,
              "amount": transaction.amount.toInt(),
            })
                .toList();

            return FutureBuilder<String>(
              future: GeminiAI.getSpendingAdvice(expenses),
              builder: (context, adviceSnapshot) {
                if (adviceSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!adviceSnapshot.hasData || adviceSnapshot.data == null) {
                  return Center(child: Text("Không thể lấy gợi ý chi tiêu"));
                }

                return Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "💡 Gợi ý tiết kiệm từ AI",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        adviceSnapshot.data!,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),

        ],
    ),
        )
    );
  }

// --- HÀM DÙNG CHUNG ĐỂ XÂY DỰNG UI ---
  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: TColor.gray)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: TColor.white,
        side: BorderSide(color: TColor.gray, width: 1.0),
      ),
      child: Text(text, style: TextStyle(color: Colors.black)),
    );
  }

}
