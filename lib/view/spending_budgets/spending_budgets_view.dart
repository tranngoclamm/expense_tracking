import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/model/transaction.dart';

import 'dart:ui' as ui;

// Để định dạng tháng
import 'dart:math' as math;

import '../../model/user.dart';
import '../../service/transation.dart';

const List<String> chartType = <String>['Chi phí', 'Thu nhập'];
double totalAmount = 2600000; // Tổng số tiền ví dụ
bool isYear = false;
String selectedChartType = "Expense";
String selectTab = 'month'; // Biến để lưu trạng thái của nút được chọn
DateTime selectedDatetime = DateTime.now();

List<Map<String, dynamic>> items = [
  {'name': 'Mua sắm', 'percentage': 46.15},
  {'name': 'Điện thoại', 'percentage': 19.23},
  {'name': 'Sắc đẹp', 'percentage': 19.23},
  {'name': 'Giáo dục', 'percentage': 7.69},
  {'name': 'Khác', 'percentage': 7.69},
];
List<Color> colors = [
  TColor.yellowChart,
  TColor.blueChart,
  TColor.redChart,
  TColor.greenblueChart,
  TColor.greenChart,
];

String formatVN(String number) {
  return number
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
}

List budgetArr = [
  {
    "name": "Mua sắm",
    "icon": "assets/img/auto_&_transport.png",
    "spend_amount": "1200000",
    "total_budget": "400",
    "left_amount": "250.01",
    "color": TColor.secondaryG
  },
  {
    "name": "Điện thoại",
    "icon": "assets/img/entertainment.png",
    "spend_amount": "500000",
    "total_budget": "600",
    "left_amount": "300.01",
    "color": TColor.secondary50
  },
  {
    "name": "Sắc đẹp",
    "icon": "assets/img/security.png",
    "spend_amount": "500000",
    "total_budget": "600",
    "left_amount": "250.01",
    "color": TColor.primary10
  },
  {
    "name": "Giáo dục",
    "icon": "assets/img/auto_&_transport.png",
    "spend_amount": "1200000",
    "total_budget": "400",
    "left_amount": "250.01",
    "color": TColor.secondaryG
  },
  {
    "name": "Khác",
    "icon": "assets/img/entertainment.png",
    "spend_amount": "500000",
    "total_budget": "600",
    "left_amount": "300.01",
    "color": TColor.secondary50
  },
  {
    "name": "Sắc đẹp",
    "icon": "assets/img/security.png",
    "spend_amount": "500000",
    "total_budget": "600",
    "left_amount": "250.01",
    "color": TColor.primary10
  },
  {
    "name": "Mua sắm",
    "icon": "assets/img/auto_&_transport.png",
    "spend_amount": "1200000",
    "total_budget": "400",
    "left_amount": "250.01",
    "color": TColor.secondaryG
  },
  {
    "name": "Điện thoại",
    "icon": "assets/img/entertainment.png",
    "spend_amount": "500000",
    "total_budget": "600",
    "left_amount": "300.01",
    "color": TColor.secondary50
  },
  {
    "name": "Sắc đẹp",
    "icon": "assets/img/security.png",
    "spend_amount": "500000",
    "total_budget": "600",
    "left_amount": "250.01",
    "color": TColor.primary10
  },
  {
    "name": "Mua sắm",
    "icon": "assets/img/auto_&_transport.png",
    "spend_amount": "1200000",
    "total_budget": "400",
    "left_amount": "250.01",
    "color": TColor.secondaryG
  },
  {
    "name": "Điện thoại",
    "icon": "assets/img/entertainment.png",
    "spend_amount": "500000",
    "total_budget": "600",
    "left_amount": "300.01",
    "color": TColor.secondary50
  },
  {
    "name": "Sắc đẹp",
    "icon": "assets/img/security.png",
    "spend_amount": "500000",
    "total_budget": "600",
    "left_amount": "250.01",
    "color": TColor.primary10
  },
  {
    "name": "Mua sắm",
    "icon": "assets/img/auto_&_transport.png",
    "spend_amount": "1200000",
    "total_budget": "400",
    "left_amount": "250.01",
    "color": TColor.secondaryG
  },
  {
    "name": "Điện thoại",
    "icon": "assets/img/entertainment.png",
    "spend_amount": "500000",
    "total_budget": "600",
    "left_amount": "300.01",
    "color": TColor.secondary50
  },
  {
    "name": "Sắc đẹp",
    "icon": "assets/img/security.png",
    "spend_amount": "500000",
    "total_budget": "600",
    "left_amount": "250.01",
    "color": TColor.primary10
  },
];
// Hàm lấy màu cho biểu đồ
Color _getColorForIndex(int index) {
  List<Color> colors = [
    TColor.yellowChart,
    TColor.blueChart,
    TColor.redChart,
    TColor.greenblueChart,
    TColor.greenChart,
  ];
  return colors[index % colors.length];
}

