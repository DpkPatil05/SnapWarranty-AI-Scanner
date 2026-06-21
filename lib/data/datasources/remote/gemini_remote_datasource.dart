import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiRemoteDataSource {
  final GenerativeModel _model;

  GeminiRemoteDataSource({required String apiKey})
    : _model = GenerativeModel(model: 'gemini-3.5-flash', apiKey: apiKey);

  Future<Map<String, dynamic>> extractDataFromReceipt(File image) async {
    dev.log('extractDataFromReceipt: Reading bytes', name: 'GeminiRemote');
    try {
      final bytes = await image.readAsBytes();

      final extension = image.path.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

      final prompt = '''
        Analyze this receipt/invoice image. 
        Extract the following information:
        1. Product Name (be specific, e.g., "Logitech G502 Mouse")
        2. Date of Purchase (format as YYYY-MM-DD)
        3. Warranty Duration in months: 
           - ONLY extract this if it is EXPLICITLY mentioned in the receipt.
           - If it is not mentioned, return null for this field. 
           - DO NOT guess or estimate.

        Return ONLY a valid JSON object with this structure:
        {
          "productName": "string",
          "purchaseDate": "YYYY-MM-DD",
          "warrantyDurationMonths": number or null
        }
        Do not include any markdown formatting, backticks, or extra text.
      ''';

      final content = [
        Content.multi([TextPart(prompt), DataPart(mimeType, bytes)]),
      ];

      dev.log(
        'Generating content via Gemini 3.5 Flash...',
        name: 'GeminiRemote',
      );
      final response = await _model.generateContent(content);
      final responseText = response.text?.trim() ?? '{}';

      final cleanedJson = responseText
          .replaceFirst('```json', '')
          .replaceFirst('```', '')
          .trim();

      return jsonDecode(cleanedJson) as Map<String, dynamic>;
    } catch (e, st) {
      dev.log(
        'Error in extractDataFromReceipt',
        name: 'GeminiRemote',
        error: e,
        stackTrace: st,
      );
      throw Exception('Failed to extract data via Gemini 3.5: $e');
    }
  }
}
