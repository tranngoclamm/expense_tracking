import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/model/category.dart';
import 'package:trackizer/model/transaction.dart';
// import 'package:trackizer/service/category.dart';
import 'package:trackizer/service/transation.dart';
import 'package:trackizer/model/user.dart';
import 'package:provider/provider.dart';
import 'package:trackizer/view/home/home_screen.dart';
import 'package:trackizer/view/main_tab/main_tab_view.dart';

int selectedIndex = -1; // Chỉ mục được chọn hiện tại

const List<String> chartType = <String>['Chi phí', 'Thu nhập'];

String selectTab = 'expense';

class AddSubScriptionView extends StatefulWidget {
  const AddSubScriptionView({super.key});

  @override
  State<AddSubScriptionView> createState() => _AddSubScriptionViewState();
}

class _AddSubScriptionViewState extends State<AddSubScriptionView> {
  List<Category> categories = [];
  Category? selectedCategory;
  String selectTab = 'expense';

  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  void _getCategory() async {
    try {
      // Đọc file JSON từ assets
      String jsonString = await rootBundle.loadString('assets/img/categories.json');

      // Chuyển đổi JSON thành danh sách
      List<dynamic> jsonList = json.decode(jsonString);

      // Chuyển đổi từng phần tử thành Category
      List<Category> loadedCategories = jsonList.map((json) => Category.fromJson(json)).toList();

      // Cập nhật state với danh sách mới
      setState(() {
        categories = loadedCategories;
      });
    } catch (e) {
      print("Error loading categories: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    List<Category> filteredCategories = categories
        .where((category) =>
    category.type == (selectTab == 'expense' ? 'Expense' : 'Income'))
        .toList();


    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        children: [
          // Grid với 4 cột
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.185),
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1,
              ),
              // Lọc các mục dựa trên loại Expenses hoặc Income
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                var item = filteredCategories[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = item;
                    });
                    if (user != null) {
                      _showNumberInputDialog(context, item, user);
                    } else {
                      // Xử lý trường hợp user là null nếu cần
                      print("User is null");
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: selectedCategory == item
                              ? Colors.yellow
                              : Color(0xffe6e6e6),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: SizedBox(
                            child: Image.asset(
                              item.icon,
                              width: 20.0,
                              height: 20.0,
                              color: selectedCategory == item
                                  ? const Color.fromARGB(255, 142, 142, 142)
                                  : Color.fromARGB(255, 154, 154, 154),
                              colorBlendMode: selectedCategory == item
                                  ? BlendMode.srcIn
                                  : BlendMode.modulate,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        item.name,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 62, 62, 62),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: TColor.yellowHeader,
              height: MediaQuery.of(context).size.height * 0.165,
              child: Column(
                children: [
                  const SizedBox(
                      height: 40), // Khoảng cách giữa dropdown và các button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0), // Padding trái phải 10px
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Căn đều các widget trong Row
                      children: [
                        // Text "Hủy" có gán sự kiện
                        GestureDetector(
                          onTap: () {
                            // Xử lý sự kiện khi nhấn vào "Hủy"
                            selectedIndex = -1;
                            Navigator.pop(context); // Quay lại màn hình trước
                          },
                          child: const Text(
                            'Hủy',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors
                                  .black, // Bạn có thể thay đổi màu nếu cần
                            ),
                          ),
                        ),

                        // Text "Thêm" ở giữa, font 15 bold
                        const Text(
                          'Thêm',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.black, // Bạn có thể thay đổi màu nếu cần
                          ),
                        ),

                        // Icon lịch
                        IconButton(
                          onPressed: () {
                            // Xử lý sự kiện khi nhấn vào icon lịch
                            print("Calendar icon tapped");
                          },
                          icon: const Icon(
                            Icons.calendar_today,
                            color:
                                Colors.black, // Bạn có thể thay đổi màu nếu cần
                          ),
                        ),
                      ],
                    ),
                  ),

                  //fixed header
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 6), // Thêm padding bottom 20px
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = -1;
                              selectTab = 'expense'; // Chọn nút "Chi phí"
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectTab == 'expense'
                                ? const Color.fromARGB(
                                    255, 5, 5, 5) // Nền đen khi được chọn
                                : const Color(
                                    0xffFFDA47), // Nền trong suốt khi không được chọn
                            side: BorderSide(
                              color: selectTab == 'expense'
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 17.0,
                              horizontal: 57.0,
                            ),
                          ),
                          child: Text(
                            'Chi phí',
                            style: TextStyle(
                              fontSize: 15,
                              color: selectTab == 'expense'
                                  ? const Color.fromARGB(255, 254, 221,
                                      85) // Chữ vàng khi được chọn
                                  : Colors.black, // Chữ đen khi không được chọn
                            ),
                          ),
                        ),
                        const SizedBox(width: 0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = -1;
                              selectTab = 'income'; // Chọn nút "Thu nhập"
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectTab == 'income'
                                ? const Color.fromARGB(
                                    255, 5, 5, 5) // Nền đen khi được chọn
                                : const Color(
                                    0xffFFDA47), // Nền trong suốt khi không được chọn
                            side: BorderSide(
                              color: selectTab == 'income'
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 17.0,
                              horizontal: 53.0,
                            ),
                          ),
                          child: Text(
                            'Thu nhập',
                            style: TextStyle(
                              fontSize: 15,
                              color: selectTab == 'income'
                                  ? const Color.fromARGB(255, 254, 221,
                                      85) // Chữ vàng khi được chọn
                                  : Colors.black, // Chữ đen khi không được chọn
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

void _showNumberInputDialog(
    BuildContext context, Category category, AppUser user) {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          Future<void> _selectDate(BuildContext context) async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != selectedDate) {
              setModalState(() {
                selectedDate = picked;
              });
            }
          }

          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              setState(() {
                selectedCategory = null;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: GestureDetector(
                onTap: () {},
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Nhập thông tin cho ${category.name}",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Số tiền'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(labelText: 'Mô tả'),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ngày: ${DateFormat.yMd().format(selectedDate)}",
                              style: TextStyle(fontSize: 16),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: Text("Chọn ngày"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final transaction = Transactions(
                              id: '',
                              uid: user.uid!,
                              amount: int.tryParse(amountController.text) ?? 0,
                              category: category,
                              description: descriptionController.text,
                              date: selectedDate,
                            );

                            final transactionService = TransactionService();
                            await transactionService.addTransaction(transaction);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainTabView()),
                            );
                            setState(() {
                              selectedCategory = null;
                            });
                          },
                          child: Text("Lưu"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    setState(() {
      selectedCategory = null;
    });
  });
}

}
