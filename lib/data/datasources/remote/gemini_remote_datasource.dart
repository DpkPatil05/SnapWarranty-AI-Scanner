import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/constants/ai_prompts.dart';
import '../../../core/error/exceptions.dart';

class GeminiRemoteDataSource {
  final GenerativeModel _model;

  GeminiRemoteDataSource({required String apiKey})
    : _model = GenerativeModel(
        model: 'gemini-3.8-flash',
        apiKey: apiKey.trim(),
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      ) {
    final cleanKey = apiKey.trim();
    final preview = cleanKey.length > 8
        ? '${cleanKey.substring(0, 4)}...${cleanKey.substring(cleanKey.length - 4)} (length: ${cleanKey.length})'
        : '[invalid/empty: length ${cleanKey.length}]';
    dev.log(
      'GeminiRemoteDataSource initialized with key: $preview',
      name: 'GeminiRemote',
    );
  }

  Future<Map<String, dynamic>> extractDataFromReceipt(File file) async {
    dev.log('extractDataFromReceipt: Reading bytes', name: 'GeminiRemote');
    try {
      final bytes = await file.readAsBytes();

      final extension = file.path.split('.').last.toLowerCase();
      String mimeType;

      if (extension == 'pdf') {
        mimeType = 'application/pdf';
      } else if (extension == 'png') {
        mimeType = 'image/png';
      } else {
        mimeType = 'image/jpeg';
      }

      dev.log('MimeType: $mimeType', name: 'GeminiRemote');

      final prompt = AiPrompts.receiptWarrantyExtraction;

      final content = [
        Content.multi([TextPart(prompt), DataPart(mimeType, bytes)]),
      ];

      dev.log(
        'Generating content via Gemini 3.8 Flash...',
        name: 'GeminiRemote',
      );
      final response = await _model.generateContent(content);
      final responseText = response.text?.trim() ?? '{}';
      dev.log('Raw response received', name: 'GeminiRemote');

      String cleanedJson = responseText.trim();
      if (cleanedJson.startsWith('```json')) {
        cleanedJson = cleanedJson.substring(7);
      } else if (cleanedJson.startsWith('```')) {
        cleanedJson = cleanedJson.substring(3);
      }
      if (cleanedJson.endsWith('```')) {
        cleanedJson = cleanedJson.substring(0, cleanedJson.length - 3);
      }
      cleanedJson = cleanedJson.trim();

      return jsonDecode(cleanedJson) as Map<String, dynamic>;
    } on GenerativeAIException catch (e) {
      dev.log('Gemini AI Exception', error: e, name: 'GeminiRemote');
      if (e.message.contains('503') || e.message.contains('UNAVAILABLE')) {
        throw AiProcessingException('AI is currently busy', isBusy: true);
      }
      if (e.message.contains('not found') ||
          e.message.contains('blocked') ||
          e.message.contains('API_KEY_SERVICE_BLOCKED')) {
        throw AiProcessingException(
          'Gemini API key is invalid, restricted, or blocked for Generative Language API. Ensure you are using a key from Google AI Studio (https://aistudio.google.com/apikey).',
        );
      }
      throw AiProcessingException('AI extraction failed: ${e.message}');
    } catch (e, st) {
      dev.log(
        'Unexpected error in extractDataFromReceipt',
        name: 'GeminiRemote',
        error: e,
        stackTrace: st,
      );
      throw AiProcessingException('Failed to process document');
    }
  }
}
