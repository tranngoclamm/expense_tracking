import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  String _selectedFrequency = "Một lần";

  final List<String> _frequencies = ["Một lần", "Hàng ngày", "Hàng tuần", "Hàng tháng"];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    tz.initializeTimeZones(); // Khởi tạo timezone

    // Cấu hình Android
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification() async {
    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      _titleController.text, // Tiêu đề
      _noteController.text, // Nội dung
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Nhắc nhở',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã đặt nhắc nhở!")));
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo Nhắc Nhở', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 254, 221, 85),
        iconTheme: const IconThemeData(color: Colors.black),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Tên mục nhắc')),
            TextField(controller: _noteController, decoration: const InputDecoration(labelText: 'Ghi chú')),
            ListTile(
              title: Text("Ngày bắt đầu: ${_selectedDate.toLocal()}".split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2101));
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            ListTile(
              title: Text("Thời gian: ${_selectedTime.format(context)}"),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);
                if (picked != null) setState(() => _selectedTime = picked);
              },
            ),
            DropdownButtonFormField(
              value: _selectedFrequency,
              items: _frequencies.map((String frequency) {
                return DropdownMenuItem(value: frequency, child: Text(frequency));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedFrequency = value as String);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700], // Nền vàng
                foregroundColor: Colors.black,  // Chữ đen
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Bo góc nhẹ
                ),
              ),
              child: const Text("Đặt Nhắc Nhở"),
            ),

          ],
        ),
      ),
    );
  }
}