class ChartState with ChangeNotifier {
  DateTime selectedDatetime = DateTime.now();
  String selectedChartType = "Expense";
  bool isYear = false;
  void updateChart(DateTime newDatetime, String newType, bool newIsYear) {
    selectedDatetime = newDatetime;
    selectedChartType = newType;
    isYear = newIsYear;
    notifyListeners(); // Thông báo cập nhật
  }
}
//dropdown_menu
class DropdownMenuExample extends StatefulWidget {
  final Function(String) onChartTypeChanged; // Callback
  const DropdownMenuExample({Key? key, required this.onChartTypeChanged})
      : super(key: key);

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = chartType.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.35, // Chiều rộng là 0.3 chiều rộng màn hình
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none, // Loại bỏ viền
          filled: true, // Tùy chọn có thể đổ màu nền nếu cần
          fillColor: Colors.transparent, // Có thể thay đổi màu nền
        ),
        value: dropdownValue,
        elevation: 15,
        style: const TextStyle(
          fontFamily: 'Poppins-Bold',
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 19,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
          widget.onChartTypeChanged(newValue!);
        },
        items: chartType.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class TabBarExample extends StatefulWidget {
  const TabBarExample({super.key});

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late List<String> _months;
  late List<String> _years;

  @override
  void initState() {
    super.initState();
    final chartState = Provider.of<ChartState>(context, listen: false);
    _months = _generateMonths();
    _years = _generateYears();
    _initTabController(chartState.isYear);
  }

  void _initTabController(bool isYear) {
    List<String> displayedList = isYear ? _years : _months;

    int initialIndex = displayedList.indexOf(isYear ? 'Năm nay' : 'Tháng này');
    if (initialIndex < 0) initialIndex = 0;

    _tabController?.dispose();

    _tabController = TabController(
      length: displayedList.length,
      vsync: this,
      initialIndex: initialIndex,
    )..addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController!.indexIsChanging) {
      final chartState = Provider.of<ChartState>(context, listen: false);
      List<String> displayedList = chartState.isYear ? _years : _months;

      // Kiểm tra xem index có hợp lệ không trước khi truy cập
      if (_tabController!.index < displayedList.length) {
        final selectedItem = displayedList[_tabController!.index];
        final newDatetime = _convertStringToDateTime(selectedItem, chartState.isYear);

        chartState.updateChart(newDatetime, chartState.selectedChartType, chartState.isYear);
      } else {
        debugPrint("⚠️ Lỗi: index ${_tabController?.index} vượt quá danh sách (${displayedList.length})");
      }
    }
  }


  DateTime _convertStringToDateTime(String item, bool isYear) {
    DateTime now = DateTime.now();
    if (isYear) {
      if (item == 'Năm nay') {
        return DateTime(now.year);
      } else if (item == 'Năm ngoái') {
        return DateTime(now.year - 1);
      } else {
        return DateTime(int.parse(item));
      }
    } else {
      if (item == 'Tháng này') {
        return DateTime(now.year, now.month);
      } else if (item == 'Tháng trước') {
        return DateTime(now.year, now.month - 1);
      } else {
        if((item == 'Thg 1 2025')){
          return DateTime(2025, 1);
    }
        print("item: $item");
        List<String> parts = item.split(' ');
        print("parts: $parts");
        String monthText = parts[0];
        int year = int.parse(parts[1]);

        List<String> vietnameseMonths = [
          'Thg 1', 'Thg 2', 'Thg 3', 'Thg 4', 'Thg 5', 'Thg 6',
          'Thg 7', 'Thg 8', 'Thg 9', 'Thg 10', 'Thg 11', 'Thg 12'
        ];

        int monthIndex = vietnameseMonths.indexOf(monthText) + 1;
        print("monthIndex: $monthIndex");
        print("${DateTime(year, monthIndex)}");
        return DateTime(year, monthIndex);
      }
    }
  }
  // Hàm tạo danh sách các tháng từ quá khứ đến hiện tại
  List<String> _generateMonths() {
    DateTime now = DateTime.now();
    DateTime start =
    DateTime(now.year - 1, now.month); // Bắt đầu từ tháng của năm ngoái
    List<String> months = [];

    // Danh sách các tháng bằng tiếng Việt
    List<String> vietnameseMonths = [
      'Thg 1',
      'Thg 2',
      'Thg 3',
      'Thg 4',
      'Thg 5',
      'Thg 6',
      'Thg 7',
      'Thg 8',
      'Thg 9',
      'Thg 10',
      'Thg 11',
      'Thg 12'
    ];

    while (!start.isAfter(now)) {
      // Lấy chỉ số tháng (0-11) và định dạng tháng theo tiếng Việt
      String monthString = vietnameseMonths[start.month - 1];
      String formattedMonth = '$monthString ${start.year}';
      if (start.year == now.year && start.month == now.month) {
        formattedMonth = 'Tháng này'; // Tháng hiện tại
      } else if (start.year == now.year && start.month == now.month - 1) {
        formattedMonth = 'Tháng trước'; // Tháng trước
      }
      months.add(formattedMonth); // Thêm tháng vào danh sách
      start = DateTime(start.year, start.month + 1); // Thêm từng tháng
    }

    return months;
  }

  List<String> _generateYears() {
    DateTime now = DateTime.now();
    int currentYear = now.year;

    List<String> years = [];
    for (int i = currentYear - 5; i <= currentYear; i++) { // Lấy 5 năm trước đến năm nay
      if (i == currentYear) {
        years.add('Năm nay');
      } else if (i == currentYear - 1) {
        years.add('Năm ngoái');
      } else {
        years.add('$i');
      }
    }
    return years;
  }

  void _updateTabController() {
    final chartState = Provider.of<ChartState>(context, listen: false);
    List<String> displayedList = chartState.isYear ? _years : _months;

    _tabController?.dispose();
    _tabController = TabController(
      length: displayedList.length,
      vsync: this,
      initialIndex: displayedList.length - 1,
    )..addListener(_onTabChanged);

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant TabBarExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    final chartState = Provider.of<ChartState>(context, listen: false);
    List<String> displayedList = chartState.isYear ? _years : _months;

    if (_tabController?.length != displayedList.length) {
      _updateTabController();
      // _initTabController(chartState.isYear);
    }
  }


  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chartState = Provider.of<ChartState>(context);
    List<String> displayedList = chartState.isYear ? _years : _months;
    if (_tabController == null || _tabController!.length != displayedList.length) {
      _updateTabController();
      // _initTabController(isYear);
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: displayedList.map((item) => Tab(text: item)).toList(),
              indicatorWeight: 3,
              indicatorColor: TColor.yellowHeader,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: displayedList.map((item) {
                final user = Provider.of<AppUser?>(context);
                final uid = user?.uid;
                return StreamBuilder<Map<String, dynamic>>(
                  stream: TransactionService().getCategorySummary(uid!, chartState.selectedDatetime, chartState.selectedChartType, chartState.isYear), // userId là ID của người dùng hiện tại
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      debugPrint("🔥 Lỗi từ StreamBuilder: ${snapshot.error}");
                      return Center(child: Text(snapshot.error.toString()));
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text("Không có dữ liệu"));
                    }
                    totalAmount = double.tryParse(snapshot.data!['totalAmount'].replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;

                    // Chuyển đổi dữ liệu từ Firestore thành danh sách items
                    List<Map<String, dynamic>> items = (snapshot.data!['categories'] as List)
                        .map((entry) {
                      double categoryAmount = double.tryParse(entry.value.toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0.0;
                      double totalExpenses = double.tryParse(snapshot.data!['totalAmount'].toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0.0;
                      totalAmount = totalExpenses;
                      // Tránh lỗi chia cho 0
                      double percentage = (totalExpenses > 0) ? (categoryAmount / totalExpenses * 100) : 0.0;

                      return {
                        "name": entry.key,
                        "percentage": percentage.toStringAsFixed(2),
                      };
                    }).toList();




                    return _buildTabContent(item, items);
                  },
                );

              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


  // Hàm xây dựng nội dung của từng tab
  Widget _buildTabContent(String month, List<Map<String, dynamic>> items) {
    return Container(
      color: Colors.white, // Nền màu trắng
      padding: const EdgeInsets.only(
        top: 20.0, // Khoảng cách từ trên cùng
        right: 20,
        left: 10,
      ), // Khoảng cách từ các cạnh
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Để phần danh sách căn lên top
        children: [
          // Biểu đồ hình tròn
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 150, // Kích thước biểu đồ
                height: 150,
                child: CustomPaint(
                  painter: IncomePieChart(items), // Vẽ biểu đồ
                ),
              ),
            ),
          ),
          // Danh sách khoản thu
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0), // Khoảng cách từ bên trái
              child: ListView.builder(
                itemCount: items.length, // Số khoản thu giả định
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.3), // Khoảng cách giữa các khoản thu
                    child: Row(
                      children: [
                        // Cột hình tròn màu sắc
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getColorForIndex(
                                index), // Màu tương ứng với biểu đồ
                          ),
                        ),
                        const SizedBox(
                            width: 8), // Khoảng cách giữa cột 1 và cột 2
                        // Cột tên khoản thu
                        Expanded(
                          child:
                              Text(item['name']), // Tên khoản thu từ danh sách
                        ),
                        // Cột % khoản thu
                        Text(
                            '${item['percentage']}%'), // % khoản thu từ danh sách
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


// vẽ biểu đồ hình tròn
class IncomePieChart extends CustomPainter {
  final List<Map<String, dynamic>> items; // Nhận danh sách items

  IncomePieChart(this.items);
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 30; // Độ dày của các phân đoạn
    double gap = 2; // Khoảng cách giữa các phân đoạn
    double radius = size.width / 2;
    double innerRadius = radius - strokeWidth; // Độ dày của lỗ rỗng ở giữa
    double startAngle = -math.pi / 2; // Bắt đầu từ góc 90 độ trên trục dọc

    double totalPercentage =
        items.fold(0, (sum, item) => sum + double.parse(item['percentage']));
    if (totalPercentage == 0) return; // Tránh lỗi nếu tổng phần trăm bằng 0

    List<double> angles = [
      90,
      70,
      60,
      80,
      60
    ]; // Các góc tương ứng % từng khoản thu

    Paint paint = Paint()
      ..style =
          PaintingStyle.fill; // Đặt kiểu vẽ là fill để có màu sắc bên trong

    // Vẽ các phân đoạn với khoảng trống
    for (int i = 0; i < angles.length; i++) {
      double percentage = double.parse(items[i]['percentage']);
      double sweepAngle = (percentage / totalPercentage) * 2 * math.pi;

      paint.color = _getColorForIndex(i);
      // Vẽ phân đoạn
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        sweepAngle - (gap * math.pi / 180), // Thay đổi góc để có khoảng trống
        true,
        paint,
      );

      // Cập nhật góc bắt đầu cho phân đoạn tiếp theo
      startAngle += sweepAngle - (gap * math.pi / 180) + (gap * math.pi / 180);
    }
    print("items: $items");
    // Vẽ đường phân cách giữa các phân đoạn
    Paint borderPaint = Paint()
      ..color = Colors.white // Màu của đường phân cách
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3; // Độ dày của đường phân cách

    startAngle = -math.pi / 2; // Bắt đầu lại từ góc 90 độ

    for (int i = 0; i < angles.length; i++) {
      double sweepAngle = angles[i] * math.pi / 180;

      // Vẽ đường phân cách
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        sweepAngle,
        false,
        borderPaint,
      );

      // Cập nhật góc bắt đầu cho phân đoạn tiếp theo
      startAngle += sweepAngle + (gap * math.pi / 180);
    }

    // Vẽ phần lỗ rỗng ở giữa
    Paint holePaint = Paint()
      ..color = Colors.white // Màu của lỗ rỗng
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), innerRadius, holePaint);
    // Định dạng và vẽ tổng số tiền
    String formattedAmount = _formatAmount(totalAmount);
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: formattedAmount,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12, // Kích thước chữ
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr, // Sử dụng TextDirection từ dart:ui
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    Offset textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  // Hàm định dạng số tiền
  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} triệu';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} trăm';
    } else{
      return '${amount.toStringAsFixed(0)}';
    }
  }
}

