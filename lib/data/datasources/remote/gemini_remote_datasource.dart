import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiRemoteDataSource {
  final GenerativeModel _model;

  GeminiRemoteDataSource({required String apiKey})
    : _model = GenerativeModel(
        // Upgrading to the stable Gemini 2.0 Flash - the 2026 standard
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
      );

  Future<Map<String, dynamic>> extractDataFromReceipt(File image) async {
    dev.log('extractDataFromReceipt: Reading bytes', name: 'GeminiRemote');
    try {
      final bytes = await image.readAsBytes();

      // Determine mime type based on file extension
      final extension = image.path.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
      dev.log('MimeType: $mimeType', name: 'GeminiRemote');

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
        Content.multi([TextPart(prompt), DataPart(mimeType, bytes)]),
      ];

      dev.log(
        'Generating content via Gemini 2.0 Flash...',
        name: 'GeminiRemote',
      );
      final response = await _model.generateContent(content);
      final responseText = response.text?.trim() ?? '{}';
      dev.log('Raw response received', name: 'GeminiRemote');

      // Clean up the response in case the model included markdown blocks
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
      throw Exception('Failed to extract data via Gemini 2.0: $e');
    }
  }
}
