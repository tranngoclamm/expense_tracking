import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../common_widget/icon_item_row.dart';
import 'package:trackizer/view/calender/calender_view.dart';

class SettingsView extends StatefulWidget {
  final int selectTab; // Thêm tham số selectTab
  const SettingsView({super.key, required this.selectTab}); // Sử dụng required để yêu cầu tham số này

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late int selectTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
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
                      width: MediaQuery.of(context).size.width *
                          0.35, // Chiều rộng của tab là 35% chiều rộng màn hình
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectTab = 0; // Gắn tab là 0 khi nhấn "Phân tích"
                            // Hiển thị trang CalendarView khi tab "Phân tích" được nhấn
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CalenderView()),
                            );
                          });
                        },
                        // Tùy chỉnh kiểu nút
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectTab == 0
                              ? const Color.fromARGB(
                                  255, 5, 5, 5) // Nền đen khi được chọn
                              : const Color(
                                  0xffFFDA47), // Nền vàng khi không được chọn
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  15), // Padding theo chiều dọc để tăng chiều cao của nút
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  7.0), // Bo góc trái trên của nút
                              bottomLeft: Radius.circular(
                                  7.0), // Bo góc trái dưới của nút
                            ),
                          ),
                          side: const BorderSide(
                            color:
                                Colors.black, // Đường viền của nút là màu đen
                            width: 1.0, // Độ dày của đường viền
                          ),
                        ),
                        // Nội dung hiển thị của nút
                        child: Text(
                          'Phân tích',
                          style: TextStyle(
                            color: selectTab == 0
                                ? Colors.yellow
                                : Colors
                                    .black, // Chữ sẽ có màu vàng nếu tab được chọn, màu đen nếu không
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 0), // Khoảng cách nhỏ giữa hai nút

                    // Nút "Tài khoản"
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.35, // Chiều dài của tab
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectTab =
                                1; // Đặt trạng thái "Tài khoản" với tab là 1 khi click
                            // Hiển thị trang khác khi nhấn vào "Tài khoản"
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsView(selectTab: 1), // Chuyển đến trang SettingsView
                              ),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectTab == 1
                              ? Colors.black
                              : const Color(
                                  0xffFFDA47), // Nền đen khi được chọn, vàng khi không được chọn
                          padding: const EdgeInsets.symmetric(
                              vertical: 15), // Padding để tăng chiều cao nút
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(7.0),
                              bottomRight: Radius.circular(7.0),
                            ),
                          ),
                          side: const BorderSide(
                            color: Colors.black, // Đường viền đen
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          'Tài khoản',
                          style: TextStyle(
                            color: selectTab == 1
                                ? Colors.yellow
                                : Colors
                                    .black, // Chữ vàng khi được chọn, đen khi không được chọn
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

          Container(
            width: MediaQuery.of(context).size.width *
                0.9, // Tăng chiều rộng của khối
            padding: const EdgeInsets.all(20), // Padding xung quanh nội dung
            decoration: BoxDecoration(
              color: TColor.yellowHeader, // Màu nền vàng cho phần khối chính
              borderRadius: BorderRadius.circular(12), // Bo góc các cạnh
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Màu bóng đổ nhẹ
                  blurRadius: 6, // Độ mờ của bóng
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Căn đều các phần tử
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Giá trị ròng",
                          style: TextStyle(
                              fontSize: 14, color: TColor.gray), // Màu chữ xám
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "0",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Tài sản",
                          style: TextStyle(
                              fontSize: 14, color: TColor.gray), // Màu chữ xám
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "0",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Nợ phải trả",
                          style: TextStyle(
                              fontSize: 14, color: TColor.gray), // Màu chữ xám
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "0",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Khoảng cách giữa các khối

          // Khối "Thêm tài khoản" và "Quản lý tài khoản" với màu nền riêng
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 15), // Padding giữa các button
            color: const Color(0xFFF5F5F5), // Màu nền của khối này
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Căn đều hai nút
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Hành động khi nhấn vào "Thêm tài khoản"
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30), // Padding nút
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bo góc nút
                    ),
                    backgroundColor: TColor.white, // Nền trắng cho nút
                    side: BorderSide(
                      color: TColor.gray, // Đường viền xám
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    'Thêm tài khoản',
                    style: TextStyle(
                      color: Colors.black, // Màu chữ đen
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Hành động khi nhấn vào "Quản lý tài khoản"
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30), // Padding nút
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bo góc nút
                    ),
                    backgroundColor: TColor.white, // Nền trắng cho nút
                    side: BorderSide(
                      color: TColor.gray, // Đường viền xám
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    'Quản lý tài khoản',
                    style: TextStyle(
                      color: Colors.black, // Màu chữ đen
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