class SpendingBudgetsView extends StatefulWidget {
  const SpendingBudgetsView({super.key});

  @override
  State<SpendingBudgetsView> createState() => _SpendingBudgetsViewState();
}

class _SpendingBudgetsViewState extends State<SpendingBudgetsView> {
  void refresh() {
    setState(() {}); // Cập nhật UI khi được gọi
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final chartState = Provider.of<ChartState>(context);
    final uid = user?.uid;

    if (uid == null) {
      return Scaffold(
        body: Center(child: Text("Không tìm thấy người dùng.")),
      );
    }

    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: media.height * 0.5 + 20),

                // ✅ Sử dụng StreamBuilder đúng cách
                StreamBuilder<Map<String, dynamic>>(
                  stream: TransactionService().getTransactionSummary(uid, chartState.selectedDatetime, chartState.selectedChartType, chartState.isYear),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      debugPrint("🔥 Lỗi từ StreamBuilder: ${snapshot.error}");
                      return Center(child: Text("Lỗi: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data == null || (snapshot.data as Map).isEmpty) {
                      debugPrint("📌 Dữ liệu từ StreamBuilde21");

                      return const Center(child: Text("Không có dữ liệu"));

                    }

                    final data = snapshot.data as Map<String, dynamic>;

                    if ((data['transactions'] as List).isEmpty &&
                        (data['budgetSummary'] as List).isEmpty &&
                        data['totalAmount'] == 0) {
                      debugPrint("📌 Dữ liệu từ StreamBuilder1");

                      return const Center(child: Text("Không có dữ liệu"));
                    }

                    debugPrint("📌 Dữ liệu từ StreamBuilder: ${snapshot.data}");


                    // Lấy danh sách budget từ snapshot
                    List<Map<String, dynamic>> budgetArr = snapshot.data!['budgetSummary'];
                    print("Data 2: ${snapshot.data!['budgetSummary']}");

                    // 🛠️ **Fix lỗi thiếu `return`**
                    return ListView.builder(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 80),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: budgetArr.length,
                      itemBuilder: (context, index) {
                        var bObj = budgetArr[index];

                        return BudgetsRow(
                          bObj: bObj,
                          onPressed: () {},
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Header cố định
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: TColor.yellowHeader,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  DropdownMenuExample(
                    onChartTypeChanged: (newType) {
                      setState(() {
                        if(newType == "Chi phí"){
                          selectedChartType = "Expense";
                        }
                        else {
                          selectedChartType = "Income";
                        };
                        Provider.of<ChartState>(context, listen: false).updateChart(
                          DateTime.now(), // Có thể thay đổi thành giá trị khác
                          newType == "Chi phí" ? "Expense" : "Income",
                          false, // Hoặc cập nhật thành true nếu cần lọc theo năm
                        );
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectTab = 'month';
                            });
                            Provider.of<ChartState>(context, listen: false).updateChart(
                              DateTime.now(),
                              selectedChartType,
                              false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectTab == 'month'
                                ? const Color.fromARGB(255, 5, 5, 5)
                                : const Color(0xffFFDA47),
                            side: BorderSide(
                              color: selectTab == 'month'
                                  ? const Color.fromARGB(255, 5, 5, 5)
                                  : Colors.black,
                              width: 0.5,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7.0),
                                bottomLeft: Radius.circular(7.0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 65.0),
                          ),
                          child: Text(
                            'Tháng',
                            style: TextStyle(
                              color: selectTab == 'month'
                                  ? const Color.fromARGB(255, 254, 221, 85)
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectTab = 'year';
                            });
                            Provider.of<ChartState>(context, listen: false).updateChart(
                              DateTime.now(),
                              selectedChartType,
                              true,
                            );

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectTab == 'year'
                                ? const Color.fromARGB(255, 5, 5, 5)
                                : const Color(0xffFFDA47),
                            side: BorderSide(
                              color: selectTab == 'year'
                                  ? const Color.fromARGB(255, 5, 5, 5)
                                  : Colors.black,
                              width: 0.5,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(7.0),
                                bottomRight: Radius.circular(7.0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 65.0),
                          ),
                          child: Text(
                            'Năm',
                            style: TextStyle(
                              color: selectTab == 'year'
                                  ? const Color.fromARGB(255, 254, 221, 85)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.height * 0.34, child: const TabBarExample()),
                  Container(
                    width: media.width,
                    height: 1.5,
                    color: const Color(0xffe3e3e3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//UI data
class BudgetsRow extends StatefulWidget {
  final Map bObj;
  final Function onPressed;

  const BudgetsRow({required this.bObj, required this.onPressed, Key? key}) : super(key: key);

  @override
  _BudgetsRowState createState() => _BudgetsRowState();
}

class _BudgetsRowState extends State<BudgetsRow> {
  late double percentage;

  @override
  void initState() {
    super.initState();
    _calculatePercentage();
  }

  void _calculatePercentage() {
    double spendAmount = double.parse(widget.bObj['spend_amount']);
    double totalAmount = double.parse(widget.bObj['total_budget']);
    setState(() {
      percentage = (spendAmount / totalAmount) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 33,
                    height: 33,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.bObj['color'],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(widget.bObj['icon']),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.bObj['name'] ?? 'Không xác định',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${percentage.toStringAsFixed(2)}%',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatVN(widget.bObj['spend_amount']),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0),
              Row(
                children: [
                  const SizedBox(width: 42),
                  Expanded(
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: min(percentage / 100, 1.0),
                      child: Container(
                        height: 7,
                        decoration: BoxDecoration(
                          color: TColor.yellowHeader,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -8),
          child: const Padding(
            padding: EdgeInsets.only(top: 0, left: 30.0, right: 5),
            child: Divider(
              color: Color.fromARGB(255, 242, 242, 242),
              thickness: 0.5,
            ),
          ),
        )
      ],
    );
  }
}

String formatNumber(dynamic number) {
  if (number == null) return '0';

  // Chuyển thành chuỗi và loại bỏ dấu `.` phân cách hàng nghìn
  String cleanNumber = number.toString().replaceAll('.', '').replaceAll(',', '.');

  // Chuyển về kiểu double
  double? value = double.tryParse(cleanNumber);

  // Nếu lỗi, trả về '0'
  if (value == null) return '0';

  // Định dạng lại số có dấu `.`
  return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(?<=\d)(?=(\d{3})+$)'),
          (match) => '.'
  );
}

String cleanNumber(String number) {
  return number.replaceAll('.', '').replaceAll(',', '.');
}


