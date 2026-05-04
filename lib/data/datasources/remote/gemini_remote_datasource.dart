import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiRemoteDataSource {
  final GenerativeModel _model;

  GeminiRemoteDataSource({required String apiKey})
    : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  Future<Map<String, dynamic>> extractDataFromReceipt(File image) async {
    final imageBytes = await image.readAsBytes();
    final prompt = TextPart('''
      Analyze this receipt/invoice. Extract the product name, the date of purchase (YYYY-MM-DD), 
      and the warranty duration in months. 
      Respond ONLY with a valid JSON object using this exact structure:
      {"productName": "string", "purchaseDate": "YYYY-MM-DD", "warrantyDurationMonths": number}
      Do not include markdown or code blocks.
    ''');

    final imagePart = DataPart('image/jpeg', imageBytes);

    final response = await _model.generateContent([
      Content.multi([prompt, imagePart]),
    ]);

    final jsonString = response.text?.trim() ?? '{}';
    return jsonDecode(jsonString);
  }
}
