import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackizer/view/add_subscription/add_subscription_view.dart';
import 'package:trackizer/view/card/cards_view.dart';
import 'package:trackizer/view/home/home_screen.dart';
import '../../common/color_extension.dart';
import '../calender/calender_view.dart';
import '../spending_budgets/spending_budgets_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentTabView = HomeScreen();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: Stack(children: [
        PageStorage(bucket: pageStorageBucket, child: currentTabView),
        SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.11,
                          decoration: const BoxDecoration(
                            color: Colors
                                .white, // Màu nền của container được đặt trong BoxDecoration
                            border: Border(
                              top: BorderSide(
                                color: Color.fromARGB(255, 217, 217, 217),
                                width: 0.5, // Độ dày của border là 1px
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: MediaQuery.of(context).size.width *
                              0.085, // Padding trên 20px
                          left: 0, // Đảm bảo nằm đầy đủ trên chiều ngang
                          right: 0, // Đảm bảo nằm đầy đủ trên chiều ngang
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectTab = 0;
                                        currentTabView = HomeScreen();
                                      });
                                    },
                                    icon: Image.asset(
                                      "assets/img/file.png",
                                      width: 28,
                                      height: 28,
                                      color: selectTab == 0
                                          ? const Color(0xfffadf73)
                                          : const Color(
                                              0xff787878), // Màu đen khi không được chọn
                                    ),
                                  ),
                                  // const SizedBox(height: 1), // Khoảng cách giữa icon và chữ chú thích
                                  Text(
                                    "Trang chủ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: selectTab == 0
                                          ? const Color(
                                              0xfffadf73) // Màu vàng khi được chọn
                                          : const Color(
                                              0xff787878), // Màu đen khi không được chọn
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectTab = 1;
                                        currentTabView =
                                            const SpendingBudgetsView();
                                      });
                                    },
                                    icon: Image.asset(
                                      "assets/img/analytics.png",
                                      width: 28,
                                      height: 28,
                                      color: selectTab == 1
                                          ? const Color(0xfffadf73)
                                          : const Color(
                                              0xff787878), // Màu đen khi không được chọn
                                    ),
                                  ),
                                  // const SizedBox(height: 1), // Khoảng cách giữa icon và chữ chú thích
                                  Text(
                                    "Biểu đồ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: selectTab == 1
                                          ? const Color(
                                              0xfffadf73) // Màu vàng khi được chọn
                                          : const Color(
                                              0xff787878), // Màu đen khi không được chọn
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 50,
                                height: 50,
                              ),
                              Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectTab = 2;
                                        currentTabView = const CalenderView();
                                      });
                                    },
                                    icon: Image.asset(
                                      "assets/img/statistics.png",
                                      width: 28,
                                      height: 28,
                                      color: selectTab == 2
                                          ? const Color(0xfffadf73)
                                          : const Color(
                                              0xff787878), // Màu đen khi không được chọn
                                    ),
                                  ),
                                  // const SizedBox(height: 1), // Khoảng cách giữa icon và chữ chú thích
                                  Text(
                                    "Báo cáo",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: selectTab == 2
                                          ? const Color(
                                              0xfffadf73) // Màu vàng khi được chọn
                                          : const Color(
                                              0xff787878), // Màu đen khi không được chọn
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectTab = 3;
                                        currentTabView = ProfileScreen();
                                      });
                                    },
                                    icon: Image.asset(
                                      "assets/img/user.png",
                                      width: 28,
                                      height: 28,
                                      color: selectTab == 3
                                          ? const Color(0xfffadf73)
                                          : const Color(
                                              0xff787878), // Màu đen khi không được chọn
                                    ),
                                  ),
                                  // const SizedBox(height: 1), // Khoảng cách giữa icon và chữ chú thích
                                  Text(
                                    "Tôi",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: selectTab == 3
                                          ? const Color(
                                              0xfffadf73) // Màu vàng khi được chọn
                                          : const Color(
                                              0xff787878), // Màu đen khi không được chọn
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.width * 0.12),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: TColor.secondary.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ], borderRadius: BorderRadius.circular(50)),
                        child: Container(
                          width: 55, // Chiều rộng 50px
                          height: 55, // Chiều cao 50px
                          decoration: const BoxDecoration(
                            color: Color(0xffFFDA47), // Màu vàng
                            shape: BoxShape.circle, // Hình tròn
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add, // Dấu cộng
                              color: Color.fromARGB(255, 65, 65, 65), // Màu đen
                              size: 30, // Kích thước dấu cộng
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddSubScriptionView()));
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}

class LineAndArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 199, 199, 199)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Vẽ đường thẳng từ trái sang phải, dừng lại trước và tiếp tục sau nửa cung tròn
    final startPoint1 = Offset(0, size.height / 2);
    final endPoint1 = Offset(size.width / 2 - 20, size.height / 2);
    final startPoint2 = Offset(size.width / 2 + 20, size.height / 2);
    final endPoint2 = Offset(size.width, size.height / 2);
    canvas.drawLine(startPoint1, endPoint1, paint);
    canvas.drawLine(startPoint2, endPoint2, paint);

    // Vẽ nửa cung tròn ở giữa
    final arcRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 40,
      height: 30,
    );
    canvas.drawArc(
      arcRect,
      0, // Góc bắt đầu (radians)
      -3.14, // Góc quét (radians) - nửa cung tròn
      false, // Không vẽ đường thẳng nối tâm
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
