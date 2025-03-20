import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/gemini.dart';
class GeminiAI {
  static const String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GeminiConfig.apiKey}";

  static Future<String> getSpendingAdvice(List<Map<String, dynamic>> expenses) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": "Tôi có bảng chi tiêu hàng tháng như sau:\n${jsonEncode(expenses)}.\nBạn có thể phân tích và đề xuất cách tiết kiệm và quản lý chi tiêu hợp lý hơn không?"
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData["candidates"][0]["content"]["parts"][0]["text"];
    } else {
      return "Lỗi khi gọi Gemini API: ${response.body}";
    }
  }
}
