import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class WasteClassifierAPI {
  static const String apiUrl =
      "https://nabaouladyahich-ecodetect-api.hf.space/predict";

  static Future<Map<String, dynamic>> classifyImage(File imageFile) async {
    var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var res = await request.send();
    var responseBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      throw Exception("API Error: ${res.statusCode}");
    }
  }
}
