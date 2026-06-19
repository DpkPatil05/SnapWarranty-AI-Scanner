import 'dart:convert';
import 'dart:io';
import 'package:firebase_ai/firebase_ai.dart';

class GeminiRemoteDataSource {
  final GenerativeModel _model;

  GeminiRemoteDataSource()
      : _model = FirebaseAI.googleAI().generativeModel(
          model: 'gemini-1.5-flash',
        );

  Future<Map<String, dynamic>> extractDataFromReceipt(File image) async {
    try {
      final bytes = await image.readAsBytes();
      
      // Determine mime type based on file extension
      final extension = image.path.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

      final prompt = '''
        Analyze this receipt/invoice image. 
        Extract the following information:
        1. Product Name (be specific, e.g., "Logitech G502 Mouse")
        2. Date of Purchase (format as YYYY-MM-DD)
        3. Warranty Duration in months (estimate if not explicitly stated, e.g., 12 for most electronics)

        Return ONLY a valid JSON object with this structure:
        {
          "productName": "string",
          "purchaseDate": "YYYY-MM-DD",
          "warrantyDurationMonths": number
        }
        Do not include any markdown formatting, backticks, or extra text.
      ''';

      final content = [
        Content.multi([
          TextPart(prompt),
          InlineDataPart(mimeType, bytes),
        ])
      ];

      final response = await _model.generateContent(content);
      final responseText = response.text?.trim() ?? '{}';

      // Clean up the response in case the model included markdown blocks
      final cleanedJson = responseText.replaceFirst('```json', '').replaceFirst('```', '').trim();
      
      return jsonDecode(cleanedJson) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to extract data via Firebase AI: $e');
    }
  }
}
