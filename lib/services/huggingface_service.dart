import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ClassificationResult {
  final String predictedClass;
  final double confidence;

  ClassificationResult({
    required this.predictedClass,
    required this.confidence,
  });
}

class HuggingFaceService {
  static const String baseUrl =
      "https://nabaouladyahich-ecodetect-api.hf.space";

  static Future<String> _sendImageForProcessing(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final body = {
      "data": [
        {
          "path": null,
          "url": "data:image/jpeg;base64,$base64Image",
        }
      ]
    };

    final response = await http.post(
      Uri.parse("$baseUrl/gradio_api/call/predict"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "POST failed ${response.statusCode}: ${response.body}",
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final eventId = decoded["event_id"];
    if (eventId == null) {
      throw Exception("Missing event_id in response: $decoded");
    }
    return eventId.toString();
  }


  static Future<Map<String, dynamic>> _getResult(String eventId) async {
    final url = "$baseUrl/gradio_api/call/predict/$eventId";

    while (true) {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception(
          "GET failed ${response.statusCode}: ${response.body}",
        );
      }

      final raw = response.body.trim();
      // Debug –
      // print("SSE raw:\n$raw");

      // SSE like:
      // event: complete
      // data: [{"label": "paper", "confidences": [...]}]
      final lines = raw.split('\n');
      String? dataLine;
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.startsWith('data:')) {
          dataLine = trimmed.substring(5).trim();
        }
      }

      if (dataLine == null || dataLine.isEmpty || dataLine == 'null') {
        await Future.delayed(const Duration(milliseconds: 300));
        continue;
      }

      try {
        final decoded = jsonDecode(dataLine);


        // [ { "label": "paper", "confidences": [...] } ]
        if (decoded is List && decoded.isNotEmpty) {
          final first = decoded.first;
          if (first is Map<String, dynamic> && first["label"] != null) {
            return first; // ✅ {label: paper, confidences: [...]}
          }
        }

        // Fallback: sometimes Spaces send a direct object
        if (decoded is Map<String, dynamic> && decoded["label"] != null) {
          return decoded;
        }

        // If we got here, we didn't see the final payload yet
        await Future.delayed(const Duration(milliseconds: 300));
      } on FormatException {
        // Not valid JSON yet, try again
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
  }

  static Future<ClassificationResult> classifyImage(File imageFile) async {
    try {
      // 1) POST –
      final eventId = await _sendImageForProcessing(imageFile);

      // 2) Poll GET –
      final result = await _getResult(eventId);

      // Now result is exactly:
      // { "label": "paper",
      //   "confidences": [
      //      {"label": "paper", "confidence": ...},
      //      {"label": "metal", "confidence": ...},
      //      ...
      //   ]
      // }

      final predictedClass = (result["label"] ?? "Unknown").toString();

      double confidence = 0.0;
      if (result["confidences"] is List &&
          (result["confidences"] as List).isNotEmpty) {
        final firstConf = (result["confidences"] as List).first;
        if (firstConf is Map<String, dynamic> &&
            firstConf["confidence"] is num) {
          confidence = (firstConf["confidence"] as num).toDouble();
        }
      }

      return ClassificationResult(
        predictedClass: predictedClass,
        confidence: confidence,
      );
    } catch (e) {
      throw Exception("Classification failed: $e");
    }
  }
}
